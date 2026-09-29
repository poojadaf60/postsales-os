package com.org;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/DocumentServlet")
public class DocumentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        ArrayList<Document> documents = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement("SELECT * FROM documents ORDER BY document_id DESC");
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
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }

        request.setAttribute("documents", documents);
        request.getRequestDispatcher("Documents.jsp").forward(request, response);
    }
}