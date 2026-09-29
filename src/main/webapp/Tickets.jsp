<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList, com.org.Ticket"%>
<%
if (session.getAttribute("username") == null) { response.sendRedirect("Loginindex.jsp"); return; }
ArrayList<Ticket> tickets = (ArrayList<Ticket>) request.getAttribute("tickets");
if (tickets == null) tickets = new ArrayList<>();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Tickets</title>
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
.table-wrapper { overflow-x:auto; }
table { width:100%; background:white; border-collapse:collapse; border-radius:12px; overflow:hidden; box-shadow:0 5px 15px rgba(0,0,0,0.08); min-width:800px; }
th { background:#34495e; color:white; padding:14px; text-align:left; }
td { padding:14px; border-bottom:1px solid #eee; }
tr:hover { background:#f8f9fb; }
.status-badge { padding:5px 12px; border-radius:20px; font-size:12px; font-weight:600; }
.open { background:#f8d7da; color:#721c24; }
.assigned { background:#fff3cd; color:#856404; }
.progress { background:#cce5ff; color:#004085; }
.resolved { background:#d4edda; color:#155724; }
.update-btn { background:#17a2b8; color:white; padding:8px 14px; border-radius:6px; text-decoration:none; font-size:13px; }
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
    <a class="active" href="TicketServlet">🎫 Tickets</a>
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
<h2 style="margin:0;font-size:20px;color:#273340;">Tickets</h2>
</div>
<div>Welcome, <b><%= session.getAttribute("username") %></b></div>
</div>
<div class="content">
<%
String msg = request.getParameter("msg");
if (msg != null) {
if ("success".equals(msg) || "updated".equals(msg)) { %><div class="alert-success">✅ Operation successful!</div><% }
else if ("error".equals(msg)) { %><div class="alert-error">❌ Something went wrong.</div><% }
}
%>
<div class="top"><h2>All Tickets</h2><a href="RaiseTicket.jsp" class="btn-add">+ Raise Ticket</a></div>
<div class="table-wrapper">
<table>
<thead><tr><th>ID</th><th>Booking ID</th><th>Subject</th><th>Department</th><th>Assigned To</th><th>SLA</th><th>Status</th><th>Created</th><th>Action</th></tr></thead>
<tbody>
<%
if (tickets != null && !tickets.isEmpty()) {
for (Ticket t : tickets) {
String st = t.getStatus();
String cls = "open";
if ("Assigned".equalsIgnoreCase(st)) cls = "assigned";
else if ("In Progress".equalsIgnoreCase(st)) cls = "progress";
else if ("Resolved".equalsIgnoreCase(st)) cls = "resolved";
%>
<tr>
<td><%= t.getTicketId() %></td>
<td><%= t.getBookingId() %></td>
<td><%= t.getSubject() %></td>
<td><%= t.getDepartment() %></td>
<td><%= t.getAssignedTo() %></td>
<td><%= t.getSlaHours() %> hrs</td>
<td><span class="status-badge <%= cls %>"><%= st %></span></td>
<td><%= t.getCreatedDate() %></td>
<td>
<form action="TicketUpdateServlet" method="post" style="display:inline;">
<input type="hidden" name="ticketId" value="<%= t.getTicketId() %>">
<select name="status" style="padding:6px;border-radius:6px;border:1px solid #ddd;">
<option <%= "Open".equals(st)?"selected":"" %>>Open</option>
<option <%= "Assigned".equals(st)?"selected":"" %>>Assigned</option>
<option <%= "In Progress".equals(st)?"selected":"" %>>In Progress</option>
<option <%= "Resolved".equals(st)?"selected":"" %>>Resolved</option>
<option <%= "Closed".equals(st)?"selected":"" %>>Closed</option>
</select>
<input type="hidden" name="assignedTo" value="<%= t.getAssignedTo() %>">
<button class="update-btn" type="submit">Update</button>
</form>
</td>
</tr>
<% } } else { %>
<tr><td colspan="9" style="text-align:center;padding:30px;color:#999;">No tickets found</td></tr>
<% } %>
</tbody>
</table>
</div>
<div class="footer"><p>© 2026 Post-Sales & Handover OS</p></div>
</div>
</div>
</body>
</html>