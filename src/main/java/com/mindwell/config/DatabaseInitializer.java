package com.mindwell.config;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
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
            if (isPostgreSql(connection)) {
                initializePostgreSql(connection);
            } else {
                initializeMySql(connection);
            }
            initialized = true;
        } catch (IOException e) {
            throw new SQLException("Unable to load database schema", e);
        }
    }

    private static boolean isPostgreSql(Connection connection) throws SQLException {
        DatabaseMetaData metaData = connection.getMetaData();
        return metaData.getDatabaseProductName().toLowerCase(Locale.ROOT).contains("postgres");
    }

    private static void initializePostgreSql(Connection connection) throws SQLException {
        try (Statement statement = connection.createStatement()) {
            executeStatements(statement, POSTGRES_CREATE_STATEMENTS);
            if (isUsersTableEmpty(statement)) {
                executeStatements(statement, POSTGRES_SEED_STATEMENTS);
            }
        }
    }

    private static void executeStatements(Statement statement, String[] statements) throws SQLException {
        for (String sql : statements) {
            statement.execute(sql);
        }
    }

    private static void initializeMySql(Connection connection) throws IOException, SQLException {
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

    private static final String[] POSTGRES_CREATE_STATEMENTS = {
            """
            CREATE TABLE IF NOT EXISTS users (
              user_id SERIAL PRIMARY KEY,
              full_name VARCHAR(120) NOT NULL,
              email VARCHAR(160) NOT NULL UNIQUE,
              password VARCHAR(255) NOT NULL,
              phone VARCHAR(30),
              city VARCHAR(80),
              user_type VARCHAR(20) NOT NULL DEFAULT 'user'
                CHECK (user_type IN ('user', 'counselor', 'admin', 'super_admin')),
              requested_user_type VARCHAR(20) NOT NULL DEFAULT 'user'
                CHECK (requested_user_type IN ('user', 'counselor', 'admin')),
              account_status VARCHAR(20) NOT NULL DEFAULT 'pending'
                CHECK (account_status IN ('pending', 'approved', 'rejected', 'disabled')),
              created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
            )
            """,
            """
            CREATE TABLE IF NOT EXISTS counselors (
              counselor_id SERIAL PRIMARY KEY,
              user_id INT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
              specialization VARCHAR(120) NOT NULL,
              experience_years INT NOT NULL DEFAULT 0,
              bio TEXT,
              consultation_fee NUMERIC(10, 2) NOT NULL DEFAULT 0.00,
              is_available BOOLEAN NOT NULL DEFAULT TRUE,
              is_verified BOOLEAN NOT NULL DEFAULT FALSE,
              created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
            )
            """,
            """
            CREATE TABLE IF NOT EXISTS bookings (
              booking_id SERIAL PRIMARY KEY,
              user_id INT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
              counselor_id INT NOT NULL REFERENCES counselors(counselor_id) ON DELETE CASCADE,
              booking_date DATE NOT NULL,
              booking_time TIME NOT NULL,
              message TEXT,
              status VARCHAR(20) NOT NULL DEFAULT 'pending'
                CHECK (status IN ('pending', 'confirmed', 'cancelled', 'completed')),
              created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
            )
            """,
            "CREATE INDEX IF NOT EXISTS idx_bookings_user ON bookings (user_id)",
            "CREATE INDEX IF NOT EXISTS idx_bookings_counselor_date_time ON bookings (counselor_id, booking_date, booking_time)"
    };

    private static final String[] POSTGRES_SEED_STATEMENTS = {
            """
            INSERT INTO users (full_name, email, password, phone, city, user_type, requested_user_type, account_status)
            VALUES ('Super Admin', 'admin@mindwell.local', 'Admin@12345', NULL, 'Kathmandu', 'super_admin', 'admin', 'approved')
            ON CONFLICT (email) DO UPDATE SET
              user_type = 'super_admin',
              requested_user_type = 'admin',
              account_status = 'approved'
            """,
            """
            INSERT INTO users (full_name, email, password, phone, city, user_type, requested_user_type, account_status)
            VALUES
              ('Aarav Sharma', 'aarav.user@mindwell.local', 'User@12345', '9800000001', 'Kathmandu', 'user', 'user', 'approved'),
              ('Maya Gurung', 'maya.user@mindwell.local', 'User@12345', '9800000002', 'Pokhara', 'user', 'user', 'approved'),
              ('Pending Client', 'pending.user@mindwell.local', 'User@12345', '9800000003', 'Lalitpur', 'user', 'user', 'pending'),
              ('Dr. Sita Karki', 'sita.counselor@mindwell.local', 'Counselor@12345', '9810000001', 'Kathmandu', 'counselor', 'counselor', 'approved'),
              ('Dr. Raj Thapa', 'raj.counselor@mindwell.local', 'Counselor@12345', '9810000002', 'Bhaktapur', 'counselor', 'counselor', 'approved'),
              ('Nisha Lama', 'nisha.pending@mindwell.local', 'Counselor@12345', '9810000003', 'Dharan', 'user', 'counselor', 'pending')
            ON CONFLICT (email) DO NOTHING
            """,
            """
            INSERT INTO counselors (user_id, specialization, experience_years, bio, consultation_fee, is_available, is_verified)
            SELECT user_id, 'Anxiety, Depression, CBT', 8,
              'Licensed counselor focused on anxiety, depression, stress management, and culturally sensitive care.',
              1800.00, TRUE, TRUE
            FROM users
            WHERE email = 'sita.counselor@mindwell.local'
              AND NOT EXISTS (
                SELECT 1 FROM counselors c JOIN users u ON c.user_id = u.user_id
                WHERE u.email = 'sita.counselor@mindwell.local'
              )
            """,
            """
            INSERT INTO counselors (user_id, specialization, experience_years, bio, consultation_fee, is_available, is_verified)
            SELECT user_id, 'Family Therapy, Youth Counseling', 6,
              'Counselor supporting families, young adults, and students through relationship and academic pressure.',
              1500.00, TRUE, TRUE
            FROM users
            WHERE email = 'raj.counselor@mindwell.local'
              AND NOT EXISTS (
                SELECT 1 FROM counselors c JOIN users u ON c.user_id = u.user_id
                WHERE u.email = 'raj.counselor@mindwell.local'
              )
            """,
            """
            INSERT INTO counselors (user_id, specialization, experience_years, bio, consultation_fee, is_available, is_verified)
            SELECT user_id, 'Trauma Support, Mindfulness', 4,
              'Counselor applicant awaiting admin verification before becoming visible for booking.',
              1200.00, FALSE, FALSE
            FROM users
            WHERE email = 'nisha.pending@mindwell.local'
              AND NOT EXISTS (
                SELECT 1 FROM counselors c JOIN users u ON c.user_id = u.user_id
                WHERE u.email = 'nisha.pending@mindwell.local'
              )
            """,
            """
            INSERT INTO bookings (user_id, counselor_id, booking_date, booking_time, message, status)
            SELECT u.user_id, c.counselor_id, CURRENT_DATE + INTERVAL '2 days', TIME '10:00:00',
              'I would like support managing workplace stress.', 'pending'
            FROM users u
            JOIN counselors c ON c.user_id = (SELECT user_id FROM users WHERE email = 'sita.counselor@mindwell.local')
            WHERE u.email = 'aarav.user@mindwell.local'
            """,
            """
            INSERT INTO bookings (user_id, counselor_id, booking_date, booking_time, message, status)
            SELECT u.user_id, c.counselor_id, CURRENT_DATE + INTERVAL '4 days', TIME '14:00:00',
              'Looking for guidance with family communication.', 'confirmed'
            FROM users u
            JOIN counselors c ON c.user_id = (SELECT user_id FROM users WHERE email = 'raj.counselor@mindwell.local')
            WHERE u.email = 'maya.user@mindwell.local'
            """,
            """
            INSERT INTO bookings (user_id, counselor_id, booking_date, booking_time, message, status)
            SELECT u.user_id, c.counselor_id, CURRENT_DATE - INTERVAL '5 days', TIME '11:00:00',
              'Follow-up session.', 'completed'
            FROM users u
            JOIN counselors c ON c.user_id = (SELECT user_id FROM users WHERE email = 'raj.counselor@mindwell.local')
            WHERE u.email = 'aarav.user@mindwell.local'
            """
    };
}
