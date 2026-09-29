<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.org.Allottee"%>
<%
if (session.getAttribute("username") == null) { response.sendRedirect("Loginindex.jsp"); return; }
ArrayList<Allottee> allottees = (ArrayList<Allottee>) request.getAttribute("allottees");
Integer totalAllottees = (Integer) request.getAttribute("totalAllottees");
if (totalAllottees == null) totalAllottees = 0;

int verified = 0;
int pending = 0;
if (allottees != null) {
    for (Allottee a : allottees) {
        if ("Verified".equalsIgnoreCase(a.getKycStatus())) verified++;
        else pending++;
    }
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Allottee Management</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">
<style>
* { margin:0; padding:0; box-sizing:border-box; font-family:'Poppins',sans-serif; }
body { background:#eef2f7; }

/* SIDEBAR */
.sidebar { position:fixed; left:0; top:0; width:250px; height:100%; background:#273340; overflow-y:auto; z-index:1000; transition:transform 0.3s ease; }
.logo { padding:22px; font-size:22px; font-weight:bold; text-align:center; color:#E3123D; border-bottom:1px solid rgba(255,255,255,0.1); }
.logo span { color:white; }
.sidebar a { display:block; padding:14px 22px; text-decoration:none; color:white; transition:0.3s; font-size:14px; }
.sidebar a:hover, .sidebar .active { background:#E3123D; }

/* MAIN */
.main { margin-left:250px; min-height:100vh; display:flex; flex-direction:column; }
.navbar { height:70px; background:white; display:flex; justify-content:space-between; align-items:center; padding:0 30px; box-shadow:0 2px 10px rgba(0,0,0,0.08); position:sticky; top:0; z-index:999; }
.navbar .hamburger { display:none; cursor:pointer; font-size:28px; color:#273340; }
.content { padding:30px; flex:1; }

/* TOP BAR */
.top { display:flex; justify-content:space-between; align-items:center; margin-bottom:20px; flex-wrap:wrap; gap:15px; }
.btn-add { background:#E3123D; color:white; padding:12px 22px; border-radius:8px; text-decoration:none; font-weight:600; display:inline-block; white-space:nowrap; }
.btn-add:hover { background:#c50d34; }

/* CARDS */
.cards { display:grid; grid-template-columns:repeat(3,1fr); gap:20px; margin-bottom:25px; }
.card { background:white; padding:22px; border-radius:12px; box-shadow:0 5px 15px rgba(0,0,0,0.08); }
.card h3 { font-size:28px; color:#273340; }
.card p { margin-top:6px; color:#777; font-size:13px; }

/* TABLE */
.table-wrapper { overflow-x:auto; }
table { width:100%; background:white; border-collapse:collapse; border-radius:12px; overflow:hidden; box-shadow:0 5px 15px rgba(0,0,0,0.08); min-width:900px; }
th { background:#34495e; color:white; padding:14px; text-align:left; white-space:nowrap; }
td { padding:14px; border-bottom:1px solid #eee; vertical-align:middle; }
tr:hover { background:#f8f9fb; }

/* ACTION COLUMN - FIXED */
th:last-child, td:last-child {
    min-width:160px;
    text-align:center;
    white-space:nowrap;
}
.action-buttons {
    display:flex;
    gap:6px;
    justify-content:center;
    flex-wrap:nowrap;
}
.edit, .delete {
    display:inline-block;
    white-space:nowrap;
    padding:8px 14px;
    border-radius:6px;
    text-decoration:none;
    font-size:13px;
    font-weight:500;
}
.edit { background:#17a2b8; color:white; }
.edit:hover { background:#138496; }
.delete { background:#dc3545; color:white; }
.delete:hover { background:#c82333; }

/* STATUS BADGES */
.status-badge { padding:5px 12px; border-radius:20px; font-size:12px; font-weight:600; display:inline-block; white-space:nowrap; }
.verified { background:#d4edda; color:#155724; }
.pending { background:#fff3cd; color:#856404; }

/* ALERTS */
.alert-success { background:#d4edda; color:#155724; padding:12px; border-radius:8px; margin-bottom:20px; }
.alert-error { background:#f8d7da; color:#721c24; padding:12px; border-radius:8px; margin-bottom:20px; }

/* FOOTER */
.footer { margin-top:30px; padding:15px 20px; background:#36454F; color:white; text-align:center; border-radius:10px; font-size:13px; }

/* MOBILE */
#sidebar-toggle { display:none; }
.sidebar-overlay { display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.5); z-index:998; cursor:pointer; }
@media(max-width:768px){
.sidebar { transform:translateX(-100%); width:280px; }
.main { margin-left:0; }
.navbar .hamburger { display:block; }
.navbar { padding:0 15px; height:60px; flex-wrap:wrap; }
.content { padding:15px; }
.cards { grid-template-columns:1fr 1fr; }
#sidebar-toggle:checked ~ .sidebar { transform:translateX(0); }
#sidebar-toggle:checked ~ .sidebar-overlay { display:block; }
}
@media(max-width:480px){
.sidebar { width:100%; }
.cards { grid-template-columns:1fr; }
.navbar { flex-direction:column; height:auto; padding:15px; gap:10px; }
}
</style>
</head>
<body>
<input type="checkbox" id="sidebar-toggle">
<div class="sidebar">
    <div class="logo">🏢 <span>Post-Sales</span></div>
    <a href="DashboardServlet">🏠 Dashboard</a>
    <a href="FlatManagementServlet">🏢 Flats</a>
    <a class="active" href="AllotteeManagementServlet">👥 Allottees</a>
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
<h2 style="margin:0;font-size:20px;color:#273340;">Allottee Management</h2>
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
<div class="top">
<h2>All Allottees</h2>
<a href="AddAllottee.jsp" class="btn-add">+ Add Allottee</a>
</div>

<div class="cards">
<div class="card"><h3><%= totalAllottees %></h3><p>Total Allottees</p></div>
<div class="card"><h3><%= verified %></h3><p>Verified KYC</p></div>
<div class="card"><h3><%= pending %></h3><p>Pending KYC</p></div>
</div>

<div class="table-wrapper">
<table>
<thead>
<tr>
<th>ID</th>
<th>Name</th>
<th>Email</th>
<th>Phone</th>
<th>Address</th>
<th>KYC Status</th>
<th>Action</th>
</tr>
</thead>
<tbody>
<%
if (allottees != null && !allottees.isEmpty()) {
for (Allottee a : allottees) {
String kyc = a.getKycStatus();
String cls = "pending";
if ("Verified".equalsIgnoreCase(kyc)) cls = "verified";
%>
<tr>
<td><%= a.getAllotteeId() %></td>
<td><%= a.getName() %></td>
<td><%= a.getEmail() %></td>
<td><%= a.getPhone() %></td>
<td><%= a.getAddress() %></td>
<td><span class="status-badge <%= cls %>"><%= kyc %></span></td>
<td>
<div class="action-buttons">
<a class="edit" href="EditAllotteeServlet?id=<%= a.getAllotteeId() %>">Edit</a>
<a class="delete" href="DeleteAllotteeServlet?id=<%= a.getAllotteeId() %>" onclick="return confirm('Delete this allottee?');">Delete</a>
</div>
</td>
</tr>
<% } } else { %>
<tr><td colspan="7" style="text-align:center;padding:30px;color:#999;">No allottees found</td></tr>
<% } %>
</tbody>
</table>
</div>

<div class="footer"><p>© 2026 Post-Sales & Handover OS</p></div>
</div>
</div>
</body>
</html>