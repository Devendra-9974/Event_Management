package com.clubsphere.util;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Properties;

/**
 * High-performance database connection pool manager using HikariCP.
 */
public class DBUtil {

    private static HikariDataSource dataSource;
    private static Properties props = new Properties();

    static {
        try {
            InputStream input = DBUtil.class.getClassLoader().getResourceAsStream("application.properties");
            if (input != null) {
                props.load(input);
            }

            // Explicitly load MySQL driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            String rawUrl = getEnvOrProperty("DB_URL", "db.url", "jdbc:mysql://localhost:3306/clubsphere_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC");
            String username = getEnvOrProperty("DB_USERNAME", "db.username", "root");
            String password = getEnvOrProperty("DB_PASSWORD", "db.password", "root");

            boolean isEnvUrl = System.getenv("DB_URL") != null && !System.getenv("DB_URL").trim().isEmpty();
            boolean isEnvUser = System.getenv("DB_USERNAME") != null && !System.getenv("DB_USERNAME").trim().isEmpty();
            boolean isEnvPass = System.getenv("DB_PASSWORD") != null && !System.getenv("DB_PASSWORD").trim().isEmpty();

            // Extract host and database name safely without exposing credentials
            String maskedUrl = rawUrl.replaceAll(":[^/@]+@", ":***@");
            String host = "unknown";
            String dbName = "unknown";
            try {
                int protoIdx = rawUrl.indexOf("//");
                if (protoIdx != -1) {
                    String afterProto = rawUrl.substring(protoIdx + 2);
                    int slashIdx = afterProto.indexOf('/');
                    if (slashIdx != -1) {
                        host = afterProto.substring(0, slashIdx);
                        int questionIdx = afterProto.indexOf('?', slashIdx);
                        if (questionIdx != -1) {
                            dbName = afterProto.substring(slashIdx + 1, questionIdx);
                        } else {
                            dbName = afterProto.substring(slashIdx + 1);
                        }
                    }
                }
            } catch (Exception parseEx) {
                // Ignore parse errors
            }

            System.out.println("================== [DB_DIAG START] ==================");
            System.out.println("[DB_DIAG] DB_URL read from environment: " + isEnvUrl);
            System.out.println("[DB_DIAG] DB_USERNAME read from environment: " + isEnvUser);
            System.out.println("[DB_DIAG] DB_PASSWORD read from environment: " + isEnvPass);
            System.out.println("[DB_DIAG] Target Host: " + host);
            System.out.println("[DB_DIAG] Target Database Name: " + dbName);
            System.out.println("[DB_DIAG] Target JDBC URL: " + maskedUrl);
            System.out.println("[DB_DIAG] Target DB Username: " + username);

            HikariConfig config = new HikariConfig();
            config.setJdbcUrl(rawUrl);
            config.setUsername(username);
            config.setPassword(password);

            int maxPoolSize = Integer.parseInt(props.getProperty("db.pool.maximumPoolSize", "10"));
            int minIdle = Integer.parseInt(props.getProperty("db.pool.minimumIdle", "2"));
            config.setMaximumPoolSize(maxPoolSize);
            config.setMinimumIdle(minIdle);
            config.setIdleTimeout(Long.parseLong(props.getProperty("db.pool.idleTimeout", "30000")));
            config.setConnectionTimeout(Long.parseLong(props.getProperty("db.pool.connectionTimeout", "20000")));
            config.setPoolName("ClubSphere-HikariPool");

            // Recommended MySQL cache settings
            config.addDataSourceProperty("cachePrepStmts", "true");
            config.addDataSourceProperty("prepStmtCacheSize", "250");
            config.addDataSourceProperty("prepStmtCacheSqlLimit", "2048");
            config.addDataSourceProperty("useServerPrepStmts", "true");

            dataSource = new HikariDataSource(config);
            System.out.println("[DB_DIAG] HikariDataSource initialized: SUCCESS");

            // Test connection and execute SELECT DATABASE(), COUNT(*) FROM users
            try (Connection conn = dataSource.getConnection()) {
                System.out.println("[DB_DIAG] getConnection() test: SUCCESS (Valid connection obtained)");
                try (Statement stmt = conn.createStatement();
                     ResultSet rs = stmt.executeQuery("SELECT DATABASE(), COUNT(*) FROM users")) {
                    if (rs.next()) {
                        String activeDb = rs.getString(1);
                        int count = rs.getInt(2);
                        System.out.println("[DB_DIAG] Query executed: SELECT DATABASE(), COUNT(*) FROM users");
                        System.out.println("[DB_DIAG] Query result: DATABASE() = " + activeDb + ", COUNT(*) = " + count);
                    }
                }
            } catch (SQLException testEx) {
                System.err.println("[DB_DIAG] Initial connection test or SELECT query FAILED: " + testEx.getMessage());
                testEx.printStackTrace();
            }
            System.out.println("================== [DB_DIAG END] ====================");
        } catch (Exception e) {
            System.err.println("================== [DB_DIAG CRITICAL ERROR] ==================");
            System.err.println("[DB_DIAG] CRITICAL: Failed to initialize HikariCP connection pool: " + e.getMessage());
            e.printStackTrace();
            System.err.println("==============================================================");
        }
    }

    private static String getEnvOrProperty(String envKey, String propKey, String defaultValue) {
        String envVal = System.getenv(envKey);
        if (envVal != null && !envVal.trim().isEmpty()) {
            return envVal.trim();
        }
        // Handle common cloud database alias variables
        if ("DB_URL".equals(envKey)) {
            String alt = System.getenv("DATABASE_URL");
            if (alt != null && !alt.trim().isEmpty()) {
                String trimmed = alt.trim();
                return trimmed.startsWith("jdbc:") ? trimmed : "jdbc:" + trimmed;
            }
        } else if ("DB_USERNAME".equals(envKey)) {
            String altUser = System.getenv("DB_USER");
            if (altUser == null || altUser.isBlank()) altUser = System.getenv("MYSQLUSER");
            if (altUser != null && !altUser.trim().isEmpty()) return altUser.trim();
        } else if ("DB_PASSWORD".equals(envKey)) {
            String altPass = System.getenv("MYSQLPASSWORD");
            if (altPass != null && !altPass.trim().isEmpty()) return altPass.trim();
        }

        String sysProp = System.getProperty(envKey);
        if (sysProp != null && !sysProp.trim().isEmpty()) {
            return sysProp.trim();
        }
        return props.getProperty(propKey, defaultValue);
    }

    private DBUtil() {}

    public static Connection getConnection() throws SQLException {
        if (dataSource == null) {
            throw new SQLException("Database connection pool is not initialized. Please ensure MySQL server is running and credentials in application.properties are valid.");
        }
        return dataSource.getConnection();
    }

    public static String getProperty(String key, String defaultValue) {
        String envKey = key.toUpperCase().replace('.', '_');
        String envVal = System.getenv(envKey);
        if (envVal != null && !envVal.trim().isEmpty()) {
            return envVal.trim();
        }
        String sysProp = System.getProperty(envKey);
        if (sysProp != null && !sysProp.trim().isEmpty()) {
            return sysProp.trim();
        }
        return props.getProperty(key, defaultValue);
    }

    public static void shutdown() {
        if (dataSource != null && !dataSource.isClosed()) {
            dataSource.close();
        }
    }
}
