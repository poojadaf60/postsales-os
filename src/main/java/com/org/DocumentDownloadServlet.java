package com.org;

import java.io.*;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/DocumentDownloadServlet")
public class DocumentDownloadServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int docId = Integer.parseInt(request.getParameter("id"));
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement("SELECT file_path, doc_name FROM documents WHERE document_id = ?");
            ps.setInt(1, docId);
            rs = ps.executeQuery();

            if (rs.next()) {
                String filePath = rs.getString("file_path");
                String docName = rs.getString("doc_name");
                File file = new File(getServletContext().getRealPath("") + File.separator + filePath);

                if (file.exists()) {
                    response.setContentType("application/octet-stream");
                    response.setHeader("Content-Disposition", "attachment; filename=\"" + docName + "\"");
                    FileInputStream fis = new FileInputStream(file);
                    OutputStream os = response.getOutputStream();
                    byte[] buffer = new byte[4096];
                    int bytesRead;
                    while ((bytesRead = fis.read(buffer)) != -1) {
                        os.write(buffer, 0, bytesRead);
                    }
                    fis.close();
                    os.close();
                } else {
                    response.sendRedirect("DocumentServlet?msg=notfound");
                }
            } else {
                response.sendRedirect("DocumentServlet?msg=notfound");
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