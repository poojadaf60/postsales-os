package com.org;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/TicketUpdateServlet")
public class TicketUpdateServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int ticketId = Integer.parseInt(request.getParameter("ticketId"));
        String status = request.getParameter("status");
        String assignedTo = request.getParameter("assignedTo");

        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DBConnection.getConnection();

            if ("Resolved".equalsIgnoreCase(status) || "Closed".equalsIgnoreCase(status)) {
                ps = con.prepareStatement(
                    "UPDATE tickets SET status=?, assigned_to=?, resolved_date=NOW() WHERE ticket_id=?");
            } else {
                ps = con.prepareStatement(
                    "UPDATE tickets SET status=?, assigned_to=? WHERE ticket_id=?");
            }
            ps.setString(1, status);
            ps.setString(2, assignedTo);
            ps.setInt(3, ticketId);

            int row = ps.executeUpdate();
            if (row > 0) {
                response.sendRedirect("TicketServlet?msg=updated");
            } else {
                response.sendRedirect("TicketServlet?msg=error");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("TicketServlet?msg=error");
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }
}