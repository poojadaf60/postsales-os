<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList, com.org.Payment"%>
<%
if (session.getAttribute("allotteeId") == null) { response.sendRedirect("Loginindex.jsp"); return; }
ArrayList<Payment> payments = (ArrayList<Payment>) request.getAttribute("payments");
if (payments == null) payments = new ArrayList<>();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>My Payments</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<style>
* { margin:0; padding:0; box-sizing:border-box; font-family:'Poppins',sans-serif; }
body { background:#eef2f7; color:#273340; }
.navbar { display:flex; justify-content:space-between; align-items:center; padding:18px 40px; background:#273340; color:white; flex-wrap:wrap; gap:10px; }
.navbar .logo { font-size:20px; font-weight:700; color:#E3123D; }
.navbar .logo span { color:white; }
.navbar a { color:#E3123D; text-decoration:none; font-weight:600; margin-left:15px; }
.content { padding:30px 40px; max-width:1200px; margin:0 auto; }
h1 { margin-bottom:20px; }
.cards { display:grid; grid-template-columns:repeat(auto-fit,minmax(180px,1fr)); gap:20px; margin-bottom:25px; }
.card { background:white; padding:22px; border-radius:12px; box-shadow:0 5px 15px rgba(0,0,0,.08); border-left:6px solid #E3123D; }
.card h3 { font-size:20px; }
.card p { color:#777; font-size:13px; margin-top:4px; }
table { width:100%; background:white; border-collapse:collapse; border-radius:12px; overflow:hidden; box-shadow:0 5px 15px rgba(0,0,0,.08); }
th { background:#34495e; color:white; padding:14px; text-align:left; }
td { padding:14px; border-bottom:1px solid #eee; }
tr:hover { background:#f8f9fb; }
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
    <h1>💳 My Payments</h1>

    <div class="cards">
        <div class="card"><h3>₹ <%= String.format("%,.0f", (Double) request.getAttribute("totalAmount")) %></h3><p>Total Consideration</p></div>
        <div class="card"><h3>₹ <%= String.format("%,.0f", (Double) request.getAttribute("totalPaid")) %></h3><p>Paid</p></div>
        <div class="card"><h3>₹ <%= String.format("%,.0f", (Double) request.getAttribute("outstanding")) %></h3><p>Outstanding</p></div>
    </div>

    <table>
        <thead><tr><th>Payment ID</th><th>Amount</th><th>Method</th><th>Date</th><th>TDS</th><th>GST</th><th>Status</th></tr></thead>
        <tbody>
        <% if (payments.isEmpty()) { %>
            <tr><td colspan="7" style="text-align:center;padding:30px;color:#999;">No payments yet.</td></tr>
        <% } else {
            for (Payment p : payments) { %>
            <tr>
                <td><%= p.getPaymentId() %></td>
                <td>₹ <%= String.format("%,.2f", p.getAmount()) %></td>
                <td><%= p.getPaymentMethod() %></td>
                <td><%= p.getPaymentDate() %></td>
                <td>₹ <%= p.getTds() %></td>
                <td>₹ <%= p.getGst() %></td>
                <td><%= p.getStatus() %></td>
            </tr>
        <% } } %>
        </tbody>
    </table>
</div>
</body>
</html>