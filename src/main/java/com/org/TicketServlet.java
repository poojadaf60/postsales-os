package com.org;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/TicketServlet")
public class TicketServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        ArrayList<Ticket> tickets = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement("SELECT * FROM tickets ORDER BY ticket_id DESC");
            rs = ps.executeQuery();
            while (rs.next()) {
                Ticket t = new Ticket();
                t.setTicketId(rs.getInt("ticket_id"));
                t.setBookingId(rs.getInt("booking_id"));
                t.setSubject(rs.getString("subject"));
                t.setDescription(rs.getString("description"));
                t.setDepartment(rs.getString("department"));
                t.setAssignedTo(rs.getString("assigned_to"));
                t.setSlaHours(rs.getInt("sla_hours"));
                t.setStatus(rs.getString("status"));
                t.setCreatedDate(rs.getString("created_date"));
                tickets.add(t);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }

        request.setAttribute("tickets", tickets);
        request.getRequestDispatcher("Tickets.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int bookingId;
        try {
            bookingId = Integer.parseInt(request.getParameter("bookingId"));
        } catch (NumberFormatException e) {
            response.sendRedirect("TicketServlet?msg=error");
            return;
        }

        String subject = request.getParameter("subject");
        String description = request.getParameter("description");
        String department = request.getParameter("department");
        String assignedTo = request.getParameter("assignedTo");
        String slaStr = request.getParameter("slaHours");

        if (subject == null || department == null ||
            subject.trim().isEmpty() || department.trim().isEmpty()) {
            response.sendRedirect("TicketServlet?msg=error");
            return;
        }

        int slaHours = 48;
        try {
            if (slaStr != null && !slaStr.isEmpty()) slaHours = Integer.parseInt(slaStr);
        } catch (Exception ignored) {}

        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(
                "INSERT INTO tickets (booking_id, subject, description, department, assigned_to, sla_hours, status) VALUES (?,?,?,?,?,?,'Open')");
            ps.setInt(1, bookingId);
            ps.setString(2, subject);
            ps.setString(3, description);
            ps.setString(4, department);
            ps.setString(5, assignedTo);
            ps.setInt(6, slaHours);

            int row = ps.executeUpdate();
            if (row > 0) {
                response.sendRedirect("TicketServlet?msg=success");
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