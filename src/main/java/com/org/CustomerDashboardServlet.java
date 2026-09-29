package com.org;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/CustomerDashboardServlet")
public class CustomerDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("allotteeId") == null
            || !"Customer".equalsIgnoreCase((String) session.getAttribute("role"))) {
            response.sendRedirect("Loginindex.jsp");
            return;
        }

        int allotteeId = (Integer) session.getAttribute("allotteeId");

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();

            String sql = "SELECT b.booking_id, b.booking_date, b.possession_date, b.total_amount, b.status AS booking_status, "
                       + "f.flat_id, f.unit_no, f.flat_type, f.tower, f.floor, f.agreement_value, f.rera_no, f.status AS flat_status, "
                       + "a.name, a.email, a.phone, a.kyc_status "
                       + "FROM bookings b "
                       + "JOIN flats f ON b.flat_id = f.flat_id "
                       + "JOIN allottees a ON b.allottee_id = a.allottee_id "
                       + "WHERE b.allottee_id = ? ORDER BY b.booking_id DESC LIMIT 1";

            ps = con.prepareStatement(sql);
            ps.setInt(1, allotteeId);
            rs = ps.executeQuery();

            int bookingId = 0;
            if (rs.next()) {
                bookingId = rs.getInt("booking_id");
                request.setAttribute("bookingId", bookingId);
                request.setAttribute("flatId", rs.getInt("flat_id"));
                request.setAttribute("unitNo", rs.getString("unit_no"));
                request.setAttribute("flatType", rs.getString("flat_type"));
                request.setAttribute("tower", rs.getString("tower"));
                request.setAttribute("floor", rs.getInt("floor"));
                request.setAttribute("agreementValue", rs.getDouble("agreement_value"));
                request.setAttribute("reraNo", rs.getString("rera_no"));
                request.setAttribute("flatStatus", rs.getString("flat_status"));
                request.setAttribute("bookingStatus", rs.getString("booking_status"));
                request.setAttribute("bookingDate", rs.getString("booking_date"));
                request.setAttribute("possessionDate", rs.getString("possession_date"));
                request.setAttribute("totalAmount", rs.getDouble("total_amount"));
                request.setAttribute("customerName", rs.getString("name"));
                request.setAttribute("customerEmail", rs.getString("email"));
                request.setAttribute("customerPhone", rs.getString("phone"));
                request.setAttribute("kycStatus", rs.getString("kyc_status"));
            }
            rs.close(); ps.close();

            if (bookingId > 0) {
                request.setAttribute("docCount",     getCount(con, "SELECT COUNT(*) FROM documents WHERE booking_id=?", bookingId));
                request.setAttribute("paymentCount", getCount(con, "SELECT COUNT(*) FROM payments  WHERE booking_id=? AND status='Paid'", bookingId));
                request.setAttribute("openTickets",  getCount(con, "SELECT COUNT(*) FROM tickets   WHERE booking_id=? AND status <> 'Closed'", bookingId));
                request.setAttribute("openSnags",    getCount(con, "SELECT COUNT(*) FROM snags     WHERE booking_id=? AND status <> 'Customer Verified'", bookingId));

                ps = con.prepareStatement("SELECT IFNULL(SUM(amount),0) FROM payments WHERE booking_id=? AND status='Paid'");
                ps.setInt(1, bookingId);
                rs = ps.executeQuery();
                double paid = 0;
                if (rs.next()) paid = rs.getDouble(1);
                request.setAttribute("paidAmount", paid);
                rs.close(); ps.close();
            } else {
                request.setAttribute("docCount", 0);
                request.setAttribute("paymentCount", 0);
                request.setAttribute("openTickets", 0);
                request.setAttribute("openSnags", 0);
                request.setAttribute("paidAmount", 0.0);
            }

            request.getRequestDispatcher("CustomerDashboard.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("Loginindex.jsp?msg=error");
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception ignored) {}
            try { if (ps != null) ps.close(); } catch (Exception ignored) {}
            try { if (con != null) con.close(); } catch (Exception ignored) {}
        }
    }

    private int getCount(Connection con, String sql, int bookingId) throws Exception {
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, bookingId);
        ResultSet rs = ps.executeQuery();
        int c = 0;
        if (rs.next()) c = rs.getInt(1);
        rs.close(); ps.close();
        return c;
    }
}