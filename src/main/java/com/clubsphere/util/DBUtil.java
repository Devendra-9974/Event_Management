package com.clubsphere.util;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.SQLException;
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

            HikariConfig config = new HikariConfig();
            config.setJdbcUrl(getEnvOrProperty("DB_URL", "db.url", "jdbc:mysql://localhost:3306/clubsphere_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC"));
            config.setUsername(getEnvOrProperty("DB_USERNAME", "db.username", "root"));
            config.setPassword(getEnvOrProperty("DB_PASSWORD", "db.password", "root"));

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
        } catch (Exception e) {
            System.err.println("CRITICAL: Failed to initialize HikariCP connection pool: " + e.getMessage());
            e.printStackTrace();
        }
    }

    private static String getEnvOrProperty(String envKey, String propKey, String defaultValue) {
        String envVal = System.getenv(envKey);
        if (envVal != null && !envVal.trim().isEmpty()) {
            return envVal.trim();
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
