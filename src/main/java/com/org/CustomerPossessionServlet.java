package com.org;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/CustomerPossessionServlet")
public class CustomerPossessionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("allotteeId") == null) {
            response.sendRedirect("Loginindex.jsp"); return;
        }
        int allotteeId = (Integer) session.getAttribute("allotteeId");

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();

            String sql = "SELECT b.booking_id, b.booking_date, b.possession_date, b.status AS booking_status, "
                       + "f.unit_no, f.status AS flat_status, f.rera_no, a.kyc_status "
                       + "FROM bookings b "
                       + "JOIN flats f ON b.flat_id = f.flat_id "
                       + "JOIN allottees a ON b.allottee_id = a.allottee_id "
                       + "WHERE b.allottee_id = ? ORDER BY b.booking_id DESC LIMIT 1";
            ps = con.prepareStatement(sql);
            ps.setInt(1, allotteeId);
            rs = ps.executeQuery();

            if (rs.next()) {
                int bookingId = rs.getInt("booking_id");
                request.setAttribute("bookingId", bookingId);
                request.setAttribute("unitNo", rs.getString("unit_no"));
                request.setAttribute("bookingStatus", rs.getString("booking_status"));
                request.setAttribute("flatStatus", rs.getString("flat_status"));
                request.setAttribute("possessionDate", rs.getString("possession_date"));
                request.setAttribute("kycStatus", rs.getString("kyc_status"));
                request.setAttribute("reraNo", rs.getString("rera_no"));
                rs.close(); ps.close();

                ps = con.prepareStatement(
                    "SELECT COUNT(*), SUM(CASE WHEN status='Customer Verified' THEN 1 ELSE 0 END) "
                    + "FROM snags WHERE booking_id=?");
                ps.setInt(1, bookingId);
                rs = ps.executeQuery();
                if (rs.next()) {
                    request.setAttribute("totalSnags", rs.getInt(1));
                    request.setAttribute("verifiedSnags", rs.getInt(2));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception ignored) {}
            try { if (ps != null) ps.close(); } catch (Exception ignored) {}
            try { if (con != null) con.close(); } catch (Exception ignored) {}
        }

        request.getRequestDispatcher("CustomerPossession.jsp").forward(request, response);
    }
}