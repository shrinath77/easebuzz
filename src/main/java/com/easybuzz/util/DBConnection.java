package com.easybuzz.util;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;


public class DBConnection {

    private static final Logger LOGGER = Logger.getLogger(DBConnection.class.getName());

    private static String URL;
    private static String USER;
    private static String PASSWORD;
    private static String DRIVER;

    static {
        try {
            Properties props = new Properties();
            InputStream input = DBConnection.class
                    .getClassLoader()
                    .getResourceAsStream("application.properties");

            if (input == null) {
                throw new RuntimeException("application.properties not found in classpath");
            }

            props.load(input);

            URL      = props.getProperty("db.url");
            USER     = props.getProperty("db.username");
            PASSWORD = props.getProperty("db.password");
            DRIVER   = props.getProperty("db.driver");

            Class.forName(DRIVER);
            LOGGER.info("MySQL Driver loaded successfully");
            LOGGER.info("DB URL: " + URL);

        } catch (ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "MySQL Driver not found on classpath", e);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Failed to load DB properties", e);
        }
    }

    public static Connection getConnection() {
        try {
            Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
            LOGGER.fine("Database connection established");
            return conn;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database connection failed", e);
            return null;
        }
    }
}