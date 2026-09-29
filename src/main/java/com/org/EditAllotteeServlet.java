package com.org;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/EditAllotteeServlet")
public class EditAllotteeServlet extends HttpServlet {
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
            ps = con.prepareStatement("SELECT * FROM allottees WHERE allottee_id=?");
            ps.setInt(1, id);
            rs = ps.executeQuery();

            if (rs.next()) {
                Allottee a = new Allottee();
                a.setAllotteeId(rs.getInt("allottee_id"));
                a.setName(rs.getString("name"));
                a.setEmail(rs.getString("email"));
                a.setPhone(rs.getString("phone"));
                a.setAddress(rs.getString("address"));
                a.setKycStatus(rs.getString("kyc_status"));
                request.setAttribute("allottee", a);
                request.getRequestDispatcher("EditAllottee.jsp").forward(request, response);
            } else {
                response.sendRedirect("AllotteeManagementServlet?msg=notfound");
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

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id;
        try {
            id = Integer.parseInt(request.getParameter("allotteeId"));
        } catch (NumberFormatException e) {
            response.sendRedirect("AllotteeManagementServlet?msg=error");
            return;
        }

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String kycStatus = request.getParameter("kyc_status");

        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(
                "UPDATE allottees SET name=?, email=?, phone=?, address=?, kyc_status=? WHERE allottee_id=?");
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, phone);
            ps.setString(4, address);
            ps.setString(5, kycStatus);
            ps.setInt(6, id);

            int rows = ps.executeUpdate();
            if (rows > 0) {
                response.sendRedirect("AllotteeManagementServlet?msg=updated");
            } else {
                response.sendRedirect("AllotteeManagementServlet?msg=error");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("AllotteeManagementServlet?msg=error");
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }
}