<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
if (session.getAttribute("username") == null) { response.sendRedirect("Loginindex.jsp"); return; }
String flatId = String.valueOf(request.getAttribute("flatId"));
String unitNo = (String) request.getAttribute("unitNo");
String flatType = (String) request.getAttribute("flatType");
String tower = (String) request.getAttribute("tower");
String floor = String.valueOf(request.getAttribute("floor"));
String agreementValue = String.valueOf(request.getAttribute("agreementValue"));
String status = (String) request.getAttribute("status");
String possessionDate = (String) request.getAttribute("possessionDate");
String reraNo = (String) request.getAttribute("reraNo");
if (unitNo == null) { response.sendRedirect("FlatManagementServlet"); return; }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Edit Flat</title>
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
.row { display:flex; gap:20px; margin-bottom:20px; }
.col { flex:1; }
label { display:block; margin-bottom:8px; font-weight:600; color:#333; }
input, select { width:100%; padding:12px; border:1px solid #ddd; border-radius:8px; font-size:15px; outline:none; }
input:focus, select:focus { border-color:#E3123D; }
.btn-update { width:100%; padding:14px; background:#17a2b8; color:#fff; font-size:17px; border:none; border-radius:8px; cursor:pointer; transition:0.3s; }
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
.row { flex-direction:column; gap:15px; }
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
<h2 style="margin:0;font-size:20px;color:#273340;">Edit Flat</h2>
</div>
<div>Welcome, <b><%= session.getAttribute("username") %></b></div>
</div>
<div class="content">
<div class="form-box">
<h2>✏️ Edit Flat</h2>
<form action="EditFlatServlet" method="post">
<input type="hidden" name="flatId" value="<%= flatId %>">
<div class="row">
<div class="col"><label>Unit Number</label><input type="text" name="unit_no" value="<%= unitNo %>" required></div>
<div class="col"><label>Flat Type</label>
<select name="flat_type">
<option <%= "1BHK".equals(flatType)?"selected":"" %>>1BHK</option>
<option <%= "2BHK".equals(flatType)?"selected":"" %>>2BHK</option>
<option <%= "3BHK".equals(flatType)?"selected":"" %>>3BHK</option>
<option <%= "4BHK".equals(flatType)?"selected":"" %>>4BHK</option>
</select>
</div>
</div>
<div class="row">
<div class="col"><label>Tower</label><input type="text" name="tower" value="<%= tower %>" required></div>
<div class="col"><label>Floor</label><input type="number" name="floor" value="<%= floor %>" required></div>
</div>
<div class="row">
<div class="col"><label>Agreement Value (₹)</label><input type="number" step="0.01" name="agreement_value" value="<%= agreementValue %>" required></div>
<div class="col"><label>Status</label>
<select name="status">
<option <%= "Available".equals(status)?"selected":"" %>>Available</option>
<option <%= "Booked".equals(status)?"selected":"" %>>Booked</option>
<option <%= "Possession Given".equals(status)?"selected":"" %>>Possession Given</option>
<option <%= "Under Construction".equals(status)?"selected":"" %>>Under Construction</option>
</select>
</div>
</div>
<div class="row">
<div class="col"><label>Possession Date</label><input type="date" name="possession_date" value="<%= possessionDate %>"></div>
<div class="col"><label>RERA Number</label><input type="text" name="rera_no" value="<%= reraNo %>"></div>
</div>
<button class="btn-update" type="submit">💾 Update Flat</button>
</form>
<a href="FlatManagementServlet" class="btn-back">← Back to Flat Management</a>
</div>
<div class="footer"><p>© 2026 Post-Sales & Handover OS</p></div>
</div>
</div>
</body>
</html>