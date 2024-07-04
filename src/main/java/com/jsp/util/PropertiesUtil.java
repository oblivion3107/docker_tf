package com.jsp.util;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class PropertiesUtil {
    // Properties object to hold configuration key-value pairs
    private static Properties properties = new Properties();

    // Static block to initialize and load properties from the file
    static {
        try (InputStream input = PropertiesUtil.class.getClassLoader().getResourceAsStream("application.properties")) {
            if (input == null) {
                throw new RuntimeException("application.properties not found in classpath");
            }
            // Load the properties from the input stream
            properties.load(input);
        } catch (IOException ex) {
            System.err.println("Error loading application.properties: " + ex.getMessage());
            ex.printStackTrace();
            // Handle the error or throw a runtime exception
            throw new RuntimeException("Failed to load application.properties", ex);
        }
    }

    // Method to get property value by key
    public static String getProperty(String key) {
        return properties.getProperty(key);
    }

    // Method to get property value by key with a default value
    public static String getProperty(String key, String defaultValue) {
        return properties.getProperty(key, defaultValue);
    }

    // Main method for testing the PropertiesUtil functionality
    public static void main(String[] args) {
        // Example usage
        System.out.println("Database URL: " + PropertiesUtil.getProperty("db.url"));
        System.out.println("Database Username: " + PropertiesUtil.getProperty("db.username"));
        System.out.println("Database Password: " + PropertiesUtil.getProperty("db.password"));
    }
}
