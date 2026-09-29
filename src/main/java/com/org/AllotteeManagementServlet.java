package com.org;

import java.io.IOException;
import java.sql.*;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/AllotteeManagementServlet")
public class AllotteeManagementServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        ArrayList<Allottee> allottees = new ArrayList<>();
        int total = 0;

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement("SELECT * FROM allottees ORDER BY allottee_id DESC");
            rs = ps.executeQuery();

            while (rs.next()) {
                Allottee a = new Allottee();
                a.setAllotteeId(rs.getInt("allottee_id"));
                a.setName(rs.getString("name"));
                a.setEmail(rs.getString("email"));
                a.setPhone(rs.getString("phone"));
                a.setAddress(rs.getString("address"));
                a.setKycStatus(rs.getString("kyc_status"));
                allottees.add(a);
                total++;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMsg", "Database error: " + e.getMessage());
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }

        request.setAttribute("allottees", allottees);
        request.setAttribute("totalAllottees", total);
        request.getRequestDispatcher("AllotteeManagement.jsp").forward(request, response);
    }
}