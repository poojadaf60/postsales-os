package com.org;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || password == null ||
            email.trim().isEmpty() || password.trim().isEmpty()) {
            response.sendRedirect("Loginindex.jsp?msg=invalid");
            return;
        }

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(
                "SELECT id, username, email, password, role, profile_pic, allottee_id "
                + "FROM users WHERE email=?");
            ps.setString(1, email.trim());
            rs = ps.executeQuery();

            if (rs.next()) {
                String storedPwd = rs.getString("password");
                if (!password.equals(storedPwd)) {
                    response.sendRedirect("Loginindex.jsp?msg=invalid");
                    return;
                }

                HttpSession old = request.getSession(false);
                if (old != null) old.invalidate();

                HttpSession session = request.getSession(true);
                session.setAttribute("userid", rs.getInt("id"));
                session.setAttribute("username", rs.getString("username"));
                session.setAttribute("email", rs.getString("email"));
                session.setAttribute("role", rs.getString("role"));
                session.setAttribute("profilePic", rs.getString("profile_pic"));

                int allotteeId = rs.getInt("allottee_id");
                if (!rs.wasNull()) session.setAttribute("allotteeId", allotteeId);

                session.setMaxInactiveInterval(30 * 60);

                String role = rs.getString("role");
                if ("Customer".equalsIgnoreCase(role)) {
                    response.sendRedirect("CustomerDashboardServlet");
                } else {
                    response.sendRedirect("DashboardServlet");
                }
            } else {
                response.sendRedirect("Loginindex.jsp?msg=invalid");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("Loginindex.jsp?msg=error");
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception ignored) {}
            try { if (ps != null) ps.close(); } catch (Exception ignored) {}
            try { if (con != null) con.close(); } catch (Exception ignored) {}
        }
    }
}