package com.org;

import java.io.IOException;
import java.sql.*;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/FlatManagementServlet")
public class FlatManagementServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Flat> flats = new ArrayList<>();
        int available = 0, booked = 0, possession = 0;

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement("SELECT * FROM flats ORDER BY flat_id DESC");
            rs = ps.executeQuery();

            while (rs.next()) {
                Flat f = new Flat();
                f.setFlatId(rs.getInt("flat_id"));
                f.setUnitNo(rs.getString("unit_no"));
                f.setFlatType(rs.getString("flat_type"));
                f.setTower(rs.getString("tower"));
                f.setFloor(rs.getInt("floor"));
                f.setAgreementValue(rs.getDouble("agreement_value"));
                f.setStatus(rs.getString("status"));
                f.setPossessionDate(rs.getString("possession_date"));
                f.setReraNo(rs.getString("rera_no"));
                flats.add(f);

                String st = f.getStatus();
                if ("Available".equalsIgnoreCase(st)) available++;
                else if ("Booked".equalsIgnoreCase(st)) booked++;
                else if ("Possession Given".equalsIgnoreCase(st)) possession++;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }

        request.setAttribute("flats", flats);
        request.setAttribute("availableFlats", available);
        request.setAttribute("bookedFlats", booked);
        request.setAttribute("possessionFlats", possession);

        request.getRequestDispatcher("FlatManagement.jsp").forward(request, response);
    }
}