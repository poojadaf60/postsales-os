package com.org;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/PaymentServlet")
public class PaymentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int bookingId;
        double amount, tds = 0, gst = 0;
        try {
            bookingId = Integer.parseInt(request.getParameter("bookingId"));
            amount = Double.parseDouble(request.getParameter("amount"));
            String tdsStr = request.getParameter("tds");
            String gstStr = request.getParameter("gst");
            if (tdsStr != null && !tdsStr.isEmpty()) tds = Double.parseDouble(tdsStr);
            if (gstStr != null && !gstStr.isEmpty()) gst = Double.parseDouble(gstStr);
        } catch (NumberFormatException e) {
            response.sendRedirect("AddPayment.jsp?msg=error");
            return;
        }

        String paymentMethod = request.getParameter("paymentMethod");
        String paymentDate = request.getParameter("paymentDate");
        String status = request.getParameter("status");

        if (paymentMethod == null || paymentDate == null || status == null ||
            paymentMethod.trim().isEmpty() || paymentDate.trim().isEmpty() ||
            status.trim().isEmpty() || amount <= 0) {
            response.sendRedirect("AddPayment.jsp?msg=error");
            return;
        }

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();

            ps = con.prepareStatement("SELECT booking_id FROM bookings WHERE booking_id = ?");
            ps.setInt(1, bookingId);
            rs = ps.executeQuery();
            if (!rs.next()) {
                response.sendRedirect("AddPayment.jsp?msg=error");
                return;
            }
            rs.close();
            ps.close();

            String sql = "INSERT INTO payments (booking_id, amount, payment_method, payment_date, tds, gst, status) VALUES (?, ?, ?, ?, ?, ?, ?)";
            ps = con.prepareStatement(sql);
            ps.setInt(1, bookingId);
            ps.setDouble(2, amount);
            ps.setString(3, paymentMethod.trim());
            ps.setString(4, paymentDate.trim());
            ps.setDouble(5, tds);
            ps.setDouble(6, gst);
            ps.setString(7, status.trim());

            int row = ps.executeUpdate();
            if (row > 0) {
                response.sendRedirect("PaymentManagementServlet?msg=success");
            } else {
                response.sendRedirect("AddPayment.jsp?msg=error");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("AddPayment.jsp?msg=error");
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception ignored) {}
            try { if (ps != null) ps.close(); } catch (Exception ignored) {}
            try { if (con != null) con.close(); } catch (Exception ignored) {}
        }
    }
}