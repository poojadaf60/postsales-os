<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
if(session.getAttribute("username")==null){ response.sendRedirect("Loginindex.jsp"); return; }
String profilePic = (String) session.getAttribute("profilePic");
String username = (String) session.getAttribute("username");
if (profilePic == null || profilePic.isEmpty()) {
    profilePic = "https://ui-avatars.com/api/?name=" + username + "&background=E3123D&color=fff&size=100";
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Post-Sales OS | Dashboard</title>
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
.content h1 { color:#273340; margin-bottom:10px; font-size:26px; }
.content p { color:#777; }
.cards { display:grid; grid-template-columns:repeat(auto-fit,minmax(200px,1fr)); gap:20px; margin-top:30px; }
.card { background:#fff; padding:22px; border-radius:12px; box-shadow:0 5px 15px rgba(0,0,0,.08); display:flex; justify-content:space-between; align-items:center; transition:.3s; }
.card:hover { transform:translateY(-5px); }
.card h2 { font-size:28px; color:#273340; }
.card p { margin-top:6px; color:#777; font-size:13px; }
.card .icon { font-size:40px; }
.blue { border-left:6px solid #3498db; }
.green { border-left:6px solid #2ecc71; }
.red { border-left:6px solid #e74c3c; }
.orange { border-left:6px solid #f39c12; }
.purple { border-left:6px solid #9b59b6; }
.teal { border-left:6px solid #1abc9c; }
.dark { border-left:6px solid #34495e; }
.footer { margin-top:40px; padding:18px; background:#36454F; color:white; text-align:center; border-radius:10px; font-size:13px; }
#sidebar-toggle { display:none; }
.sidebar-overlay { display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.5); z-index:998; cursor:pointer; }
@media(max-width:768px){
.sidebar{ transform:translateX(-100%); width:280px; }
.main{ margin-left:0; }
.navbar .hamburger{ display:block; }
.navbar{ padding:0 15px; height:60px; flex-wrap:wrap; }
.content{ padding:15px; }
.cards{ grid-template-columns:1fr; }
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
    <a class="active" href="DashboardServlet">🏠 Dashboard</a>
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
    <a href="Setting.jsp">⚙ Settings</a>
    <a href="LogoutServlet">🚪 Logout</a>
</div>
<label for="sidebar-toggle" class="sidebar-overlay"></label>
<div class="main">
<div class="navbar">
<div style="display:flex;align-items:center;gap:15px;">
<label for="sidebar-toggle" class="hamburger">☰</label>
<h2 style="margin:0;font-size:20px;color:#273340;">Dashboard</h2>
</div>
<div style="display:flex;align-items:center;gap:15px;">
<div class="icon">🔔</div>
<div class="profile" style="display:flex;align-items:center;gap:10px;">
    <img src="<%= profilePic %>" alt="Profile" style="width:42px;height:42px;border-radius:50%;object-fit:cover;border:2px solid #E3123D;">
    <div>
        <h4 style="color:#273340;font-size:14px;"><%= username %></h4>
        <p style="font-size:11px;color:gray;"><%= session.getAttribute("role") %></p>
    </div>
</div>
</div>
</div>
<div class="content">
<h1>Welcome <%= username %> 👋</h1>
<p>Manage your Post-Sales & Handover operations from one dashboard.</p>
<div class="cards">
<div class="card blue"><div><h2>${totalFlats}</h2><p>Total Flats</p></div><div class="icon">🏢</div></div>
<div class="card green"><div><h2>${availableFlats}</h2><p>Available</p></div><div class="icon">✅</div></div>
<div class="card red"><div><h2>${bookedFlats}</h2><p>Booked</p></div><div class="icon">📅</div></div>
<div class="card orange"><div><h2>${possessionFlats}</h2><p>Possession Given</p></div><div class="icon">🔑</div></div>
<div class="card purple"><div><h2>${totalAllottees}</h2><p>Total Allottees</p></div><div class="icon">👥</div></div>
<div class="card teal"><div><h2>${totalBookings}</h2><p>Total Bookings</p></div><div class="icon">📋</div></div>
<div class="card blue"><div><h2>${totalDocuments}</h2><p>Documents</p></div><div class="icon">📄</div></div>
<div class="card red"><div><h2>${openTickets}</h2><p>Open Tickets</p></div><div class="icon">🎫</div></div>
<div class="card orange"><div><h2>${openSnags}</h2><p>Open Snags</p></div><div class="icon">🔧</div></div>
<div class="card dark"><div><h2>₹ ${totalRevenue}</h2><p>Total Collection</p></div><div class="icon">💰</div></div>
</div>
<br><br>
<h2 style="color:#36454F;">Quick Actions</h2>
<div class="cards">
<div class="card blue"><div><h3>Add Flat</h3><p>Create New Unit</p><br><a href="AddFlat.jsp" style="text-decoration:none;background:#3498db;color:white;padding:8px 18px;border-radius:5px;display:inline-block;font-size:13px;">Open</a></div><div class="icon">🏢</div></div>
<div class="card green"><div><h3>New Booking</h3><p>Create Booking</p><br><a href="BookingServlet" style="text-decoration:none;background:#2ecc71;color:white;padding:8px 18px;border-radius:5px;display:inline-block;font-size:13px;">Open</a></div><div class="icon">📅</div></div>
<div class="card purple"><div><h3>Upload Doc</h3><p>Add Document</p><br><a href="UploadDocument.jsp" style="text-decoration:none;background:#9b59b6;color:white;padding:8px 18px;border-radius:5px;display:inline-block;font-size:13px;">Open</a></div><div class="icon">📄</div></div>
</div>
<br><br>
<div class="footer"><p>© 2026 Post-Sales & Handover OS</p></div>
</div>
</div>
</body>
</html>