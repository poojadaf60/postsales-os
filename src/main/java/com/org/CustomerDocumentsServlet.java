package com.org;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/CustomerDocumentsServlet")
public class CustomerDocumentsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("allotteeId") == null) {
            response.sendRedirect("Loginindex.jsp"); return;
        }
        int allotteeId = (Integer) session.getAttribute("allotteeId");

        ArrayList<Document> documents = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            String sql = "SELECT d.* FROM documents d "
                       + "JOIN bookings b ON d.booking_id = b.booking_id "
                       + "WHERE b.allottee_id = ? ORDER BY d.document_id DESC";
            ps = con.prepareStatement(sql);
            ps.setInt(1, allotteeId);
            rs = ps.executeQuery();
            while (rs.next()) {
                Document d = new Document();
                d.setDocumentId(rs.getInt("document_id"));
                d.setBookingId(rs.getInt("booking_id"));
                d.setDocType(rs.getString("doc_type"));
                d.setDocName(rs.getString("doc_name"));
                d.setFilePath(rs.getString("file_path"));
                d.setVersion(rs.getInt("version"));
                d.setUploadedBy(rs.getString("uploaded_by"));
                d.setUploadDate(rs.getString("upload_date"));
                d.setStatus(rs.getString("status"));
                documents.add(d);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception ignored) {}
            try { if (ps != null) ps.close(); } catch (Exception ignored) {}
            try { if (con != null) con.close(); } catch (Exception ignored) {}
        }

        request.setAttribute("documents", documents);
        request.getRequestDispatcher("CustomerDocuments.jsp").forward(request, response);
    }
}