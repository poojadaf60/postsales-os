package com.org;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/AddAllotteeServlet")
public class AddAllotteeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String kycStatus = request.getParameter("kyc_status");
        String password = request.getParameter("password");

        if (name == null || email == null || phone == null || address == null ||
            password == null || name.trim().isEmpty() || email.trim().isEmpty() ||
            phone.trim().isEmpty() || password.trim().isEmpty()) {
            response.sendRedirect("AllotteeManagementServlet?msg=error");
            return;
        }

        Connection con = null;
        PreparedStatement ps = null;
        PreparedStatement ps2 = null;

        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);

            ps = con.prepareStatement(
                "INSERT INTO allottees(name, email, phone, address, kyc_status, password) VALUES(?,?,?,?,?,?)",
                Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, phone);
            ps.setString(4, address);
            ps.setString(5, kycStatus != null ? kycStatus : "Pending");
            ps.setString(6, password);
            ps.executeUpdate();

            int allotteeId = 0;
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) allotteeId = keys.getInt(1);
            }
            ps.close();

            // Create customer login
            ps2 = con.prepareStatement(
                "INSERT INTO users(username, email, password, role, allottee_id) VALUES(?,?,?,?,?)");
            ps2.setString(1, name);
            ps2.setString(2, email);
            ps2.setString(3, password);
            ps2.setString(4, "Customer");
            ps2.setInt(5, allotteeId);
            ps2.executeUpdate();

            con.commit();
            response.sendRedirect("AllotteeManagementServlet?msg=success");

        } catch (Exception e) {
            e.printStackTrace();
            try { if (con != null) con.rollback(); } catch (Exception ignored) {}
            response.sendRedirect("AllotteeManagementServlet?msg=error");
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception ignored) {}
            try { if (ps2 != null) ps2.close(); } catch (Exception ignored) {}
            try { if (con != null) con.close(); } catch (Exception ignored) {}
        }
    }
}