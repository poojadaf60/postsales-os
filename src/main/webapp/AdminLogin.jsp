<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin Login - Post-Sales OS</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<style>
* { margin:0; padding:0; box-sizing:border-box; font-family:'Poppins',sans-serif; }
body { min-height:100vh; display:flex; justify-content:center; align-items:center; background:#eef2f7; padding:20px; }
.container { width:100%; max-width:420px; }
.login-box { background:#fff; padding:35px; border-radius:15px; box-shadow:0 10px 25px rgba(0,0,0,.12); border-top:6px solid #E3123D; }
h1 { text-align:center; font-size:26px; color:#273340; margin-bottom:8px; }
.subtitle { text-align:center; font-size:14px; color:#666; margin-bottom:20px; }
.success { background:#d4edda; color:#155724; padding:10px; border-radius:6px; text-align:center; margin-bottom:15px; }
.error { background:#f8d7da; color:#721c24; padding:10px; border-radius:6px; text-align:center; margin-bottom:15px; }
label { display:block; margin-top:15px; margin-bottom:6px; font-weight:600; color:#273340; }
input { width:100%; padding:13px; border:1px solid #ccc; border-radius:8px; outline:none; font-size:14px; transition:.3s; }
input:focus { border-color:#E3123D; box-shadow:0 0 8px rgba(227,18,61,.25); }
button { width:100%; margin-top:25px; padding:14px; background:#E3123D; color:white; border:none; border-radius:8px; font-size:16px; font-weight:600; cursor:pointer; transition:.3s; }
button:hover { background:#c50f35; }
.footer { text-align:center; margin-top:20px; color:#666; font-size:13px; }
.footer a { color:#E3123D; text-decoration:none; font-weight:600; }
</style>
</head>
<body>
<div class="container">
    <div class="login-box">
        <h1>🏢 Admin Login</h1>
        <p class="subtitle">Post-Sales OS — Builder Access</p>

        <% String msg = request.getParameter("msg");
           if("registered".equals(msg)){ %><div class="success">✅ Registration Successful. Please Login.</div><% }
           if("invalid".equals(msg)){ %><div class="error">❌ Invalid Email or Password.</div><% }
           if("logout".equals(msg)){ %><div class="success">✅ Logged Out Successfully.</div><% }
           if("error".equals(msg)){ %><div class="error">❌ Something went wrong.</div><% }
        %>

        <form action="LoginServlet" method="post">
            <label>Email Address</label>
            <input type="email" name="email" placeholder="Enter your Email" required>
            <label>Password</label>
            <input type="password" name="password" placeholder="Enter your Password" required>
            <button type="submit">Login</button>
        </form>

        <div class="footer">
            Don't have an account? <a href="Registrationindex.jsp">Register Now</a>
            <br><br>
            <a href="index.jsp">← Back to Home</a>
        </div>
    </div>
</div>
</body>
</html>