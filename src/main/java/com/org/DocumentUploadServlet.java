package com.org;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.sql.*;
import java.util.Arrays;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/DocumentUploadServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,
    maxFileSize = 1024 * 1024 * 10,
    maxRequestSize = 1024 * 1024 * 20
)
public class DocumentUploadServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final List<String> ALLOWED_EXTENSIONS =
            Arrays.asList(".pdf", ".doc", ".docx", ".jpg", ".jpeg", ".png");

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect("Loginindex.jsp");
            return;
        }

        int bookingId;
        try {
            bookingId = Integer.parseInt(request.getParameter("bookingId"));
        } catch (NumberFormatException e) {
            response.sendRedirect("DocumentServlet?msg=error");
            return;
        }

        String docType = request.getParameter("docType");
        String docName = request.getParameter("docName");
        String status = request.getParameter("status");

        if (docType == null || docName == null || status == null ||
            docType.trim().isEmpty() || docName.trim().isEmpty() || status.trim().isEmpty()) {
            response.sendRedirect("DocumentServlet?msg=error");
            return;
        }

        Part filePart = request.getPart("file");
        if (filePart == null || filePart.getSize() == 0) {
            response.sendRedirect("DocumentServlet?msg=error");
            return;
        }

        String fileName = Paths.get(extractFileName(filePart)).getFileName().toString();
        String ext = "";
        int dot = fileName.lastIndexOf(".");
        if (dot >= 0) ext = fileName.substring(dot).toLowerCase();

        if (!ALLOWED_EXTENSIONS.contains(ext)) {
            response.sendRedirect("DocumentServlet?msg=error");
            return;
        }

        String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdirs();

        String uniqueFileName = System.currentTimeMillis() + "_" + fileName;
        String filePath = uploadPath + File.separator + uniqueFileName;
        filePart.write(filePath);

        String relativePath = "uploads/" + uniqueFileName;
        String uploadedBy = (String) session.getAttribute("username");

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();

            // Get current max version for this booking + doc type
            int version = 1;
            ps = con.prepareStatement(
                "SELECT MAX(version) FROM documents WHERE booking_id=? AND doc_type=?");
            ps.setInt(1, bookingId);
            ps.setString(2, docType);
            rs = ps.executeQuery();
            if (rs.next()) version = rs.getInt(1) + 1;
            rs.close();
            ps.close();

            ps = con.prepareStatement(
                "INSERT INTO documents (booking_id, doc_type, doc_name, file_path, version, uploaded_by, status) VALUES (?,?,?,?,?,?,?)");
            ps.setInt(1, bookingId);
            ps.setString(2, docType);
            ps.setString(3, docName);
            ps.setString(4, relativePath);
            ps.setInt(5, version);
            ps.setString(6, uploadedBy);
            ps.setString(7, status);

            int row = ps.executeUpdate();
            if (row > 0) {
                response.sendRedirect("DocumentServlet?msg=success");
            } else {
                response.sendRedirect("DocumentServlet?msg=error");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("DocumentServlet?msg=error");
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
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