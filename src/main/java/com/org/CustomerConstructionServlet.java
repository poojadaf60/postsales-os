package com.org;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/CustomerConstructionServlet")
public class CustomerConstructionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("allotteeId") == null) {
            response.sendRedirect("Loginindex.jsp"); return;
        }
        int allotteeId = (Integer) session.getAttribute("allotteeId");

        ArrayList<Construction> updates = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            String sql = "SELECT c.* FROM construction_updates c "
                       + "JOIN bookings b ON c.flat_id = b.flat_id "
                       + "WHERE b.allottee_id = ? ORDER BY c.update_id DESC";
            ps = con.prepareStatement(sql);
            ps.setInt(1, allotteeId);
            rs = ps.executeQuery();
            while (rs.next()) {
                Construction c = new Construction();
                c.setUpdateId(rs.getInt("update_id"));
                c.setFlatId(rs.getInt("flat_id"));
                c.setMilestone(rs.getString("milestone"));
                c.setDescription(rs.getString("description"));
                c.setPhotoPath(rs.getString("photo_path"));
                c.setUpdateDate(rs.getString("update_date"));
                updates.add(c);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception ignored) {}
            try { if (ps != null) ps.close(); } catch (Exception ignored) {}
            try { if (con != null) con.close(); } catch (Exception ignored) {}
        }

        request.setAttribute("updates", updates);
        request.getRequestDispatcher("CustomerConstruction.jsp").forward(request, response);
    }
}