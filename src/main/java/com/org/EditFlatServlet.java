package com.org;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/EditFlatServlet")
public class EditFlatServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id;
        try {
            id = Integer.parseInt(request.getParameter("id"));
        } catch (NumberFormatException e) {
            response.sendRedirect("FlatManagementServlet?msg=error");
            return;
        }

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement("SELECT * FROM flats WHERE flat_id = ?");
            ps.setInt(1, id);
            rs = ps.executeQuery();

            if (rs.next()) {
                request.setAttribute("flatId", rs.getInt("flat_id"));
                request.setAttribute("unitNo", rs.getString("unit_no"));
                request.setAttribute("flatType", rs.getString("flat_type"));
                request.setAttribute("tower", rs.getString("tower"));
                request.setAttribute("floor", rs.getInt("floor"));
                request.setAttribute("agreementValue", rs.getDouble("agreement_value"));
                request.setAttribute("status", rs.getString("status"));
                request.setAttribute("possessionDate", rs.getString("possession_date"));
                request.setAttribute("reraNo", rs.getString("rera_no"));
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("FlatManagementServlet?msg=error");
            return;
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }

        request.getRequestDispatcher("EditFlat.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id, floor;
        double agreementValue;
        try {
            id = Integer.parseInt(request.getParameter("flatId"));
            floor = Integer.parseInt(request.getParameter("floor"));
            agreementValue = Double.parseDouble(request.getParameter("agreement_value"));
        } catch (NumberFormatException e) {
            response.sendRedirect("FlatManagementServlet?msg=error");
            return;
        }

        String unitNo = request.getParameter("unit_no");
        String flatType = request.getParameter("flat_type");
        String tower = request.getParameter("tower");
        String status = request.getParameter("status");
        String possessionDate = request.getParameter("possession_date");
        String reraNo = request.getParameter("rera_no");

        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(
                "UPDATE flats SET unit_no=?, flat_type=?, tower=?, floor=?, agreement_value=?, status=?, possession_date=?, rera_no=? WHERE flat_id=?");
            ps.setString(1, unitNo);
            ps.setString(2, flatType);
            ps.setString(3, tower);
            ps.setInt(4, floor);
            ps.setDouble(5, agreementValue);
            ps.setString(6, status);
            ps.setString(7, possessionDate);
            ps.setString(8, reraNo);
            ps.setInt(9, id);

            int i = ps.executeUpdate();

            if (i > 0) {
                response.sendRedirect("FlatManagementServlet?msg=updated");
            } else {
                response.sendRedirect("FlatManagementServlet?msg=error");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("FlatManagementServlet?msg=error");
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }
}