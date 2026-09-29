<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList, com.org.Snag"%>
<%
if (session.getAttribute("allotteeId") == null) { response.sendRedirect("Loginindex.jsp"); return; }
ArrayList<Snag> snags = (ArrayList<Snag>) request.getAttribute("snags");
if (snags == null) snags = new ArrayList<>();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>My Snags</title>
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
.form-box { background:white; padding:25px; border-radius:12px; box-shadow:0 5px 15px rgba(0,0,0,.08); margin-bottom:25px; }
.form-box h2 { font-size:18px; margin-bottom:15px; }
.form-group { margin-bottom:12px; }
label { display:block; margin-bottom:5px; font-weight:600; font-size:13px; }
input, select, textarea { width:100%; padding:10px; border:1px solid #ddd; border-radius:6px; font-size:14px; outline:none; }
.btn { background:#E3123D; color:white; padding:10px 22px; border:none; border-radius:6px; cursor:pointer; font-weight:600; }
table { width:100%; background:white; border-collapse:collapse; border-radius:12px; overflow:hidden; box-shadow:0 5px 15px rgba(0,0,0,.08); }
th { background:#34495e; color:white; padding:12px; text-align:left; font-size:13px; }
td { padding:12px; border-bottom:1px solid #eee; font-size:13px; }
.badge { padding:4px 10px; border-radius:20px; font-size:11px; font-weight:600; }
.open { background:#f8d7da; color:#721c24; }
.progress { background:#cce5ff; color:#004085; }
.resolved { background:#d4edda; color:#155724; }
.priority-high { color:#dc3545; font-weight:bold; }
.priority-medium { color:#f39c12; font-weight:bold; }
.priority-low { color:#28a745; font-weight:bold; }
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
    <h1>🔧 My Snags</h1>

    <div class="form-box">
        <h2>Raise a New Snag</h2>
        <form action="CustomerSnagsServlet" method="post" enctype="multipart/form-data">
            <div class="form-group"><label>Location</label><input type="text" name="location" placeholder="e.g., Bedroom, Kitchen" required></div>
            <div class="form-group"><label>Description</label><textarea name="description" rows="3"></textarea></div>
            <div class="form-group"><label>Priority</label>
                <select name="priority"><option>High</option><option selected>Medium</option><option>Low</option></select>
            </div>
            <div class="form-group"><label>Photo/Video</label><input type="file" name="photo" accept=".jpg,.jpeg,.png,.mp4,.mov"></div>
            <button class="btn" type="submit">Raise Snag</button>
        </form>
    </div>

    <table>
        <thead><tr><th>ID</th><th>Location</th><th>Description</th><th>Priority</th><th>Status</th><th>Created</th></tr></thead>
        <tbody>
        <% if (snags.isEmpty()) { %>
            <tr><td colspan="6" style="text-align:center;padding:30px;color:#999;">No snags yet.</td></tr>
        <% } else {
            for (Snag s : snags) {
                String cls = "open";
                if ("In Progress".equalsIgnoreCase(s.getStatus())) cls = "progress";
                else if ("Resolved".equalsIgnoreCase(s.getStatus()) || "Customer Verified".equalsIgnoreCase(s.getStatus())) cls = "resolved";
                String prCls = "priority-medium";
                if ("High".equalsIgnoreCase(s.getPriority())) prCls = "priority-high";
                else if ("Low".equalsIgnoreCase(s.getPriority())) prCls = "priority-low";
        %>
            <tr>
                <td><%= s.getSnagId() %></td>
                <td><%= s.getLocation() %></td>
                <td><%= s.getDescription() %></td>
                <td class="<%= prCls %>"><%= s.getPriority() %></td>
                <td><span class="badge <%= cls %>"><%= s.getStatus() %></span></td>
                <td><%= s.getCreatedDate() %></td>
            </tr>
        <% } } %>
        </tbody>
    </table>
</div>
</body>
</html>