package com.mindwell.config;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

public class DatabaseInitializer {
    private static final String SCHEMA_RESOURCE = "/database/mindwell_nepal.sql";
    private static boolean initialized;

    public static synchronized void initialize(Connection connection) throws SQLException {
        if (initialized) {
            return;
        }

        try {
            initializeDatabase(connection);
            initialized = true;
        } catch (IOException e) {
            throw new SQLException("Unable to load database schema", e);
        }
    }

    private static void initializeDatabase(Connection connection) throws IOException, SQLException {
        List<String> createStatements = new ArrayList<>();
        List<String> seedStatements = new ArrayList<>();

        for (String statement : loadStatements()) {
            String normalized = statement.trim().toLowerCase(Locale.ROOT);
            if (normalized.startsWith("create table")) {
                createStatements.add(statement);
            } else if (normalized.startsWith("insert into")) {
                seedStatements.add(statement);
            }
        }

        try (Statement statement = connection.createStatement()) {
            for (String createStatement : createStatements) {
                statement.execute(createStatement);
            }

            if (isUsersTableEmpty(statement)) {
                for (String seedStatement : seedStatements) {
                    statement.execute(seedStatement);
                }
            }
        }
    }

    private static List<String> loadStatements() throws IOException {
        InputStream inputStream = DatabaseInitializer.class.getResourceAsStream(SCHEMA_RESOURCE);
        if (inputStream == null) {
            throw new IOException("Missing schema resource: " + SCHEMA_RESOURCE);
        }

        StringBuilder sql = new StringBuilder();
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(inputStream, StandardCharsets.UTF_8))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String trimmed = line.trim();
                if (trimmed.isEmpty()
                        || trimmed.startsWith("--")
                        || trimmed.toLowerCase(Locale.ROOT).startsWith("drop database")
                        || trimmed.toLowerCase(Locale.ROOT).startsWith("create database")
                        || trimmed.toLowerCase(Locale.ROOT).startsWith("use ")) {
                    continue;
                }
                sql.append(line).append('\n');
            }
        }

        return splitStatements(sql.toString());
    }

    private static List<String> splitStatements(String sql) {
        List<String> statements = new ArrayList<>();
        StringBuilder current = new StringBuilder();
        boolean inSingleQuote = false;

        for (int i = 0; i < sql.length(); i++) {
            char character = sql.charAt(i);
            if (character == '\'' && (i == 0 || sql.charAt(i - 1) != '\\')) {
                inSingleQuote = !inSingleQuote;
            }

            if (character == ';' && !inSingleQuote) {
                addStatement(statements, current);
            } else {
                current.append(character);
            }
        }

        addStatement(statements, current);
        return statements;
    }

    private static void addStatement(List<String> statements, StringBuilder current) {
        String statement = current.toString().trim();
        if (!statement.isEmpty()) {
            statements.add(statement);
        }
        current.setLength(0);
    }

    private static boolean isUsersTableEmpty(Statement statement) {
        try (ResultSet resultSet = statement.executeQuery("SELECT COUNT(*) FROM users")) {
            return resultSet.next() && resultSet.getInt(1) == 0;
        } catch (SQLException e) {
            return true;
        }
    }
}
