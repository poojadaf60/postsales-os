package com.org;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.sql.*;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/CustomerSnagsServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,
    maxFileSize = 1024 * 1024 * 10,
    maxRequestSize = 1024 * 1024 * 20
)
public class CustomerSnagsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final List<String> ALLOWED_EXTENSIONS =
            Arrays.asList(".jpg", ".jpeg", ".png", ".mp4", ".mov");

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("allotteeId") == null) {
            response.sendRedirect("Loginindex.jsp"); return;
        }
        int allotteeId = (Integer) session.getAttribute("allotteeId");

        ArrayList<Snag> snags = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            String sql = "SELECT s.* FROM snags s "
                       + "JOIN bookings b ON s.booking_id = b.booking_id "
                       + "WHERE b.allottee_id = ? ORDER BY s.snag_id DESC";
            ps = con.prepareStatement(sql);
            ps.setInt(1, allotteeId);
            rs = ps.executeQuery();
            while (rs.next()) {
                Snag s = new Snag();
                s.setSnagId(rs.getInt("snag_id"));
                s.setBookingId(rs.getInt("booking_id"));
                s.setLocation(rs.getString("location"));
                s.setDescription(rs.getString("description"));
                s.setPriority(rs.getString("priority"));
                s.setAssignedTo(rs.getString("assigned_to"));
                s.setStatus(rs.getString("status"));
                s.setPhotoPath(rs.getString("photo_path"));
                s.setCreatedDate(rs.getString("created_date"));
                snags.add(s);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception ignored) {}
            try { if (ps != null) ps.close(); } catch (Exception ignored) {}
            try { if (con != null) con.close(); } catch (Exception ignored) {}
        }

        request.setAttribute("snags", snags);
        request.getRequestDispatcher("CustomerSnags.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("allotteeId") == null) {
            response.sendRedirect("Loginindex.jsp"); return;
        }
        int allotteeId = (Integer) session.getAttribute("allotteeId");

        String location = request.getParameter("location");
        String description = request.getParameter("description");
        String priority = request.getParameter("priority");

        if (location == null || location.trim().isEmpty()) {
            response.sendRedirect("CustomerSnagsServlet?msg=error");
            return;
        }

        String photoPath = null;
        Part filePart = request.getPart("photo");
        if (filePart != null && filePart.getSize() > 0) {
            String fileName = Paths.get(extractFileName(filePart)).getFileName().toString();
            String ext = "";
            int dot = fileName.lastIndexOf(".");
            if (dot >= 0) ext = fileName.substring(dot).toLowerCase();

            if (ALLOWED_EXTENSIONS.contains(ext)) {
                String uploadPath = getServletContext().getRealPath("") + File.separator + "snag_uploads";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdirs();

                String uniqueFileName = System.currentTimeMillis() + "_" + fileName;
                filePart.write(uploadPath + File.separator + uniqueFileName);
                photoPath = "snag_uploads/" + uniqueFileName;
            }
        }

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();

            ps = con.prepareStatement("SELECT booking_id FROM bookings WHERE allottee_id=? ORDER BY booking_id DESC LIMIT 1");
            ps.setInt(1, allotteeId);
            rs = ps.executeQuery();
            if (!rs.next()) {
                response.sendRedirect("CustomerSnagsServlet?msg=nobooking");
                return;
            }
            int bookingId = rs.getInt("booking_id");
            rs.close(); ps.close();

            ps = con.prepareStatement(
                "INSERT INTO snags (booking_id, location, description, priority, status, photo_path) VALUES (?,?,?,?,'Open',?)");
            ps.setInt(1, bookingId);
            ps.setString(2, location);
            ps.setString(3, description);
            ps.setString(4, priority != null ? priority : "Medium");
            ps.setString(5, photoPath);
            int row = ps.executeUpdate();

            response.sendRedirect("CustomerSnagsServlet?msg=" + (row > 0 ? "success" : "error"));

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("CustomerSnagsServlet?msg=error");
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception ignored) {}
            try { if (ps != null) ps.close(); } catch (Exception ignored) {}
            try { if (con != null) con.close(); } catch (Exception ignored) {}
        }
    }

    private String extractFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] items = contentDisp.split(";");
        for (String s : items) {
            if (s.trim().startsWith("filename")) {
                return s.substring(s.indexOf("=") + 2, s.length() - 1);
            }
        }
        return "";
    }
}