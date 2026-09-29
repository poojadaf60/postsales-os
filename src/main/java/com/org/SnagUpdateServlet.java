package com.org;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/SnagUpdateServlet")
public class SnagUpdateServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int snagId = Integer.parseInt(request.getParameter("snagId"));
        String status = request.getParameter("status");
        String assignedTo = request.getParameter("assignedTo");

        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DBConnection.getConnection();

            if ("Resolved".equalsIgnoreCase(status) || "Customer Verified".equalsIgnoreCase(status)) {
                ps = con.prepareStatement(
                    "UPDATE snags SET status=?, assigned_to=?, resolved_date=NOW() WHERE snag_id=?");
            } else {
                ps = con.prepareStatement(
                    "UPDATE snags SET status=?, assigned_to=? WHERE snag_id=?");
            }
            ps.setString(1, status);
            ps.setString(2, assignedTo);
            ps.setInt(3, snagId);

            int row = ps.executeUpdate();
            if (row > 0) {
                response.sendRedirect("SnagServlet?msg=updated");
            } else {
                response.sendRedirect("SnagServlet?msg=error");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("SnagServlet?msg=error");
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }
}