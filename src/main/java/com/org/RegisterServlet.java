package com.org;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        if (username == null || email == null || password == null || confirmPassword == null ||
            username.trim().isEmpty() || email.trim().isEmpty() ||
            password.trim().isEmpty() || confirmPassword.trim().isEmpty()) {
            response.sendRedirect("Registrationindex.jsp?msg=error");
            return;
        }

        if (!password.equals(confirmPassword)) {
            response.sendRedirect("Registrationindex.jsp?msg=error");
            return;
        }

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();

            ps = con.prepareStatement("SELECT id FROM users WHERE email = ?");
            ps.setString(1, email.trim());
            rs = ps.executeQuery();

            if (rs.next()) {
                response.sendRedirect("Registrationindex.jsp?msg=exists");
                return;
            }
            rs.close();
            ps.close();

            ps = con.prepareStatement(
                "INSERT INTO users (username, email, password, role) VALUES (?, ?, ?, 'Admin')");
            ps.setString(1, username.trim());
            ps.setString(2, email.trim());
            ps.setString(3, password);

            int row = ps.executeUpdate();

            if (row > 0) {
                response.sendRedirect("Loginindex.jsp?msg=registered");
            } else {
                response.sendRedirect("Registrationindex.jsp?msg=error");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("Registrationindex.jsp?msg=error");
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }
}