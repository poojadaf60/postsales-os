<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.org.Flat"%>
<%
if (session.getAttribute("username") == null) { response.sendRedirect("Loginindex.jsp"); return; }
List<Flat> flats = (List<Flat>) request.getAttribute("flats");
Integer availableFlats = (Integer) request.getAttribute("availableFlats");
Integer bookedFlats = (Integer) request.getAttribute("bookedFlats");
Integer possessionFlats = (Integer) request.getAttribute("possessionFlats");
if (availableFlats == null) availableFlats = 0;
if (bookedFlats == null) bookedFlats = 0;
if (possessionFlats == null) possessionFlats = 0;
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Flat Management</title>
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
.btn-add { background:#E3123D; color:white; padding:12px 22px; border-radius:8px; text-decoration:none; font-weight:600; transition:0.3s; }
.btn-add:hover { background:#c50d34; }
.cards { display:grid; grid-template-columns:repeat(4,1fr); gap:20px; margin-bottom:25px; }
.card { background:white; padding:22px; border-radius:12px; box-shadow:0 5px 15px rgba(0,0,0,0.08); }
.card h3 { font-size:28px; color:#273340; }
.card p { margin-top:6px; color:#777; font-size:13px; }
.table-wrapper { overflow-x:auto; }
table { width:100%; background:white; border-collapse:collapse; border-radius:12px; overflow:hidden; box-shadow:0 5px 15px rgba(0,0,0,0.08); min-width:700px; }
th { background:#34495e; color:white; padding:14px; text-align:left; }
td { padding:14px; border-bottom:1px solid #eee; }
tr:hover { background:#f8f9fb; }
.status-badge { padding:5px 12px; border-radius:20px; font-size:12px; font-weight:600; }
.available { background:#d4edda; color:#155724; }
.booked { background:#f8d7da; color:#721c24; }
.possession { background:#cce5ff; color:#004085; }
.edit { background:#17a2b8; color:white; padding:8px 14px; border-radius:6px; text-decoration:none; font-size:13px; }
.delete { background:#dc3545; color:white; padding:8px 14px; border-radius:6px; text-decoration:none; font-size:13px; margin-left:5px; }
.alert-success { background:#d4edda; color:#155724; padding:12px; border-radius:8px; margin-bottom:20px; }
.alert-error { background:#f8d7da; color:#721c24; padding:12px; border-radius:8px; margin-bottom:20px; }
.footer { margin-top:30px; padding:15px 20px; background:#36454F; color:white; text-align:center; border-radius:10px; font-size:13px; }
#sidebar-toggle { display:none; }
.sidebar-overlay { display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.5); z-index:998; cursor:pointer; }
@media(max-width:768px){
.sidebar{ transform:translateX(-100%); width:280px; }
.main{ margin-left:0; }
.navbar .hamburger{ display:block; }
.navbar{ padding:0 15px; height:60px; flex-wrap:wrap; }
.content{ padding:15px; }
.cards{ grid-template-columns:1fr 1fr; }
#sidebar-toggle:checked ~ .sidebar{ transform:translateX(0); }
#sidebar-toggle:checked ~ .sidebar-overlay{ display:block; }
}
@media(max-width:480px){ .sidebar{ width:100%; } .cards{ grid-template-columns:1fr; } .navbar{ flex-direction:column; height:auto; padding:15px; gap:10px; } }
</style>
</head>
<body>
<input type="checkbox" id="sidebar-toggle">
<div class="sidebar">
    <div class="logo">🏢 <span>Post-Sales</span></div>
    <a href="DashboardServlet">🏠 Dashboard</a>
    <a class="active" href="FlatManagementServlet">🏢 Flats</a>
    <a href="AllotteeManagementServlet">👥 Allottees</a>
    <a href="BookingManagementServlet">📅 Bookings</a>
    <a href="PaymentManagementServlet">💳 Payments</a>
    <a href="DocumentServlet">📄 Documents</a>
    <a href="TicketServlet">🎫 Tickets</a>
    <a href="SnagServlet">🔧 Snags</a>
    <a href="ConstructionServlet">🏗️ Construction</a>
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
<h2 style="margin:0;font-size:20px;color:#273340;">Flat Management</h2>
</div>
<div>Welcome, <b><%= session.getAttribute("username") %></b></div>
</div>
<div class="content">
<%
String msg = request.getParameter("msg");
if (msg != null) {
if ("success".equals(msg) || "updated".equals(msg) || "deleted".equals(msg)) { %><div class="alert-success">✅ Operation successful!</div><% }
else if ("error".equals(msg)) { %><div class="alert-error">❌ Something went wrong.</div><% }
}
%>
<div class="top"><h2>All Flats</h2><a href="AddFlat.jsp" class="btn-add">+ Add Flat</a></div>
<div class="cards">
<div class="card"><h3><%= (flats == null) ? 0 : flats.size() %></h3><p>Total Flats</p></div>
<div class="card"><h3><%= availableFlats %></h3><p>Available</p></div>
<div class="card"><h3><%= bookedFlats %></h3><p>Booked</p></div>
<div class="card"><h3><%= possessionFlats %></h3><p>Possession Given</p></div>
</div>
<div class="table-wrapper">
<table>
<thead><tr><th>ID</th><th>Unit No</th><th>Type</th><th>Tower</th><th>Floor</th><th>Agreement Value</th><th>Status</th><th>Action</th></tr></thead>
<tbody>
<%
if (flats != null && !flats.isEmpty()) {
for (Flat f : flats) {
String st = f.getStatus();
String cls = "available";
if ("Booked".equalsIgnoreCase(st)) cls = "booked";
else if ("Possession Given".equalsIgnoreCase(st)) cls = "possession";
%>
<tr>
<td><%= f.getFlatId() %></td>
<td><%= f.getUnitNo() %></td>
<td><%= f.getFlatType() %></td>
<td><%= f.getTower() %></td>
<td><%= f.getFloor() %></td>
<td>₹ <%= String.format("%.2f", f.getAgreementValue()) %></td>
<td><span class="status-badge <%= cls %>"><%= st %></span></td>
<td>
<a class="edit" href="EditFlatServlet?id=<%= f.getFlatId() %>">Edit</a>
<a class="delete" href="DeleteFlatServlet?id=<%= f.getFlatId() %>" onclick="return confirm('Delete this flat?');">Delete</a>
</td>
</tr>
<% } } else { %>
<tr><td colspan="8" style="text-align:center;padding:30px;color:#999;">No flats found</td></tr>
<% } %>
</tbody>
</table>
</div>
<div class="footer"><p>© 2026 Post-Sales & Handover OS</p></div>
</div>
</div>
</body>
</html>