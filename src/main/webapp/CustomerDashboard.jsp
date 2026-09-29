<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
if (session.getAttribute("allotteeId") == null
    || !"Customer".equalsIgnoreCase((String) session.getAttribute("role"))) {
    response.sendRedirect("Loginindex.jsp"); return;
}
String customerName = (String) session.getAttribute("username");
Integer bookingId = (Integer) request.getAttribute("bookingId");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>My Property | Post-Sales OS</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<style>
* { margin:0; padding:0; box-sizing:border-box; font-family:'Poppins',sans-serif; }
body { background:#eef2f7; color:#273340; }
.navbar { display:flex; justify-content:space-between; align-items:center; padding:18px 40px; background:#273340; color:white; position:sticky; top:0; z-index:1000; flex-wrap:wrap; gap:10px; }
.navbar .logo { font-size:20px; font-weight:700; color:#E3123D; }
.navbar .logo span { color:white; }
.navbar .user-info { display:flex; align-items:center; gap:15px; flex-wrap:wrap; }
.navbar .user-info a { color:#E3123D; text-decoration:none; font-weight:600; }
.content { padding:30px 40px; max-width:1200px; margin:0 auto; }
h1 { font-size:26px; margin-bottom:6px; }
.subtitle { color:#777; margin-bottom:25px; }
.cards { display:grid; grid-template-columns:repeat(auto-fit,minmax(180px,1fr)); gap:20px; margin-bottom:30px; }
.card { background:white; padding:22px; border-radius:12px; box-shadow:0 5px 15px rgba(0,0,0,.08); border-left:6px solid #E3123D; }
.card h3 { font-size:22px; }
.card p { color:#777; font-size:13px; margin-top:4px; }
.tabs { display:flex; gap:8px; border-bottom:2px solid #dde3ea; margin-bottom:20px; overflow-x:auto; }
.tab { padding:12px 22px; cursor:pointer; font-weight:600; color:#777; white-space:nowrap; border-bottom:3px solid transparent; }
.tab.active { color:#E3123D; border-bottom-color:#E3123D; }
.tab-content { display:none; background:white; padding:25px; border-radius:12px; box-shadow:0 5px 15px rgba(0,0,0,.08); }
.tab-content.active { display:block; }
.tab-content h2 { font-size:18px; margin-bottom:15px; color:#273340; }
table { width:100%; border-collapse:collapse; }
td, th { padding:10px; text-align:left; border-bottom:1px solid #eee; font-size:14px; }
th { color:#777; font-weight:600; width:40%; }
.btn-link { display:inline-block; margin-top:15px; padding:10px 22px; background:#E3123D; color:white; text-decoration:none; border-radius:8px; font-weight:600; font-size:14px; }
</style>
</head>
<body>

<div class="navbar">
    <div class="logo">🏢 <span>Post-Sales OS</span></div>
    <div class="user-info">
        <span>Welcome, <b><%= customerName %></b></span>
        <a href="CustomerLogoutServlet">Logout</a>
    </div>
</div>

<div class="content">
    <h1>My Property 🏠</h1>
    <p class="subtitle">Everything about your unit in one place.</p>

    <% if (bookingId == null || bookingId == 0) { %>
        <div class="card" style="border-left-color:#f39c12;">
            <p>⚠️ Abhi tak aapki koi booking registered nahi hai. Kripya builder se sampark karein.</p>
        </div>
    <% } else { %>

    <div class="cards">
        <div class="card"><h3><%= request.getAttribute("unitNo") %></h3><p><%= request.getAttribute("flatType") %></p></div>
        <div class="card"><h3>₹ <%= String.format("%,.0f", (Double) request.getAttribute("paidAmount")) %></h3><p>Total Paid</p></div>
        <div class="card"><h3><%= request.getAttribute("docCount") %></h3><p>Documents</p></div>
        <div class="card"><h3><%= request.getAttribute("openTickets") %></h3><p>Open Tickets</p></div>
        <div class="card"><h3><%= request.getAttribute("openSnags") %></h3><p>Open Snags</p></div>
    </div>

    <div class="tabs">
        <div class="tab active" onclick="showTab('property', this)">Property</div>
        <div class="tab" onclick="showTab('documents', this)">Documents</div>
        <div class="tab" onclick="showTab('payments', this)">Payments</div>
        <div class="tab" onclick="showTab('construction', this)">Construction</div>
        <div class="tab" onclick="showTab('possession', this)">Possession</div>
    </div>

    <div id="property" class="tab-content active">
        <h2>Flat Details</h2>
        <table>
            <tr><th>Unit Number</th><td><%= request.getAttribute("unitNo") %></td></tr>
            <tr><th>Flat Type</th><td><%= request.getAttribute("flatType") %></td></tr>
            <tr><th>Tower</th><td><%= request.getAttribute("tower") %></td></tr>
            <tr><th>Floor</th><td><%= request.getAttribute("floor") %></td></tr>
            <tr><th>Agreement Value</th><td>₹ <%= String.format("%,.0f", (Double) request.getAttribute("agreementValue")) %></td></tr>
            <tr><th>RERA Number</th><td><%= request.getAttribute("reraNo") %></td></tr>
            <tr><th>Booking Date</th><td><%= request.getAttribute("bookingDate") %></td></tr>
            <tr><th>Expected Possession</th><td><%= request.getAttribute("possessionDate") %></td></tr>
            <tr><th>Flat Status</th><td><%= request.getAttribute("flatStatus") %></td></tr>
            <tr><th>Booking Status</th><td><%= request.getAttribute("bookingStatus") %></td></tr>
            <tr><th>KYC Status</th><td><%= request.getAttribute("kycStatus") %></td></tr>
        </table>
    </div>

    <div id="documents" class="tab-content">
        <h2>My Documents</h2>
        <p style="color:#777;">Aapke saare documents (Agreement, Receipts, NOC, Possession letter) yahan dikhenge.</p>
        <a href="CustomerDocumentsServlet" class="btn-link">→ View All Documents</a>
    </div>

    <div id="payments" class="tab-content">
        <h2>My Payments</h2>
        <p style="color:#777;">Total Consideration, Paid, Outstanding, Next Due Date, Receipts.</p>
        <a href="CustomerPaymentsServlet" class="btn-link">→ View Payment Ledger</a>
    </div>

    <div id="construction" class="tab-content">
        <h2>Construction Updates</h2>
        <p style="color:#777;">Aapke tower aur floor ke latest construction milestones.</p>
        <a href="CustomerConstructionServlet" class="btn-link">→ View Timeline</a>
    </div>

    <div id="possession" class="tab-content">
        <h2>Possession Status</h2>
        <p style="color:#777;">Possession checklist, snags, aur handover status.</p>
        <a href="CustomerPossessionServlet" class="btn-link">→ View Possession</a>
    </div>

    <% } %>
</div>

<script>
function showTab(id, el) {
    document.querySelectorAll('.tab').forEach(t => t.classList.remove('active'));
    document.querySelectorAll('.tab-content').forEach(t => t.classList.remove('active'));
    document.getElementById(id).classList.add('active');
    el.classList.add('active');
}
</script>

</body>
</html>