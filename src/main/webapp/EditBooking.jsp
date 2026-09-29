<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.org.Booking, com.org.Allottee, com.org.Flat, java.util.*" %>
<%
if (session.getAttribute("username") == null) { response.sendRedirect("Loginindex.jsp"); return; }
Booking booking = (Booking) request.getAttribute("booking");
List<Allottee> allottees = (List<Allottee>) request.getAttribute("allottees");
List<Flat> flats = (List<Flat>) request.getAttribute("flats");
if (booking == null) { response.sendRedirect("BookingManagementServlet"); return; }
if (allottees == null) allottees = new ArrayList<>();
if (flats == null) flats = new ArrayList<>();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Edit Booking</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">
<style>
* { margin:0; padding:0; box-sizing:border-box; font-family:'Poppins',sans-serif; }
body { background:#eef2f7; display:flex; justify-content:center; align-items:center; min-height:100vh; padding:20px; }
.container { width:100%; max-width:700px; background:white; padding:35px; border-radius:12px; box-shadow:0 5px 15px rgba(0,0,0,.1); }
h2 { text-align:center; color:#2c3e50; margin-bottom:30px; }
.form-group { margin-bottom:18px; }
label { display:block; margin-bottom:8px; font-weight:600; color:#444; }
input, select { width:100%; padding:12px; border:1px solid #ccc; border-radius:8px; outline:none; font-size:15px; }
input:focus, select:focus { border-color:#E3123D; }
.buttons { display:flex; justify-content:space-between; margin-top:25px; gap:15px; flex-wrap:wrap; }
.update { background:#17a2b8; color:white; border:none; padding:12px 25px; border-radius:8px; cursor:pointer; font-size:15px; }
.update:hover { background:#138496; }
.cancel { background:#dc3545; color:white; padding:12px 25px; border-radius:8px; text-decoration:none; }
.cancel:hover { background:#c82333; }
@media(max-width:480px){ .container{ padding:20px; } .buttons{ flex-direction:column; } .buttons .update, .buttons .cancel{ width:100%; text-align:center; } }
</style>
</head>
<body>
<div class="container">
<h2>✏️ Edit Booking</h2>
<form action="UpdateBookingServlet" method="post">
<input type="hidden" name="bookingId" value="<%= booking.getBookingId() %>">
<div class="form-group"><label>Allottee</label><select name="allotteeId" required>
<% for (Allottee a : allottees) { String sel = (a.getAllotteeId() == booking.getAllotteeId()) ? "selected" : ""; %>
<option value="<%= a.getAllotteeId() %>" <%= sel %>><%= a.getName() %></option><% } %></select></div>
<div class="form-group"><label>Flat</label><select name="flatId" required>
<% for (Flat f : flats) { String sel = (f.getFlatId() == booking.getFlatId()) ? "selected" : ""; %>
<option value="<%= f.getFlatId() %>" <%= sel %>><%= f.getUnitNo() %> (<%= f.getFlatType() %>) - <%= f.getStatus() %></option><% } %></select></div>
<div class="form-group"><label>Booking Date</label><input type="date" name="bookingDate" value="<%= booking.getBookingDate() %>" required></div>
<div class="form-group"><label>Possession Date</label><input type="date" name="possessionDate" value="<%= booking.getPossessionDate() %>" required></div>
<div class="form-group"><label>Total Amount (₹)</label><input type="number" step="0.01" name="totalAmount" value="<%= booking.getTotalAmount() %>" required></div>
<div class="form-group"><label>Status</label><select name="status">
<option value="Confirmed" <%= "Confirmed".equals(booking.getStatus()) ? "selected" : "" %>>Confirmed</option>
<option value="Pending" <%= "Pending".equals(booking.getStatus()) ? "selected" : "" %>>Pending</option>
<option value="Cancelled" <%= "Cancelled".equals(booking.getStatus()) ? "selected" : "" %>>Cancelled</option>
<option value="Possession Given" <%= "Possession Given".equals(booking.getStatus()) ? "selected" : "" %>>Possession Given</option>
<option value="Handover Done" <%= "Handover Done".equals(booking.getStatus()) ? "selected" : "" %>>Handover Done</option>
</select></div>
<div class="buttons"><button class="update" type="submit">💾 Update Booking</button><a href="BookingManagementServlet" class="cancel">Cancel</a></div>
</form>
</div>
</body>
</html>