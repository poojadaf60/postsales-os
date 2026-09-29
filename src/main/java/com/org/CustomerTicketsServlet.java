package com.org;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/CustomerTicketsServlet")
public class CustomerTicketsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("allotteeId") == null) {
            response.sendRedirect("Loginindex.jsp"); return;
        }
        int allotteeId = (Integer) session.getAttribute("allotteeId");

        ArrayList<Ticket> tickets = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            String sql = "SELECT t.* FROM tickets t "
                       + "JOIN bookings b ON t.booking_id = b.booking_id "
                       + "WHERE b.allottee_id = ? ORDER BY t.ticket_id DESC";
            ps = con.prepareStatement(sql);
            ps.setInt(1, allotteeId);
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
            try { if (rs != null) rs.close(); } catch (Exception ignored) {}
            try { if (ps != null) ps.close(); } catch (Exception ignored) {}
            try { if (con != null) con.close(); } catch (Exception ignored) {}
        }

        request.setAttribute("tickets", tickets);
        request.getRequestDispatcher("CustomerTickets.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("allotteeId") == null) {
            response.sendRedirect("Loginindex.jsp"); return;
        }
        int allotteeId = (Integer) session.getAttribute("allotteeId");

        String subject = request.getParameter("subject");
        String description = request.getParameter("description");
        String department = request.getParameter("department");

        if (subject == null || subject.trim().isEmpty() || department == null || department.trim().isEmpty()) {
            response.sendRedirect("CustomerTicketsServlet?msg=error");
            return;
        }

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();

            ps = con.prepareStatement("SELECT booking_id FROM bookings WHERE allottee_id=? ORDER BY booking_id DESC LIMIT 1");
            ps.setInt(1, allotteeId);
            rs = ps.executeQuery();
            if (!rs.next()) {
                response.sendRedirect("CustomerTicketsServlet?msg=nobooking");
                return;
            }
            int bookingId = rs.getInt("booking_id");
            rs.close(); ps.close();

            ps = con.prepareStatement(
                "INSERT INTO tickets (booking_id, subject, description, department, sla_hours, status) VALUES (?,?,?,?,48,'Open')");
            ps.setInt(1, bookingId);
            ps.setString(2, subject);
            ps.setString(3, description);
            ps.setString(4, department);
            int row = ps.executeUpdate();

            response.sendRedirect("CustomerTicketsServlet?msg=" + (row > 0 ? "success" : "error"));

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("CustomerTicketsServlet?msg=error");
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception ignored) {}
            try { if (ps != null) ps.close(); } catch (Exception ignored) {}
            try { if (con != null) con.close(); } catch (Exception ignored) {}
        }
    }
}