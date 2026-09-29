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

@WebServlet("/ConstructionServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,
    maxFileSize = 1024 * 1024 * 10,
    maxRequestSize = 1024 * 1024 * 20
)
public class ConstructionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final List<String> ALLOWED_EXTENSIONS =
            Arrays.asList(".jpg", ".jpeg", ".png", ".mp4", ".mov");

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        ArrayList<Construction> updates = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement("SELECT * FROM construction_updates ORDER BY update_id DESC");
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
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }

        request.setAttribute("updates", updates);
        request.getRequestDispatcher("Construction.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int flatId;
        try {
            flatId = Integer.parseInt(request.getParameter("flatId"));
        } catch (NumberFormatException e) {
            response.sendRedirect("ConstructionServlet?msg=error");
            return;
        }

        String milestone = request.getParameter("milestone");
        String description = request.getParameter("description");

        if (milestone == null || milestone.trim().isEmpty()) {
            response.sendRedirect("ConstructionServlet?msg=error");
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
                String uploadPath = getServletContext().getRealPath("") + File.separator + "construction_uploads";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdirs();

                String uniqueFileName = System.currentTimeMillis() + "_" + fileName;
                filePart.write(uploadPath + File.separator + uniqueFileName);
                photoPath = "construction_uploads/" + uniqueFileName;
            }
        }

        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(
                "INSERT INTO construction_updates (flat_id, milestone, description, photo_path) VALUES (?,?,?,?)");
            ps.setInt(1, flatId);
            ps.setString(2, milestone);
            ps.setString(3, description);
            ps.setString(4, photoPath);

            int row = ps.executeUpdate();
            if (row > 0) {
                response.sendRedirect("ConstructionServlet?msg=success");
            } else {
                response.sendRedirect("ConstructionServlet?msg=error");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("ConstructionServlet?msg=error");
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
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