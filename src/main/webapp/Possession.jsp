<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
if (session.getAttribute("username") == null) { response.sendRedirect("Loginindex.jsp"); return; }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Possession</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">
<style>
* { margin:0; padding:0; box-sizing:border-box; font-family:'Poppins',sans-serif; }
body { background:#eef2f7; display:flex; justify-content:center; align-items:center; min-height:100vh; padding:20px; }
.container { max-width:500px; width:100%; background:white; padding:40px; border-radius:15px; box-shadow:0 10px 30px rgba(0,0,0,0.12); border-top:8px solid #2ecc71; text-align:center; }
.icon { font-size:60px; color:#2ecc71; margin-bottom:15px; }
h2 { color:#273340; margin-bottom:15px; }
.form-group { margin-bottom:20px; text-align:left; }
label { display:block; margin-bottom:8px; font-weight:600; color:#444; }
input { width:100%; padding:14px; border:1px solid #ddd; border-radius:8px; font-size:16px; outline:none; }
input:focus { border-color:#2ecc71; box-shadow:0 0 8px rgba(46,204,113,0.2); }
.btn { width:100%; padding:14px; background:#2ecc71; color:white; border:none; border-radius:8px; font-size:17px; font-weight:600; cursor:pointer; transition:0.3s; }
.btn:hover { background:#27ae60; }
.error { background:#f8d7da; color:#721c24; padding:12px; border-radius:8px; margin-bottom:20px; border-left:6px solid #dc3545; }
.back { display:inline-block; margin-top:15px; color:#17a2b8; text-decoration:none; }
</style>
</head>
<body>
<div class="container">
<div class="icon">🔑</div>
<h2>Possession Handover</h2>
<p style="color:#555;margin-bottom:25px;">Enter Booking ID to give possession to allottee.</p>
<%
String error = (String) request.getAttribute("error");
if (error != null) { %><div class="error">⚠️ <%= error %></div><% }
%>
<form action="PossessionServlet" method="post">
<div class="form-group">
<label>Booking ID</label>
<input type="number" name="bookingId" placeholder="e.g., 101" required>
</div>
<button class="btn" type="submit">🔑 Give Possession</button>
</form>
<a href="DashboardServlet" class="back">← Back to Dashboard</a>
</div>
</body>
</html>