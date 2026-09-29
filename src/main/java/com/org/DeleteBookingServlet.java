package com.org;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/DeleteBookingServlet")
public class DeleteBookingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            int bookingId = Integer.parseInt(request.getParameter("id"));
            con = DBConnection.getConnection();
            con.setAutoCommit(false);

            ps = con.prepareStatement("SELECT flat_id FROM bookings WHERE booking_id = ?");
            ps.setInt(1, bookingId);
            rs = ps.executeQuery();
            if (!rs.next()) {
                con.rollback();
                response.sendRedirect("BookingManagementServlet?msg=notfound");
                return;
            }
            int flatId = rs.getInt("flat_id");
            rs.close();
            ps.close();

            ps = con.prepareStatement("DELETE FROM bookings WHERE booking_id = ?");
            ps.setInt(1, bookingId);
            int rows = ps.executeUpdate();
            ps.close();

            if (rows == 0) {
                con.rollback();
                response.sendRedirect("BookingManagementServlet?msg=error");
                return;
            }

            ps = con.prepareStatement("UPDATE flats SET status = 'Available' WHERE flat_id = ? AND status = 'Booked'");
            ps.setInt(1, flatId);
            ps.executeUpdate();
            ps.close();

            con.commit();
            response.sendRedirect("BookingManagementServlet?msg=deleted");

        } catch (Exception e) {
            e.printStackTrace();
            try { if (con != null) con.rollback(); } catch (Exception ex) {}
            response.sendRedirect("BookingManagementServlet?msg=error");
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }
}