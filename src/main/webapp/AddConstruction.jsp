<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
if (session.getAttribute("username") == null) { response.sendRedirect("Loginindex.jsp"); return; }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Add Construction Update</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">
<style>
* { margin:0; padding:0; box-sizing:border-box; font-family:'Poppins',sans-serif; }
body { background:#eef2f7; display:flex; justify-content:center; align-items:center; min-height:100vh; padding:20px; }
.container { width:100%; max-width:700px; background:#fff; padding:35px; border-radius:15px; box-shadow:0 8px 20px rgba(0,0,0,0.12); }
h2 { text-align:center; margin-bottom:25px; color:#2c3e50; }
.form-group { margin-bottom:18px; }
label { display:block; margin-bottom:8px; font-weight:600; color:#555; }
input, textarea { width:100%; padding:12px; border:1px solid #ddd; border-radius:8px; font-size:15px; outline:none; font-family:'Poppins',sans-serif; }
input:focus, textarea:focus { border-color:#E3123D; }
.buttons { margin-top:25px; display:flex; justify-content:space-between; gap:15px; }
.btn-save { background:#28a745; color:white; border:none; padding:12px 25px; border-radius:8px; cursor:pointer; font-size:15px; }
.btn-cancel { background:#dc3545; color:white; padding:12px 25px; border-radius:8px; text-decoration:none; }
@media(max-width:480px){ .container{ padding:20px; } .buttons{ flex-direction:column; } .buttons .btn-save, .buttons .btn-cancel{ width:100%; text-align:center; } }
</style>
</head>
<body>
<div class="container">
<h2>🏗️ Add Construction Update</h2>
<form action="ConstructionServlet" method="post" enctype="multipart/form-data">
<div class="form-group"><label>Flat ID</label><input type="number" name="flatId" placeholder="Enter Flat ID" required></div>
<div class="form-group"><label>Milestone</label><input type="text" name="milestone" placeholder="e.g., Slab Completed" required></div>
<div class="form-group"><label>Description</label><textarea name="description" rows="4" placeholder="Describe the update"></textarea></div>
<div class="form-group"><label>Photo/Video</label><input type="file" name="photo" accept=".jpg,.jpeg,.png,.mp4,.mov"></div>
<div class="buttons">
<button class="btn-save" type="submit">📤 Add Update</button>
<a href="ConstructionServlet" class="btn-cancel">Cancel</a>
</div>
</form>
</div>
</body>
</html>