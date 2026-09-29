<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
if (session.getAttribute("allotteeId") == null) { response.sendRedirect("Loginindex.jsp"); return; }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Possession Status</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<style>
* { margin:0; padding:0; box-sizing:border-box; font-family:'Poppins',sans-serif; }
body { background:#eef2f7; color:#273340; }
.navbar { display:flex; justify-content:space-between; align-items:center; padding:18px 40px; background:#273340; color:white; flex-wrap:wrap; gap:10px; }
.navbar .logo { font-size:20px; font-weight:700; color:#E3123D; }
.navbar .logo span { color:white; }
.navbar a { color:#E3123D; text-decoration:none; font-weight:600; margin-left:15px; }
.content { padding:30px 40px; max-width:900px; margin:0 auto; }
h1 { margin-bottom:20px; }
.card { background:white; padding:25px; border-radius:12px; box-shadow:0 5px 15px rgba(0,0,0,.08); margin-bottom:20px; }
.card h3 { font-size:18px; margin-bottom:15px; color:#273340; }
table { width:100%; border-collapse:collapse; }
td, th { padding:10px; text-align:left; border-bottom:1px solid #eee; font-size:14px; }
th { color:#777; font-weight:600; width:40%; }
.checklist { list-style:none; }
.checklist li { padding:10px 0; font-size:14px; display:flex; align-items:center; gap:10px; }
.pass { color:#28a745; font-weight:bold; }
.pending { color:#f39c12; font-weight:bold; }
</style>
</head>
<body>
<div class="navbar">
    <div class="logo">🏢 <span>Post-Sales OS</span></div>
    <div>
        <a href="CustomerDashboardServlet">← Dashboard</a>
        <a href="CustomerLogoutServlet">Logout</a>
    </div>
</div>
<div class="content">
    <h1>🔑 Possession Status</h1>

    <div class="card">
        <h3>Unit Details</h3>
        <table>
            <tr><th>Unit Number</th><td><%= request.getAttribute("unitNo") %></td></tr>
            <tr><th>Booking Status</th><td><%= request.getAttribute("bookingStatus") %></td></tr>
            <tr><th>Flat Status</th><td><%= request.getAttribute("flatStatus") %></td></tr>
            <tr><th>Expected Possession</th><td><%= request.getAttribute("possessionDate") %></td></tr>
            <tr><th>RERA Number</th><td><%= request.getAttribute("reraNo") %></td></tr>
        </table>
    </div>

    <div class="card">
        <h3>Pre-Possession Checklist</h3>
        <ul class="checklist">
            <li><span class="<%= "Verified".equals(request.getAttribute("kycStatus")) ? "pass" : "pending" %>">
                <%= "Verified".equals(request.getAttribute("kycStatus")) ? "✓" : "○" %></span> KYC Verification</li>
            <li><span class="<%= "Confirmed".equals(request.getAttribute("bookingStatus")) || "Possession Given".equals(request.getAttribute("bookingStatus")) ? "pass" : "pending" %>">
                <%= "Confirmed".equals(request.getAttribute("bookingStatus")) || "Possession Given".equals(request.getAttribute("bookingStatus")) ? "✓" : "○" %></span> Booking Confirmed</li>
            <li><span class="<%= "Possession Given".equals(request.getAttribute("flatStatus")) ? "pass" : "pending" %>">
                <%= "Possession Given".equals(request.getAttribute("flatStatus")) ? "✓" : "○" %></span> Possession Handover</li>
            <li><span class="<%= (request.getAttribute("totalSnags") != null && request.getAttribute("verifiedSnags") != null && request.getAttribute("totalSnags").equals(request.getAttribute("verifiedSnags"))) ? "pass" : "pending" %>">
                <%= (request.getAttribute("totalSnags") != null && request.getAttribute("verifiedSnags") != null && request.getAttribute("totalSnags").equals(request.getAttribute("verifiedSnags"))) ? "✓" : "○" %></span> All Snags Verified</li>
        </ul>
    </div>
</div>
</body>
</html>