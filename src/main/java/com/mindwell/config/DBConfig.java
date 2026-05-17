package com.mindwell.config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class DBConfig {
    private static final String DEFAULT_URL = "jdbc:mysql://localhost:3306/mindwell_nepal?useSSL=false&serverTimezone=UTC";
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
        String url = getConfigValue("DB_URL", "db.url", DEFAULT_URL);
        String username = getConfigValue("DB_USERNAME", "db.username", DEFAULT_USERNAME);
        String password = getConfigValue("DB_PASSWORD", "db.password", DEFAULT_PASSWORD);
        return DriverManager.getConnection(url, username, password);
    }

    private static String getConfigValue(String environmentName, String propertyName, String defaultValue) {
        String value = System.getenv(environmentName);
        if (value == null || value.isBlank()) {
            value = System.getProperty(propertyName);
        }
        return (value == null || value.isBlank()) ? defaultValue : value;
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
