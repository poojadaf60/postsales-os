package com.org;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/DeleteAllotteeServlet")
public class DeleteAllotteeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id;
        try {
            id = Integer.parseInt(request.getParameter("id"));
        } catch (NumberFormatException e) {
            response.sendRedirect("AllotteeManagementServlet?msg=error");
            return;
        }

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();

            ps = con.prepareStatement("SELECT COUNT(*) FROM bookings WHERE allottee_id = ?");
            ps.setInt(1, id);
            rs = ps.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                response.sendRedirect("AllotteeManagementServlet?msg=error&reason=allottee_has_bookings");
                return;
            }
            rs.close();
            ps.close();

            ps = con.prepareStatement("DELETE FROM allottees WHERE allottee_id = ?");
            ps.setInt(1, id);
            int row = ps.executeUpdate();

            if (row > 0) {
                response.sendRedirect("AllotteeManagementServlet?msg=deleted");
            } else {
                response.sendRedirect("AllotteeManagementServlet?msg=error");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("AllotteeManagementServlet?msg=error");
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }
}