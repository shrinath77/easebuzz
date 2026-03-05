package com.easybuzz.util;

import java.io.InputStream;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ConfigUtil {

    private static final Logger LOGGER = Logger.getLogger(ConfigUtil.class.getName());
    private static Properties properties;

    static {
        loadProperties();
    }

    private static void loadProperties() {
        try {
            properties = new Properties();
            InputStream input = ConfigUtil.class.getClassLoader().getResourceAsStream("application.properties");

            if (input != null) {
                properties.load(input);
                LOGGER.info("Application properties loaded successfully");
            } else {
                LOGGER.severe("application.properties file not found in classpath");
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error loading application properties", e);
        }
    }

    public static String getProperty(String key) {
        return properties != null ? properties.getProperty(key) : null;
    }

    public static String getProperty(String key, String defaultValue) {
        String value = getProperty(key);
        return value != null ? value : defaultValue;
    }


    public static String getEasebuzzKey() {
        return getProperty("easebuzz.key");
    }

    public static String getEasebuzzSalt() {
        return getProperty("easebuzz.salt");
    }
}
