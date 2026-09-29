<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
if (session.getAttribute("username") == null) { response.sendRedirect("Loginindex.jsp"); return; }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Raise Snag</title>
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
.main { margin-left:250px; min-height:100vh; display:flex; flex-direction:column; }
.navbar { height:70px; background:white; display:flex; justify-content:space-between; align-items:center; padding:0 30px; box-shadow:0 2px 10px rgba(0,0,0,0.08); position:sticky; top:0; z-index:999; }
.navbar .hamburger { display:none; cursor:pointer; font-size:28px; color:#273340; }
.content { padding:30px; flex:1; display:flex; flex-direction:column; align-items:center; }
.container { width:100%; max-width:700px; background:#fff; padding:35px; border-radius:15px; box-shadow:0 8px 20px rgba(0,0,0,0.12); }
h2 { text-align:center; margin-bottom:25px; color:#2c3e50; }
.form-group { margin-bottom:18px; }
label { display:block; margin-bottom:8px; font-weight:600; color:#555; }
input, select, textarea { width:100%; padding:12px; border:1px solid #ddd; border-radius:8px; font-size:15px; outline:none; font-family:'Poppins',sans-serif; }
input:focus, select:focus, textarea:focus { border-color:#E3123D; }
.buttons { margin-top:25px; display:flex; justify-content:space-between; gap:15px; flex-wrap:wrap; }
.btn-save { background:#28a745; color:white; border:none; padding:12px 25px; border-radius:8px; cursor:pointer; font-size:15px; }
.btn-save:hover { background:#218838; }
.btn-cancel { background:#dc3545; color:white; padding:12px 25px; border-radius:8px; text-decoration:none; }
.btn-cancel:hover { background:#c82333; }
.footer { margin-top:30px; padding:15px 20px; background:#36454F; color:white; text-align:center; border-radius:10px; font-size:14px; width:100%; max-width:700px; }
#sidebar-toggle { display:none; }
.sidebar-overlay { display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.5); z-index:998; cursor:pointer; }
@media(max-width:768px){
.sidebar { transform:translateX(-100%); width:280px; }
.main { margin-left:0; }
.navbar .hamburger { display:block; }
.navbar { padding:0 15px; height:60px; flex-wrap:wrap; }
.content { padding:15px; }
.container { padding:20px; }
.buttons { flex-direction:column; }
.buttons .btn-save, .buttons .btn-cancel { width:100%; text-align:center; }
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
    <a href="AllotteeManagementServlet">👥 Allottees</a>
    <a href="BookingManagementServlet">📅 Bookings</a>
    <a href="PaymentManagementServlet">💳 Payments</a>
    <a href="DocumentServlet">📄 Documents</a>
    <a href="TicketServlet">🎫 Tickets</a>
    <a class="active" href="SnagServlet">🔧 Snags</a>
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
<h2 style="margin:0;font-size:20px;color:#273340;">Raise Snag</h2>
</div>
<div>Welcome, <b><%= session.getAttribute("username") %></b></div>
</div>
<div class="content">
<div class="container">
<h2>🔧 Raise New Snag</h2>
<form action="SnagServlet" method="post" enctype="multipart/form-data">
<div class="form-group"><label>Booking ID</label><input type="number" name="bookingId" placeholder="Enter Booking ID" required></div>
<div class="form-group"><label>Location</label><input type="text" name="location" placeholder="e.g., Tower B, 12th Floor, Flat 1204, Bedroom" required></div>
<div class="form-group"><label>Description</label><textarea name="description" rows="4" placeholder="Describe the issue"></textarea></div>
<div class="form-group"><label>Priority</label>
<select name="priority">
<option>High</option><option selected>Medium</option><option>Low</option>
</select>
</div>
<div class="form-group"><label>Assigned To</label><input type="text" name="assignedTo" placeholder="Enter team/person name"></div>
<div class="form-group"><label>Photo/Video</label><input type="file" name="photo" accept=".jpg,.jpeg,.png,.mp4,.mov"></div>
<div class="buttons">
<button class="btn-save" type="submit">📤 Raise Snag</button>
<a href="SnagServlet" class="btn-cancel">Cancel</a>
</div>
</form>
</div>
<div class="footer"><p>© 2026 Post-Sales & Handover OS</p></div>
</div>
</div>
</body>
</html>