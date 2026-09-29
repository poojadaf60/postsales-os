package com.org;

import java.io.IOException;
import java.sql.*;
import java.time.LocalDate;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/BookingServlet")
public class BookingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Allottee> allottees = new ArrayList<>();
        List<Flat> flats = new ArrayList<>();

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();

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

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }

        request.setAttribute("allottees", allottees);
        request.setAttribute("flats", flats);
        request.getRequestDispatcher("AddBooking.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String allotteeIdStr = request.getParameter("allotteeId");
        String flatIdStr = request.getParameter("flatId");
        String bookingDate = request.getParameter("bookingDate");
        String possessionDate = request.getParameter("possessionDate");
        String totalAmountStr = request.getParameter("totalAmount");
        String status = request.getParameter("status");

        if (allotteeIdStr == null || flatIdStr == null || bookingDate == null ||
            possessionDate == null || totalAmountStr == null || status == null ||
            allotteeIdStr.trim().isEmpty() || flatIdStr.trim().isEmpty() ||
            bookingDate.trim().isEmpty() || possessionDate.trim().isEmpty() ||
            totalAmountStr.trim().isEmpty() || status.trim().isEmpty()) {
            forwardWithError(request, response, "❌ All fields are required.");
            return;
        }

        int allotteeId, flatId;
        double totalAmount;
        try {
            allotteeId = Integer.parseInt(allotteeIdStr);
            flatId = Integer.parseInt(flatIdStr);
            totalAmount = Double.parseDouble(totalAmountStr);
        } catch (NumberFormatException e) {
            forwardWithError(request, response, "❌ Invalid number format.");
            return;
        }

        try {
            if (!LocalDate.parse(possessionDate).isAfter(LocalDate.parse(bookingDate))) {
                forwardWithError(request, response, "❌ Possession date must be after booking date.");
                return;
            }
        } catch (Exception e) {
            forwardWithError(request, response, "❌ Invalid date format.");
            return;
        }

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);

            ps = con.prepareStatement("SELECT status FROM flats WHERE flat_id = ?");
            ps.setInt(1, flatId);
            rs = ps.executeQuery();
            if (!rs.next()) {
                con.rollback();
                forwardWithError(request, response, "❌ Flat ID does not exist.");
                return;
            }
            String flatStatus = rs.getString("status");
            rs.close();
            ps.close();

            if (!"Available".equalsIgnoreCase(flatStatus)) {
                con.rollback();
                forwardWithError(request, response, "❌ Flat is not available (status: " + flatStatus + ").");
                return;
            }

            String sql = "INSERT INTO bookings (allottee_id, flat_id, booking_date, possession_date, total_amount, status) VALUES (?,?,?,?,?,?)";
            ps = con.prepareStatement(sql);
            ps.setInt(1, allotteeId);
            ps.setInt(2, flatId);
            ps.setString(3, bookingDate);
            ps.setString(4, possessionDate);
            ps.setDouble(5, totalAmount);
            ps.setString(6, status);
            int result = ps.executeUpdate();
            ps.close();

            if (result == 0) {
                con.rollback();
                forwardWithError(request, response, "❌ Failed to create booking.");
                return;
            }

            if ("Confirmed".equalsIgnoreCase(status) || "Possession Given".equalsIgnoreCase(status)) {
                ps = con.prepareStatement("UPDATE flats SET status='Booked' WHERE flat_id=?");
                ps.setInt(1, flatId);
                ps.executeUpdate();
                ps.close();
            }

            con.commit();
            response.sendRedirect("BookingManagementServlet?msg=success");

        } catch (Exception e) {
            e.printStackTrace();
            try { if (con != null) con.rollback(); } catch (Exception ex) {}
            forwardWithError(request, response, "❌ Database error: " + e.getMessage());
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }

    private void forwardWithError(HttpServletRequest request, HttpServletResponse response,
                                  String message) throws ServletException, IOException {
        request.setAttribute("errorMessage", message);
        request.getRequestDispatcher("AddBooking.jsp").forward(request, response);
    }
}