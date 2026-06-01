package com.mindwell.config;

import java.net.URI;
import java.net.URISyntaxException;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class DBConfig {
    private static final String DEFAULT_URL = "jdbc:mysql://localhost:3306/mindwell_nepal?useSSL=false&serverTimezone=UTC&connectTimeout=5000&socketTimeout=10000";
    private static final String DEFAULT_USERNAME = "root";
    private static final String DEFAULT_PASSWORD = "";
    
    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }
    
    public static Connection getConnection() throws SQLException {
        DatabaseSettings settings = getDatabaseSettings();
        Connection connection = DriverManager.getConnection(settings.url, settings.username, settings.password);
        DatabaseInitializer.initialize(connection);
        return connection;
    }

    private static DatabaseSettings getDatabaseSettings() {
        String url = getConfigValue("DB_URL", "db.url", null);
        String username = getConfigValue("DB_USERNAME", "db.username", null);
        String password = getConfigValue("DB_PASSWORD", "db.password", null);

        if (url == null) {
            url = buildRailwayJdbcUrl();
        }

        if (url == null) {
            RailwayUrl railwayUrl = parseRailwayMysqlUrl(System.getenv("MYSQL_URL"));
            if (railwayUrl != null) {
                url = railwayUrl.jdbcUrl;
                if (username == null) {
                    username = railwayUrl.username;
                }
                if (password == null) {
                    password = railwayUrl.password;
                }
            }
        }

        if (username == null) {
            username = getConfigValue("MYSQLUSER", "mysql.user", DEFAULT_USERNAME);
        }

        if (password == null) {
            password = getConfigValue("MYSQLPASSWORD", "mysql.password", DEFAULT_PASSWORD);
        }

        if (url == null) {
            url = DEFAULT_URL;
        }

        return new DatabaseSettings(url, username, password);
    }

    private static String buildRailwayJdbcUrl() {
        String host = System.getenv("MYSQLHOST");
        String port = System.getenv("MYSQLPORT");
        String database = System.getenv("MYSQLDATABASE");

        if (isBlank(host) || isBlank(database)) {
            return null;
        }

        if (isBlank(port)) {
            port = "3306";
        }

        return "jdbc:mysql://" + host + ":" + port + "/" + database
                + "?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&connectTimeout=5000&socketTimeout=10000";
    }

    private static RailwayUrl parseRailwayMysqlUrl(String mysqlUrl) {
        if (isBlank(mysqlUrl)) {
            return null;
        }

        try {
            URI uri = new URI(mysqlUrl);
            String host = uri.getHost();
            String path = uri.getPath();
            if (isBlank(host) || isBlank(path) || path.length() <= 1) {
                return null;
            }

            int port = uri.getPort() == -1 ? 3306 : uri.getPort();
            String jdbcUrl = "jdbc:mysql://" + host + ":" + port + path
                    + "?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&connectTimeout=5000&socketTimeout=10000";
            String username = null;
            String password = null;
            String userInfo = uri.getUserInfo();
            if (!isBlank(userInfo)) {
                String[] parts = userInfo.split(":", 2);
                username = decode(parts[0]);
                if (parts.length > 1) {
                    password = decode(parts[1]);
                }
            }

            return new RailwayUrl(jdbcUrl, username, password);
        } catch (URISyntaxException e) {
            return null;
        }
    }

    private static String decode(String value) {
        return URLDecoder.decode(value, StandardCharsets.UTF_8);
    }

    private static boolean isBlank(String value) {
        return value == null || value.isBlank();
    }

    private static String getConfigValue(String environmentName, String propertyName, String defaultValue) {
        String value = System.getenv(environmentName);
        if (isBlank(value)) {
            value = System.getProperty(propertyName);
        }
        return isBlank(value) ? defaultValue : value;
    }

    private static class DatabaseSettings {
        private final String url;
        private final String username;
        private final String password;

        private DatabaseSettings(String url, String username, String password) {
            this.url = url;
            this.username = username;
            this.password = password;
        }
    }

    private static class RailwayUrl {
        private final String jdbcUrl;
        private final String username;
        private final String password;

        private RailwayUrl(String jdbcUrl, String username, String password) {
            this.jdbcUrl = jdbcUrl;
            this.username = username;
            this.password = password;
        }
    }
    
    public static void closeConnection(Connection conn, PreparedStatement pstmt) {
        try {
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
