package com.org;

import java.io.IOException;
import java.sql.*;
import java.sql.Date;
import java.text.SimpleDateFormat;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/ReportServlet")
public class ReportServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect("Loginindex.jsp");
            return;
        }

        String fromDate = request.getParameter("fromDate");
        String toDate = request.getParameter("toDate");

        if (fromDate == null || fromDate.isEmpty()) {
            Calendar cal = Calendar.getInstance();
            cal.add(Calendar.DAY_OF_MONTH, -30);
            fromDate = new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());
        }
        if (toDate == null || toDate.isEmpty()) {
            toDate = new SimpleDateFormat("yyyy-MM-dd").format(new Date(0));
        }

        List<Booking> bookings = new ArrayList<>();
        double totalRevenue = 0;
        int totalBookings = 0, totalAllottees = 0, totalFlats = 0;
        int availableFlats = 0, bookedFlats = 0, possessionFlats = 0;

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();

            ps = con.prepareStatement("SELECT * FROM bookings WHERE booking_date BETWEEN ? AND ? ORDER BY booking_id DESC");
            ps.setString(1, fromDate);
            ps.setString(2, toDate);
            rs = ps.executeQuery();
            while (rs.next()) {
                Booking b = new Booking();
                b.setBookingId(rs.getInt("booking_id"));
                b.setAllotteeId(rs.getInt("allottee_id"));
                b.setFlatId(rs.getInt("flat_id"));
                b.setBookingDate(rs.getString("booking_date"));
                b.setPossessionDate(rs.getString("possession_date"));
                b.setTotalAmount(rs.getDouble("total_amount"));
                b.setStatus(rs.getString("status"));
                bookings.add(b);
            }
            rs.close();
            ps.close();
            totalBookings = bookings.size();

            ps = con.prepareStatement("SELECT IFNULL(SUM(amount),0) FROM payments WHERE status='Paid'");
            rs = ps.executeQuery();
            if (rs.next()) totalRevenue = rs.getDouble(1);
            rs.close();
            ps.close();

            ps = con.prepareStatement("SELECT COUNT(*) FROM allottees");
            rs = ps.executeQuery();
            if (rs.next()) totalAllottees = rs.getInt(1);
            rs.close();
            ps.close();

            ps = con.prepareStatement("SELECT COUNT(*), " +
                "SUM(CASE WHEN status='Available' THEN 1 ELSE 0 END), " +
                "SUM(CASE WHEN status='Booked' THEN 1 ELSE 0 END), " +
                "SUM(CASE WHEN status='Possession Given' THEN 1 ELSE 0 END) FROM flats");
            rs = ps.executeQuery();
            if (rs.next()) {
                totalFlats = rs.getInt(1);
                availableFlats = rs.getInt(2);
                bookedFlats = rs.getInt(3);
                possessionFlats = rs.getInt(4);
            }
            rs.close();
            ps.close();

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }

        request.setAttribute("bookings", bookings);
        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("totalBookings", totalBookings);
        request.setAttribute("totalAllottees", totalAllottees);
        request.setAttribute("totalFlats", totalFlats);
        request.setAttribute("availableFlats", availableFlats);
        request.setAttribute("bookedFlats", bookedFlats);
        request.setAttribute("possessionFlats", possessionFlats);
        request.setAttribute("fromDate", fromDate);
        request.setAttribute("toDate", toDate);

        request.getRequestDispatcher("Report.jsp").forward(request, response);
    }
}