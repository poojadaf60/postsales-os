package com.org;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/ChangePasswordServlet")
public class ChangePasswordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect("Loginindex.jsp");
            return;
        }

        String oldPassword = request.getParameter("oldPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (oldPassword == null || newPassword == null || confirmPassword == null ||
            oldPassword.trim().isEmpty() || newPassword.trim().isEmpty() ||
            confirmPassword.trim().isEmpty()) {
            response.sendRedirect("Setting.jsp?pwdMsg=error");
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            response.sendRedirect("Setting.jsp?pwdMsg=mismatch");
            return;
        }

        int userId = (Integer) session.getAttribute("userid");

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();

            // Verify old password
            ps = con.prepareStatement("SELECT password FROM users WHERE id = ?");
            ps.setInt(1, userId);
            rs = ps.executeQuery();

            if (rs.next()) {
                String dbPassword = rs.getString("password");
                if (!dbPassword.equals(oldPassword)) {
                    response.sendRedirect("Setting.jsp?pwdMsg=incorrect");
                    return;
                }
            } else {
                response.sendRedirect("Setting.jsp?pwdMsg=error");
                return;
            }
            rs.close();
            ps.close();

            // Update password
            ps = con.prepareStatement("UPDATE users SET password = ? WHERE id = ?");
            ps.setString(1, newPassword);
            ps.setInt(2, userId);

            int rows = ps.executeUpdate();

            if (rows > 0) {
                response.sendRedirect("Setting.jsp?pwdMsg=success");
            } else {
                response.sendRedirect("Setting.jsp?pwdMsg=error");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("Setting.jsp?pwdMsg=error");
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }
}