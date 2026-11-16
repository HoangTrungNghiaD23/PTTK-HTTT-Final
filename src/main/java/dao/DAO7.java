package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Lop DAO co so khoi tao ket noi JDBC toi CSDL MySQL garage_management7.
 */
public class DAO7 {
    private static final String DEFAULT_DB_URL =
            "jdbc:mysql://localhost:3306/garage_management7?useSSL=false&allowPublicKeyRetrieval=true&characterEncoding=UTF-8";
    private static final String DEFAULT_DB_USER = "root";
    private static final String DEFAULT_DB_PASS = "";

    protected Connection con;

    public DAO7() {
        initConnection();
    }

    private void initConnection() {
        String dbUrl = getEnvOrDefault("GARAGE_DB_URL", DEFAULT_DB_URL);
        String dbUser = getEnvOrDefault("GARAGE_DB_USER", DEFAULT_DB_USER);
        String dbPass = System.getenv("GARAGE_DB_PASS") != null
                ? System.getenv("GARAGE_DB_PASS")
                : DEFAULT_DB_PASS;
        try {
            loadDriver();
            this.con = DriverManager.getConnection(dbUrl, dbUser, dbPass);
        } catch (Exception e) {
            e.printStackTrace();
            this.con = null;
        }
    }

    private static String getEnvOrDefault(String key, String fallback) {
        String val = System.getenv(key);
        return (val != null && !val.trim().isEmpty()) ? val.trim() : fallback;
    }

    private static void loadDriver() throws ClassNotFoundException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException ex) {
            Class.forName("com.mysql.jdbc.Driver");
        }
    }

    /**
     * Dam bao ket noi con dang mo truoc khi thuc thi truy van.
     */
    protected boolean ensureConnection() {
        try {
            if (this.con == null || this.con.isClosed()) {
                initConnection();
            }
            return this.con != null && !this.con.isClosed();
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public void close() {
        if (this.con != null) {
            try {
                if (!this.con.isClosed()) {
                    this.con.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
