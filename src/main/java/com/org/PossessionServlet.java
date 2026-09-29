package com.org;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/PossessionServlet")
public class PossessionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("Possession.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String bookingIdStr = request.getParameter("bookingId");
        int bookingId;
        try {
            bookingId = Integer.parseInt(bookingIdStr);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "❌ Invalid Booking ID.");
            request.getRequestDispatcher("Possession.jsp").forward(request, response);
            return;
        }

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();

            String checkSql = "SELECT b.*, f.flat_id, f.status AS flat_status " +
                              "FROM bookings b " +
                              "JOIN flats f ON b.flat_id = f.flat_id " +
                              "WHERE b.booking_id = ?";
            ps = con.prepareStatement(checkSql);
            ps.setInt(1, bookingId);
            rs = ps.executeQuery();

            if (!rs.next()) {
                request.setAttribute("error", "❌ Booking ID " + bookingId + " does not exist.");
                request.getRequestDispatcher("Possession.jsp").forward(request, response);
                return;
            }

            String bookingStatus = rs.getString("status");
            int flatId = rs.getInt("flat_id");
            String flatStatus = rs.getString("flat_status");
            String possessionDate = rs.getString("possession_date");
            int allotteeId = rs.getInt("allottee_id");

            if (!"Confirmed".equalsIgnoreCase(bookingStatus)) {
                request.setAttribute("error", "❌ Booking status is '" + bookingStatus + "'. Only 'Confirmed' bookings can get possession.");
                request.getRequestDispatcher("Possession.jsp").forward(request, response);
                return;
            }
            if (!"Booked".equalsIgnoreCase(flatStatus)) {
                request.setAttribute("error", "❌ Flat status is '" + flatStatus + "'. Flat must be 'Booked' for possession.");
                request.getRequestDispatcher("Possession.jsp").forward(request, response);
                return;
            }

            con.setAutoCommit(false);

            ps = con.prepareStatement("UPDATE bookings SET status = 'Possession Given' WHERE booking_id = ?");
            ps.setInt(1, bookingId);
            int bookingUpdated = ps.executeUpdate();

            ps = con.prepareStatement("UPDATE flats SET status = 'Possession Given' WHERE flat_id = ?");
            ps.setInt(1, flatId);
            int flatUpdated = ps.executeUpdate();

            if (bookingUpdated > 0 && flatUpdated > 0) {
                con.commit();
                request.setAttribute("bookingId", bookingId);
                request.setAttribute("allotteeId", allotteeId);
                request.setAttribute("flatId", flatId);
                request.setAttribute("possessionDate", possessionDate);
                request.getRequestDispatcher("CheckInSuccess.jsp").forward(request, response);
            } else {
                con.rollback();
                request.setAttribute("error", "❌ Possession failed. Please try again.");
                request.getRequestDispatcher("Possession.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            try { if (con != null) con.rollback(); } catch (Exception ex) {}
            request.setAttribute("error", "❌ Database error: " + e.getMessage());
            request.getRequestDispatcher("Possession.jsp").forward(request, response);
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }
}