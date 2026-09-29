package com.org;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/AddFlatServlet")
public class AddFlatServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String unitNo = request.getParameter("unit_no");
        String flatType = request.getParameter("flat_type");
        String tower = request.getParameter("tower");
        String floorStr = request.getParameter("floor");
        String agreementStr = request.getParameter("agreement_value");
        String status = request.getParameter("status");
        String possessionDate = request.getParameter("possession_date");
        String reraNo = request.getParameter("rera_no");

        if (unitNo == null || flatType == null || tower == null || floorStr == null ||
            agreementStr == null || status == null ||
            unitNo.trim().isEmpty() || flatType.trim().isEmpty() ||
            tower.trim().isEmpty() || floorStr.trim().isEmpty() ||
            agreementStr.trim().isEmpty() || status.trim().isEmpty()) {
            response.sendRedirect("FlatManagementServlet?msg=error");
            return;
        }

        int floor;
        double agreementValue;
        try {
            floor = Integer.parseInt(floorStr.trim());
            agreementValue = Double.parseDouble(agreementStr.trim());
        } catch (NumberFormatException e) {
            response.sendRedirect("FlatManagementServlet?msg=error");
            return;
        }

        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DBConnection.getConnection();
            String sql = "INSERT INTO flats(unit_no, flat_type, tower, floor, agreement_value, status, possession_date, rera_no) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            ps = con.prepareStatement(sql);
            ps.setString(1, unitNo.trim());
            ps.setString(2, flatType.trim());
            ps.setString(3, tower.trim());
            ps.setInt(4, floor);
            ps.setDouble(5, agreementValue);
            ps.setString(6, status.trim());
            ps.setString(7, possessionDate);
            ps.setString(8, reraNo);

            int result = ps.executeUpdate();

            if (result > 0) {
                response.sendRedirect("FlatManagementServlet?msg=success");
            } else {
                response.sendRedirect("FlatManagementServlet?msg=error");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("FlatManagementServlet?msg=error");
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }
}