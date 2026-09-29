package com.org;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    private static final String URL =
        "jdbc:mysql://localhost:3306/postsales_os"
        + "?allowPublicKeyRetrieval=true"
        + "&useSSL=false"
        + "&serverTimezone=UTC";
    private static final String USER = "root";
    private static final String PASSWORD = "Pooja@#123";

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("✅ MySQL JDBC Driver loaded.");
        } catch (ClassNotFoundException e) {
            System.err.println("❌ MySQL Driver not found!");
            e.printStackTrace();
        }
    }

    public static Connection getConnection() {
        try {
            return DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (SQLException e) {
            System.err.println("❌ DB Connection error: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }
}