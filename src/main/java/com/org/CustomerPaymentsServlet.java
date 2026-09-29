package com.org;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/CustomerPaymentsServlet")
public class CustomerPaymentsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("allotteeId") == null) {
            response.sendRedirect("Loginindex.jsp"); return;
        }
        int allotteeId = (Integer) session.getAttribute("allotteeId");

        ArrayList<Payment> payments = new ArrayList<>();
        double totalPaid = 0, totalTds = 0, totalGst = 0, totalAmount = 0;

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();

            ps = con.prepareStatement(
                "SELECT booking_id, total_amount FROM bookings WHERE allottee_id=? ORDER BY booking_id DESC LIMIT 1");
            ps.setInt(1, allotteeId);
            rs = ps.executeQuery();
            int bookingId = 0;
            if (rs.next()) {
                bookingId = rs.getInt("booking_id");
                totalAmount = rs.getDouble("total_amount");
            }
            rs.close(); ps.close();

            if (bookingId > 0) {
                ps = con.prepareStatement("SELECT * FROM payments WHERE booking_id=? ORDER BY payment_id DESC");
                ps.setInt(1, bookingId);
                rs = ps.executeQuery();
                while (rs.next()) {
                    Payment p = new Payment();
                    p.setPaymentId(rs.getInt("payment_id"));
                    p.setBookingId(rs.getInt("booking_id"));
                    p.setAmount(rs.getDouble("amount"));
                    p.setPaymentMethod(rs.getString("payment_method"));
                    p.setPaymentDate(rs.getString("payment_date"));
                    p.setTds(rs.getDouble("tds"));
                    p.setGst(rs.getDouble("gst"));
                    p.setStatus(rs.getString("status"));
                    payments.add(p);
                    if ("Paid".equalsIgnoreCase(p.getStatus())) {
                        totalPaid += p.getAmount();
                        totalTds  += p.getTds();
                        totalGst  += p.getGst();
                    }
                }
            }

            request.setAttribute("payments", payments);
            request.setAttribute("totalPaid", totalPaid);
            request.setAttribute("totalTds", totalTds);
            request.setAttribute("totalGst", totalGst);
            request.setAttribute("totalAmount", totalAmount);
            request.setAttribute("outstanding", totalAmount - totalPaid);

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception ignored) {}
            try { if (ps != null) ps.close(); } catch (Exception ignored) {}
            try { if (con != null) con.close(); } catch (Exception ignored) {}
        }

        request.getRequestDispatcher("CustomerPayments.jsp").forward(request, response);
    }
}