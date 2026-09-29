package com.org;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/DeleteFlatServlet")
public class DeleteFlatServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();

            ps = con.prepareStatement("SELECT COUNT(*) FROM bookings WHERE flat_id = ?");
            ps.setInt(1, id);
            rs = ps.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                response.sendRedirect("FlatManagementServlet?msg=error&reason=flat_has_bookings");
                return;
            }
            rs.close();
            ps.close();

            ps = con.prepareStatement("DELETE FROM flats WHERE flat_id = ?");
            ps.setInt(1, id);
            int rows = ps.executeUpdate();

            if (rows > 0) {
                response.sendRedirect("FlatManagementServlet?msg=deleted");
            } else {
                response.sendRedirect("FlatManagementServlet?msg=error");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("FlatManagementServlet?msg=error");
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }
}