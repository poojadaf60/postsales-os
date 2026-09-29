<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList, com.org.Document"%>
<%
if (session.getAttribute("allotteeId") == null) { response.sendRedirect("Loginindex.jsp"); return; }
ArrayList<Document> documents = (ArrayList<Document>) request.getAttribute("documents");
if (documents == null) documents = new ArrayList<>();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>My Documents</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<style>
* { margin:0; padding:0; box-sizing:border-box; font-family:'Poppins',sans-serif; }
body { background:#eef2f7; color:#273340; }
.navbar { display:flex; justify-content:space-between; align-items:center; padding:18px 40px; background:#273340; color:white; flex-wrap:wrap; gap:10px; }
.navbar .logo { font-size:20px; font-weight:700; color:#E3123D; }
.navbar .logo span { color:white; }
.navbar a { color:#E3123D; text-decoration:none; font-weight:600; margin-left:15px; }
.content { padding:30px 40px; max-width:1200px; margin:0 auto; }
h1 { margin-bottom:20px; }
table { width:100%; background:white; border-collapse:collapse; border-radius:12px; overflow:hidden; box-shadow:0 5px 15px rgba(0,0,0,.08); }
th { background:#34495e; color:white; padding:14px; text-align:left; }
td { padding:14px; border-bottom:1px solid #eee; }
tr:hover { background:#f8f9fb; }
.download { background:#28a745; color:white; padding:8px 14px; border-radius:6px; text-decoration:none; font-size:13px; }
</style>
</head>
<body>
<div class="navbar">
    <div class="logo">🏢 <span>Post-Sales OS</span></div>
    <div>
        <a href="CustomerDashboardServlet">← Dashboard</a>
        <a href="CustomerLogoutServlet">Logout</a>
    </div>
</div>
<div class="content">
    <h1>📄 My Documents</h1>
    <table>
        <thead><tr><th>ID</th><th>Type</th><th>Name</th><th>Version</th><th>Uploaded</th><th>Status</th><th>Action</th></tr></thead>
        <tbody>
        <% if (documents.isEmpty()) { %>
            <tr><td colspan="7" style="text-align:center;padding:30px;color:#999;">No documents found.</td></tr>
        <% } else {
            for (Document d : documents) { %>
            <tr>
                <td><%= d.getDocumentId() %></td>
                <td><%= d.getDocType() %></td>
                <td><%= d.getDocName() %></td>
                <td>V<%= d.getVersion() %></td>
                <td><%= d.getUploadDate() %></td>
                <td><%= d.getStatus() %></td>
                <td><a class="download" href="DocumentDownloadServlet?id=<%= d.getDocumentId() %>">Download</a></td>
            </tr>
        <% } } %>
        </tbody>
    </table>
</div>
</body>
</html>