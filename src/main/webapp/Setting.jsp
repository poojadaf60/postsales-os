<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
if (session.getAttribute("username") == null) { response.sendRedirect("Loginindex.jsp"); return; }
String username = (String) session.getAttribute("username");
String email = (String) session.getAttribute("email");
String role = (String) session.getAttribute("role");
String profilePic = (String) session.getAttribute("profilePic");
if (profilePic == null || profilePic.isEmpty()) {
    profilePic = "https://ui-avatars.com/api/?name=" + username + "&background=E3123D&color=fff&size=100";
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Settings – Post-Sales OS</title>
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
.content { padding:30px; max-width:900px; margin:auto; }
.card { background:white; border-radius:12px; box-shadow:0 5px 15px rgba(0,0,0,0.08); padding:30px; margin-bottom:30px; }
.card h3 { color:#273340; margin-bottom:20px; border-bottom:2px solid #eef2f7; padding-bottom:10px; }
.form-group { margin-bottom:18px; }
label { display:block; margin-bottom:6px; font-weight:600; color:#555; }
input { width:100%; padding:12px; border:1px solid #ddd; border-radius:8px; outline:none; font-size:15px; }
input:focus { border-color:#E3123D; }
.btn { background:#E3123D; color:white; border:none; padding:12px 30px; border-radius:8px; font-size:16px; font-weight:600; cursor:pointer; }
.btn:hover { background:#c50d34; }
.btn-secondary { background:#17a2b8; }
.btn-secondary:hover { background:#138496; }
.profile-pic { width:100px; height:100px; border-radius:50%; object-fit:cover; border:4px solid #E3123D; }
.msg-success { background:#d4edda; color:#155724; padding:12px; border-radius:8px; margin-bottom:20px; }
.footer { margin-top:30px; padding:15px 20px; background:#36454F; color:white; text-align:center; border-radius:10px; font-size:13px; }
#sidebar-toggle { display:none; }
.sidebar-overlay { display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.5); z-index:998; cursor:pointer; }
@media(max-width:768px){
.sidebar{ transform:translateX(-100%); width:280px; }
.main{ margin-left:0; }
.navbar .hamburger{ display:block; }
.navbar{ padding:0 15px; height:60px; flex-wrap:wrap; }
.content{ padding:15px; }
.card{ padding:20px; }
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
    <a href="ConstructionServlet">🏗️ Construction</a>
    <a href="PossessionServlet">🔑 Possession</a>
    <a href="ReportServlet">📊 Reports</a>
    <a class="active" href="Setting.jsp">⚙ Settings</a>
    <a href="LogoutServlet">🚪 Logout</a>
</div>
<label for="sidebar-toggle" class="sidebar-overlay"></label>
<div class="main">
<div class="navbar">
<div style="display:flex;align-items:center;gap:15px;">
<label for="sidebar-toggle" class="hamburger">☰</label>
<h2 style="margin:0;font-size:20px;color:#273340;">⚙ Settings</h2>
</div>
<div>Welcome, <b><%= username %></b></div>
</div>
<div class="content">
<div class="card">
<h3>👤 Profile Information</h3>
<div style="display:flex;align-items:center;gap:20px;margin-bottom:20px;">
<img src="<%= profilePic %>" class="profile-pic" alt="Profile">
<div>
<p><b>Username:</b> <%= username %></p>
<p><b>Email:</b> <%= email %></p>
<p><b>Role:</b> <%= role %></p>
</div>
</div>
</div>
<div class="card">
<h3>🔑 Change Password</h3>
<form action="ChangePasswordServlet" method="post">
<div class="form-group"><label>Current Password</label><input type="password" name="oldPassword" required></div>
<div class="form-group"><label>New Password</label><input type="password" name="newPassword" minlength="6" required></div>
<div class="form-group"><label>Confirm New Password</label><input type="password" name="confirmPassword" minlength="6" required></div>
<button type="submit" class="btn btn-secondary">🔑 Change Password</button>
</form>
</div>
<div class="footer"><p>© 2026 Post-Sales & Handover OS</p></div>
</div>
</div>
</body>
</html>