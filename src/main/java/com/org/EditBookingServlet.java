package com.org;

import java.io.IOException;
import java.sql.*;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/EditBookingServlet")
public class EditBookingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            int bookingId = Integer.parseInt(request.getParameter("id"));
            con = DBConnection.getConnection();

            ps = con.prepareStatement("SELECT * FROM bookings WHERE booking_id=?");
            ps.setInt(1, bookingId);
            rs = ps.executeQuery();

            if (rs.next()) {
                Booking booking = new Booking();
                booking.setBookingId(rs.getInt("booking_id"));
                booking.setAllotteeId(rs.getInt("allottee_id"));
                booking.setFlatId(rs.getInt("flat_id"));
                booking.setBookingDate(rs.getString("booking_date"));
                booking.setPossessionDate(rs.getString("possession_date"));
                booking.setTotalAmount(rs.getDouble("total_amount"));
                booking.setStatus(rs.getString("status"));
                request.setAttribute("booking", booking);
            } else {
                response.sendRedirect("BookingManagementServlet");
                return;
            }
            rs.close();
            ps.close();

            List<Allottee> allottees = new ArrayList<>();
            ps = con.prepareStatement("SELECT allottee_id, name FROM allottees ORDER BY name");
            rs = ps.executeQuery();
            while (rs.next()) {
                Allottee a = new Allottee();
                a.setAllotteeId(rs.getInt("allottee_id"));
                a.setName(rs.getString("name"));
                allottees.add(a);
            }
            rs.close();
            ps.close();

            List<Flat> flats = new ArrayList<>();
            ps = con.prepareStatement("SELECT flat_id, unit_no, flat_type, tower, status FROM flats ORDER BY unit_no");
            rs = ps.executeQuery();
            while (rs.next()) {
                Flat f = new Flat();
                f.setFlatId(rs.getInt("flat_id"));
                f.setUnitNo(rs.getString("unit_no"));
                f.setFlatType(rs.getString("flat_type"));
                f.setTower(rs.getString("tower"));
                f.setStatus(rs.getString("status"));
                flats.add(f);
            }
            rs.close();
            ps.close();

            request.setAttribute("allottees", allottees);
            request.setAttribute("flats", flats);
            request.getRequestDispatcher("EditBooking.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("BookingManagementServlet");
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }
}