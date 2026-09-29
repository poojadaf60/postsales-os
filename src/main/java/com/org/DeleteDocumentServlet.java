package com.org;

import java.io.File;
import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/DeleteDocumentServlet")
public class DeleteDocumentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int docId;
        try {
            docId = Integer.parseInt(request.getParameter("id"));
        } catch (NumberFormatException e) {
            response.sendRedirect("DocumentServlet?msg=error");
            return;
        }

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();

            // Step 1: Get file_path before deleting
            ps = con.prepareStatement("SELECT file_path FROM documents WHERE document_id = ?");
            ps.setInt(1, docId);
            rs = ps.executeQuery();

            String filePath = null;
            if (rs.next()) {
                filePath = rs.getString("file_path");
            } else {
                response.sendRedirect("DocumentServlet?msg=notfound");
                return;
            }
            rs.close();
            ps.close();

            // Step 2: Delete from database
            ps = con.prepareStatement("DELETE FROM documents WHERE document_id = ?");
            ps.setInt(1, docId);
            int row = ps.executeUpdate();

            if (row > 0) {
                // Step 3: Delete physical file from disk
                if (filePath != null && !filePath.isEmpty()) {
                    File file = new File(getServletContext().getRealPath("") + File.separator + filePath);
                    if (file.exists()) {
                        file.delete();
                    }
                }
                response.sendRedirect("DocumentServlet?msg=deleted");
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
}