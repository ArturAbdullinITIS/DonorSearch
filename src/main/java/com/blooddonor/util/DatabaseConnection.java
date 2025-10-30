package com.blooddonor.util;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class DatabaseConnection {
    private static String url;
    private static String username;
    private static String password;

    static {
        try {
            Class.forName("org.postgresql.Driver");
            System.out.println("PG driver registereed successfully");
        } catch (ClassNotFoundException e) {
            System.err.println("PG drvier not found: " + e.getMessage());
            e.printStackTrace();
        }
        loadDatabaseProperties();

    }

    private static void loadDatabaseProperties() {
        url = "jdbc:postgresql://localhost:5434/blood_donor_system";
        username = "donor_user";
        password = "donor_password";

        try (InputStream input = DatabaseConnection.class.getClassLoader()
                .getResourceAsStream("database.properties")) {

            if (input == null) {
                System.err.println("No database.properties found, using default DB settings");
                return;
            }

            Properties props = new Properties();
            props.load(input);
            url = props.getProperty("db.url", url);        // Второй параметр - значение по умолчанию
            username = props.getProperty("db.username", username);
            password = props.getProperty("db.password", password);

            System.out.println("DB settings:");
            System.out.println("   URL: " + url);
            System.out.println("   User: " + username);
            System.out.println("   Password: " + (password != null ? "***" : "null"));

        } catch (IOException e) {
            System.err.println("Failure reading database.properties: " + e.getMessage());
        }
    }
    public static Connection getConnection() throws SQLException {
        String urlWithEncoding = url + "?useUnicode=true&characterEncoding=UTF-8";
        return DriverManager.getConnection(urlWithEncoding, username, password);
    }
}