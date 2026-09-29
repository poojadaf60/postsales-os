package com.org;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/DashboardServlet")
public class DashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect("Loginindex.jsp");
            return;
        }

        Connection con = null;
        try {
            con = DBConnection.getConnection();

            request.setAttribute("totalFlats", getCount(con, "SELECT COUNT(*) FROM flats"));
            request.setAttribute("availableFlats", getCount(con, "SELECT COUNT(*) FROM flats WHERE status='Available'"));
            request.setAttribute("bookedFlats", getCount(con, "SELECT COUNT(*) FROM flats WHERE status='Booked'"));
            request.setAttribute("possessionFlats", getCount(con, "SELECT COUNT(*) FROM flats WHERE status='Possession Given'"));
            request.setAttribute("totalAllottees", getCount(con, "SELECT COUNT(*) FROM allottees"));
            request.setAttribute("totalBookings", getCount(con, "SELECT COUNT(*) FROM bookings"));
            request.setAttribute("totalDocuments", getCount(con, "SELECT COUNT(*) FROM documents"));
            request.setAttribute("openTickets", getCount(con, "SELECT COUNT(*) FROM tickets WHERE status='Open'"));
            request.setAttribute("openSnags", getCount(con, "SELECT COUNT(*) FROM snags WHERE status='Open'"));

            PreparedStatement ps = con.prepareStatement("SELECT IFNULL(SUM(amount),0) FROM payments WHERE status='Paid'");
            ResultSet rs = ps.executeQuery();
            double revenue = 0;
            if (rs.next()) revenue = rs.getDouble(1);
            request.setAttribute("totalRevenue", revenue);
            rs.close();
            ps.close();

            request.getRequestDispatcher("AdminDashboard.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error : " + e.getMessage());
        } finally {
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }

    private int getCount(Connection con, String sql) throws Exception {
        PreparedStatement ps = con.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();
        int count = 0;
        if (rs.next()) count = rs.getInt(1);
        rs.close();
        ps.close();
        return count;
    }
}