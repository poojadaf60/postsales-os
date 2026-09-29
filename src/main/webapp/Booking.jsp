<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList, com.org.Booking"%>
<%
if (session.getAttribute("username") == null) { response.sendRedirect("Loginindex.jsp"); return; }
ArrayList<Booking> bookings = (ArrayList<Booking>) request.getAttribute("bookings");
if (bookings == null) bookings = new ArrayList<>();
int total = bookings.size();
int confirmed = 0, pending = 0, cancelled = 0;
for (Booking b : bookings) {
String status = b.getStatus();
if ("Confirmed".equalsIgnoreCase(status)) confirmed++;
else if ("Pending".equalsIgnoreCase(status)) pending++;
else if ("Cancelled".equalsIgnoreCase(status)) cancelled++;
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Booking Management</title>
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
.stats { display:grid; grid-template-columns:repeat(4,1fr); gap:20px; margin-bottom:25px; }
.stat-card { background:white; padding:22px; border-radius:12px; box-shadow:0 5px 15px rgba(0,0,0,0.08); }
.stat-card h3 { font-size:28px; color:#273340; }
.stat-card p { margin-top:6px; color:#777; font-size:13px; }
.table-wrapper { overflow-x:auto; }
table { width:100%; background:white; border-collapse:collapse; border-radius:12px; overflow:hidden; box-shadow:0 5px 15px rgba(0,0,0,0.08); min-width:700px; }
th { background:#34495e; color:white; padding:14px; text-align:left; }
td { padding:14px; border-bottom:1px solid #eee; }
tr:hover { background:#f8f9fb; }
.status-badge { padding:5px 12px; border-radius:20px; font-size:12px; font-weight:600; }
.confirmed { background:#d4edda; color:#155724; }
.pending { background:#fff3cd; color:#856404; }
.cancelled { background:#f8d7da; color:#721c24; }
.possession { background:#cce5ff; color:#004085; }
.edit { background:#17a2b8; color:white; padding:8px 14px; border-radius:6px; text-decoration:none; font-size:13px; }
.delete { background:#dc3545; color:white; padding:8px 14px; border-radius:6px; text-decoration:none; font-size:13px; margin-left:5px; }
.alert-success { background:#d4edda; color:#155724; padding:12px; border-radius:8px; margin-bottom:20px; }
.alert-error { background:#f8d7da; color:#721c24; padding:12px; border-radius:8px; margin-bottom:20px; }
.footer { margin-top:30px; padding:15px 20px; background:#36454F; color:white; text-align:center; border-radius:10px; font-size:13px; }
#sidebar-toggle { display:none; }
.sidebar-overlay { display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.5); z-index:998; cursor:pointer; }
@media(max-width:992px){ .stats{ grid-template-columns:repeat(2,1fr); } }
@media(max-width:768px){
.sidebar{ transform:translateX(-100%); width:280px; }
.main{ margin-left:0; }
.navbar .hamburger{ display:block; }
.navbar{ padding:0 15px; height:60px; flex-wrap:wrap; }
.content{ padding:15px; }
.stats{ grid-template-columns:1fr 1fr; }
#sidebar-toggle:checked ~ .sidebar{ transform:translateX(0); }
#sidebar-toggle:checked ~ .sidebar-overlay{ display:block; }
}
@media(max-width:480px){ .sidebar{ width:100%; } .stats{ grid-template-columns:1fr; } .navbar{ flex-direction:column; height:auto; padding:15px; gap:10px; } }
</style>
</head>
<body>
<input type="checkbox" id="sidebar-toggle">
<div class="sidebar">
    <div class="logo">🏢 <span>Post-Sales</span></div>
    <a href="DashboardServlet">🏠 Dashboard</a>
    <a href="FlatManagementServlet">🏢 Flats</a>
    <a href="AllotteeManagementServlet">👥 Allottees</a>
    <a class="active" href="BookingManagementServlet">📅 Bookings</a>
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
<h2 style="margin:0;font-size:20px;color:#273340;">Booking Management</h2>
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
<div class="top"><h2>All Bookings</h2><a href="BookingServlet" class="btn-add">+ Add Booking</a></div>
<div class="stats">
<div class="stat-card"><h3><%= total %></h3><p>Total Bookings</p></div>
<div class="stat-card"><h3><%= confirmed %></h3><p>Confirmed</p></div>
<div class="stat-card"><h3><%= pending %></h3><p>Pending</p></div>
<div class="stat-card"><h3><%= cancelled %></h3><p>Cancelled</p></div>
</div>
<div class="table-wrapper">
<table>
<thead><tr><th>Booking ID</th><th>Allottee ID</th><th>Flat ID</th><th>Booking Date</th><th>Possession Date</th><th>Total Amount</th><th>Status</th><th>Action</th></tr></thead>
<tbody>
<%
if (!bookings.isEmpty()) {
for (Booking b : bookings) {
String status = b.getStatus();
String cls = "pending";
if ("Confirmed".equalsIgnoreCase(status)) cls = "confirmed";
else if ("Cancelled".equalsIgnoreCase(status)) cls = "cancelled";
else if ("Possession Given".equalsIgnoreCase(status)) cls = "possession";
%>
<tr>
<td><%= b.getBookingId() %></td>
<td><%= b.getAllotteeId() %></td>
<td><%= b.getFlatId() %></td>
<td><%= b.getBookingDate() %></td>
<td><%= b.getPossessionDate() %></td>
<td>₹ <%= String.format("%.2f", b.getTotalAmount()) %></td>
<td><span class="status-badge <%= cls %>"><%= status %></span></td>
<td>
<a class="edit" href="EditBookingServlet?id=<%= b.getBookingId() %>">Edit</a>
<a class="delete" href="DeleteBookingServlet?id=<%= b.getBookingId() %>" onclick="return confirm('Delete this booking?');">Delete</a>
</td>
</tr>
<% } } else { %>
<tr><td colspan="8" style="text-align:center;padding:30px;color:#999;">No bookings found</td></tr>
<% } %>
</tbody>
</table>
</div>
<div class="footer"><p>© 2026 Post-Sales & Handover OS</p></div>
</div>
</div>
</body>
</html>