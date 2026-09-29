<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList, com.org.Construction"%>
<%
if (session.getAttribute("allotteeId") == null) { response.sendRedirect("Loginindex.jsp"); return; }
ArrayList<Construction> updates = (ArrayList<Construction>) request.getAttribute("updates");
if (updates == null) updates = new ArrayList<>();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Construction Updates</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<style>
* { margin:0; padding:0; box-sizing:border-box; font-family:'Poppins',sans-serif; }
body { background:#eef2f7; color:#273340; }
.navbar { display:flex; justify-content:space-between; align-items:center; padding:18px 40px; background:#273340; color:white; flex-wrap:wrap; gap:10px; }
.navbar .logo { font-size:20px; font-weight:700; color:#E3123D; }
.navbar .logo span { color:white; }
.navbar a { color:#E3123D; text-decoration:none; font-weight:600; margin-left:15px; }
.content { padding:30px 40px; max-width:900px; margin:0 auto; }
h1 { margin-bottom:25px; }
.timeline { position:relative; padding-left:30px; }
.timeline::before { content:''; position:absolute; left:10px; top:0; bottom:0; width:3px; background:#E3123D; }
.timeline-item { background:white; padding:20px; border-radius:12px; box-shadow:0 5px 15px rgba(0,0,0,.08); margin-bottom:20px; position:relative; }
.timeline-item::before { content:''; position:absolute; left:-25px; top:25px; width:15px; height:15px; border-radius:50%; background:#E3123D; border:3px solid white; }
.timeline-item h3 { color:#273340; margin-bottom:8px; font-size:16px; }
.timeline-item p { color:#666; font-size:14px; }
.timeline-item .date { color:#999; font-size:12px; margin-top:8px; }
.timeline-item img { max-width:100%; border-radius:8px; margin-top:10px; }
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
    <h1>🏗️ Construction Updates</h1>
    <div class="timeline">
    <% if (updates.isEmpty()) { %>
        <div class="timeline-item"><p style="text-align:center;color:#999;">No construction updates yet.</p></div>
    <% } else {
        for (Construction c : updates) { %>
        <div class="timeline-item">
            <h3>🏗️ <%= c.getMilestone() %></h3>
            <p><%= c.getDescription() %></p>
            <p class="date"><%= c.getUpdateDate() %></p>
            <% if (c.getPhotoPath() != null && !c.getPhotoPath().isEmpty()) { %>
                <img src="<%= c.getPhotoPath() %>" alt="Construction">
            <% } %>
        </div>
    <% } } %>
    </div>
</div>
</body>
</html>