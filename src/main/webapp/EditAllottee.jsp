<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.org.Allottee"%>
<%
if (session.getAttribute("username") == null) { response.sendRedirect("Loginindex.jsp"); return; }
Allottee a = (Allottee) request.getAttribute("allottee");
if (a == null) { response.sendRedirect("AllotteeManagementServlet"); return; }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Edit Allottee</title>
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
.content { padding:30px; display:flex; justify-content:center; }
.form-box { width:100%; max-width:700px; background:#fff; padding:35px; border-radius:15px; box-shadow:0 8px 20px rgba(0,0,0,0.12); }
.form-box h2 { text-align:center; margin-bottom:25px; color:#273340; }
.form-group { margin-bottom:18px; }
label { display:block; margin-bottom:8px; font-weight:600; color:#333; }
input, select, textarea { width:100%; padding:12px; border:1px solid #ddd; border-radius:8px; font-size:15px; outline:none; }
input:focus, select:focus, textarea:focus { border-color:#E3123D; }
.btn-update { width:100%; padding:14px; background:#17a2b8; color:#fff; font-size:17px; border:none; border-radius:8px; cursor:pointer; }
.btn-update:hover { background:#138496; }
.btn-back { display:block; text-align:center; margin-top:15px; text-decoration:none; color:#273340; font-weight:600; }
.footer { margin-top:30px; padding:15px 20px; background:#36454F; color:white; text-align:center; border-radius:10px; font-size:14px; width:100%; max-width:700px; }
#sidebar-toggle { display:none; }
.sidebar-overlay { display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.5); z-index:998; cursor:pointer; }
@media(max-width:768px){
.sidebar { transform:translateX(-100%); width:280px; }
.main { margin-left:0; }
.navbar .hamburger { display:block; }
.navbar { padding:0 15px; height:60px; flex-wrap:wrap; }
.content { padding:15px; }
.form-box { padding:20px; }
#sidebar-toggle:checked ~ .sidebar { transform:translateX(0); }
#sidebar-toggle:checked ~ .sidebar-overlay { display:block; }
}
@media(max-width:480px){ .sidebar { width:100%; } .navbar { flex-direction:column; height:auto; padding:15px; gap:10px; } }
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
<h2 style="margin:0;font-size:20px;color:#273340;">Edit Allottee</h2>
</div>
<div>Welcome, <b><%= session.getAttribute("username") %></b></div>
</div>
<div class="content">
<div class="form-box">
<h2>✏️ Edit Allottee</h2>
<form action="EditAllotteeServlet" method="post">
<input type="hidden" name="allotteeId" value="<%= a.getAllotteeId() %>">
<div class="form-group"><label>Full Name</label><input type="text" name="name" value="<%= a.getName() %>" required></div>
<div class="form-group"><label>Email</label><input type="email" name="email" value="<%= a.getEmail() %>" required></div>
<div class="form-group"><label>Phone</label><input type="text" name="phone" value="<%= a.getPhone() %>" required></div>
<div class="form-group"><label>Address</label><textarea name="address" rows="3" required><%= a.getAddress() %></textarea></div>
<div class="form-group"><label>KYC Status</label>
<select name="kyc_status">
<option <%= "Pending".equals(a.getKycStatus())?"selected":"" %>>Pending</option>
<option <%= "Verified".equals(a.getKycStatus())?"selected":"" %>>Verified</option>
</select>
</div>
<button class="btn-update" type="submit">💾 Update Allottee</button>
</form>
<a href="AllotteeManagementServlet" class="btn-back">← Back</a>
</div>
<div class="footer"><p>© 2026 Post-Sales & Handover OS</p></div>
</div>
</div>
</body>
</html>