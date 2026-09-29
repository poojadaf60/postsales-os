<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList, com.org.Construction"%>
<%
if (session.getAttribute("username") == null) { response.sendRedirect("Loginindex.jsp"); return; }
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
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">
<style>
* { margin:0; padding:0; box-sizing:border-box; font-family:'Poppins',sans-serif; }
body { background:#eef2f7; }
.sidebar { position:fixed; left:0; top:0; width:250px; height:100%; background:#273340; overflow-y:auto; z-index:1000; transition:transform 0.3s ease; }
.logo { padding:22px; font-size:22px; font-weight:bold; text-align:center; color:#E3123D; border-bottom:1px solid rgba(255,255,255,0.1); }
.logo span { color:white; }
.sidebar a { display:block; padding:14px 22px; text-decoration:none; color:white; transition:0.3s; font-size:14px; }
.sidebar a:hover, .sidebar .active { background:#E3123D; }
.main { margin-left:250px; min-height:100vh; }
.navbar { height:70px; background:white; display:flex; justify-content:space-between; align-items:center; padding:0 30px; box-shadow:0 2px 10px rgba(0,0,0,0.08); position:sticky; top:0; z-index:999; }
.navbar .hamburger { display:none; cursor:pointer; font-size:28px; color:#273340; }
.content { padding:30px; }
.top { display:flex; justify-content:space-between; align-items:center; margin-bottom:20px; flex-wrap:wrap; gap:15px; }
.btn-add { background:#E3123D; color:white; padding:12px 22px; border-radius:8px; text-decoration:none; font-weight:600; }
.btn-add:hover { background:#c50d34; }
.timeline { position:relative; padding-left:30px; }
.timeline::before { content:''; position:absolute; left:10px; top:0; bottom:0; width:3px; background:#E3123D; }
.timeline-item { background:white; padding:20px; border-radius:12px; box-shadow:0 5px 15px rgba(0,0,0,0.08); margin-bottom:20px; position:relative; }
.timeline-item::before { content:''; position:absolute; left:-25px; top:25px; width:15px; height:15px; border-radius:50%; background:#E3123D; border:3px solid white; }
.timeline-item h3 { color:#273340; margin-bottom:8px; }
.timeline-item p { color:#666; font-size:14px; }
.timeline-item .date { color:#999; font-size:12px; margin-top:8px; }
.alert-success { background:#d4edda; color:#155724; padding:12px; border-radius:8px; margin-bottom:20px; }
.footer { margin-top:30px; padding:15px 20px; background:#36454F; color:white; text-align:center; border-radius:10px; font-size:13px; }
#sidebar-toggle { display:none; }
.sidebar-overlay { display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.5); z-index:998; cursor:pointer; }
@media(max-width:768px){
.sidebar{ transform:translateX(-100%); width:280px; }
.main{ margin-left:0; }
.navbar .hamburger{ display:block; }
.navbar{ padding:0 15px; height:60px; flex-wrap:wrap; }
.content{ padding:15px; }
#sidebar-toggle:checked ~ .sidebar{ transform:translateX(0); }
#sidebar-toggle:checked ~ .sidebar-overlay{ display:block; }
}
@media(max-width:480px){ .sidebar{ width:100%; } .navbar{ flex-direction:column; height:auto; padding:15px; gap:10px; } }
</style>
</head>
<body>
<input type="checkbox" id="sidebar-toggle">
<div class="sidebar">
    <div class="logo">🏢 <span>Post-Sales</span></div>
    <a href="DashboardServlet">🏠 Dashboard</a>
    <a href="FlatManagementServlet">🏢 Flats</a>
    <a href="AllotteeManagementServlet">👥 Allottees</a>
    <a href="BookingManagementServlet">📅 Bookings</a>
    <a href="PaymentManagementServlet">💳 Payments</a>
    <a href="DocumentServlet">📄 Documents</a>
    <a href="TicketServlet">🎫 Tickets</a>
    <a href="SnagServlet">🔧 Snags</a>
    <a class="active" href="ConstructionServlet">🏗️ Construction</a>
    <a href="PossessionServlet">🔑 Possession</a>
    <a href="ReportServlet">📊 Reports</a>
    <a href="Setting.jsp">⚙ Settings</a>
    <a href="LogoutServlet">🚪 Logout</a>
</div>
<label for="sidebar-toggle" class="sidebar-overlay"></label>
<div class="main">
<div class="navbar">
<div style="display:flex;align-items:center;gap:15px;">
<label for="sidebar-toggle" class="hamburger">☰</label>
<h2 style="margin:0;font-size:20px;color:#273340;">Construction Updates</h2>
</div>
<div>Welcome, <b><%= session.getAttribute("username") %></b></div>
</div>
<div class="content">
<%
String msg = request.getParameter("msg");
if (msg != null) {
if ("success".equals(msg)) { %><div class="alert-success">✅ Update added successfully!</div><% }
}
%>
<div class="top"><h2>Construction Timeline</h2><a href="AddConstruction.jsp" class="btn-add">+ Add Update</a></div>
<div class="timeline">
<%
if (updates != null && !updates.isEmpty()) {
for (Construction c : updates) {
%>
<div class="timeline-item">
<h3>🏗️ <%= c.getMilestone() %></h3>
<p><%= c.getDescription() %></p>
<p class="date">Flat ID: <%= c.getFlatId() %> | <%= c.getUpdateDate() %></p>
<% if (c.getPhotoPath() != null && !c.getPhotoPath().isEmpty()) { %>
<img src="<%= c.getPhotoPath() %>" alt="Construction" style="max-width:100%;border-radius:8px;margin-top:10px;">
<% } %>
</div>
<% } } else { %>
<div class="timeline-item"><p style="text-align:center;color:#999;">No construction updates yet.</p></div>
<% } %>
</div>
<div class="footer"><p>© 2026 Post-Sales & Handover OS</p></div>
</div>
</div>
</body>
</html>