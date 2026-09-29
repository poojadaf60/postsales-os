<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
if (session.getAttribute("username") == null) { response.sendRedirect("Loginindex.jsp"); return; }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Possession Successful</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">
<style>
* { margin:0; padding:0; box-sizing:border-box; font-family:'Poppins',sans-serif; }
body { background:#eef2f7; display:flex; justify-content:center; align-items:center; min-height:100vh; padding:20px; }
.container { background:white; padding:50px; border-radius:20px; box-shadow:0 10px 30px rgba(0,0,0,0.12); text-align:center; max-width:500px; border-top:8px solid #2ecc71; }
.icon { font-size:72px; color:#2ecc71; margin-bottom:20px; }
h2 { color:#273340; margin-bottom:15px; }
.details { text-align:left; margin:25px 0; padding:20px; background:#f8f9fa; border-radius:12px; }
.details p { margin:8px 0; }
.btn { display:inline-block; padding:12px 25px; background:#2ecc71; color:white; text-decoration:none; border-radius:8px; font-weight:600; transition:0.3s; }
.btn:hover { background:#27ae60; }
.btn-secondary { background:#17a2b8; margin-left:10px; }
.btn-secondary:hover { background:#138496; }
</style>
</head>
<body>
<div class="container">
<div class="icon">✅</div>
<h2>Possession Given Successfully!</h2>
<p style="color:#555;">Flat has been handed over to the allottee.</p>
<div class="details">
<p><b>Booking ID:</b> <%= request.getAttribute("bookingId") %></p>
<p><b>Allottee ID:</b> <%= request.getAttribute("allotteeId") %></p>
<p><b>Flat ID:</b> <%= request.getAttribute("flatId") %></p>
<p><b>Possession Date:</b> <%= request.getAttribute("possessionDate") %></p>
</div>
<div>
<a href="DashboardServlet" class="btn">🏠 Dashboard</a>
<a href="PossessionServlet" class="btn btn-secondary">🔑 Another Possession</a>
</div>
</div>
</body>
</html>