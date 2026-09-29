package com.org;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/UpdatePaymentServlet")
public class UpdatePaymentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int paymentId = Integer.parseInt(request.getParameter("paymentId"));
        int bookingId = Integer.parseInt(request.getParameter("bookingId"));
        double amount = Double.parseDouble(request.getParameter("amount"));
        double tds = 0, gst = 0;
        try {
            String tdsStr = request.getParameter("tds");
            String gstStr = request.getParameter("gst");
            if (tdsStr != null && !tdsStr.isEmpty()) tds = Double.parseDouble(tdsStr);
            if (gstStr != null && !gstStr.isEmpty()) gst = Double.parseDouble(gstStr);
        } catch (Exception ignored) {}
        String paymentMethod = request.getParameter("paymentMethod");
        String paymentDate = request.getParameter("paymentDate");
        String status = request.getParameter("status");

        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DBConnection.getConnection();
            String sql = "UPDATE payments SET booking_id = ?, amount = ?, payment_method = ?, payment_date = ?, tds = ?, gst = ?, status = ? WHERE payment_id = ?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, bookingId);
            ps.setDouble(2, amount);
            ps.setString(3, paymentMethod);
            ps.setString(4, paymentDate);
            ps.setDouble(5, tds);
            ps.setDouble(6, gst);
            ps.setString(7, status);
            ps.setInt(8, paymentId);

            int row = ps.executeUpdate();
            if (row > 0) {
                response.sendRedirect("PaymentManagementServlet?msg=updated");
            } else {
                response.sendRedirect("EditPaymentServlet?id=" + paymentId + "&msg=error");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("EditPaymentServlet?id=" + paymentId + "&msg=error");
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }
}