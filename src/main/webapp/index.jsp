<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Post-Sales & Handover OS</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">
<style>
* { margin:0; padding:0; box-sizing:border-box; font-family:'Poppins',sans-serif; }
body { background:#eef2f7; color:#273340; }

/* NAVBAR */
.navbar {
    display:flex; justify-content:space-between; align-items:center;
    padding:18px 60px; background:white; position:sticky; top:0; z-index:1000;
    box-shadow:0 2px 10px rgba(0,0,0,0.08);
}
.navbar .logo { font-size:22px; font-weight:800; color:#E3123D; }
.navbar .logo span { color:#273340; }
.navbar .nav-links { display:flex; gap:25px; align-items:center; }
.navbar .nav-links a { text-decoration:none; color:#273340; font-weight:500; font-size:15px; transition:.3s; }
.navbar .nav-links a:hover { color:#E3123D; }
.navbar .btn-login {
    background:#E3123D; color:white; padding:10px 24px; border-radius:8px;
    text-decoration:none; font-weight:600; transition:.3s;
}
.navbar .btn-login:hover { background:#c20f33; color:white; }
.navbar .btn-register {
    background:transparent; color:#E3123D; padding:10px 24px; border-radius:8px;
    text-decoration:none; font-weight:600; border:2px solid #E3123D; transition:.3s;
}
.navbar .btn-register:hover { background:#E3123D; color:white; }

/* HERO */
.hero {
    padding:90px 60px; text-align:center;
    background:linear-gradient(135deg, #273340 0%, #36454F 100%);
    color:white; position:relative; overflow:hidden;
}
.hero::before {
    content:''; position:absolute; top:-50%; right:-10%;
    width:500px; height:500px; border-radius:50%;
    background:rgba(227,18,61,0.15);
}
.hero h1 { font-size:48px; font-weight:800; margin-bottom:20px; line-height:1.2; position:relative; }
.hero h1 span { color:#E3123D; }
.hero p { font-size:18px; color:#cbd5e0; max-width:800px; margin:0 auto 35px; line-height:1.7; position:relative; }
.hero-buttons { display:flex; gap:20px; justify-content:center; flex-wrap:wrap; position:relative; }
.btn-primary {
    background:#E3123D; color:white; padding:15px 40px; border-radius:10px;
    text-decoration:none; font-weight:600; font-size:16px; transition:.3s;
    display:inline-flex; align-items:center; gap:10px;
}
.btn-primary:hover { background:#c20f33; transform:translateY(-2px); }
.btn-secondary {
    background:transparent; color:white; padding:15px 40px; border-radius:10px;
    text-decoration:none; font-weight:600; font-size:16px; border:2px solid white; transition:.3s;
    display:inline-flex; align-items:center; gap:10px;
}
.btn-secondary:hover { background:white; color:#273340; }

/* FEATURES */
.section { padding:80px 60px; }
.section-title { text-align:center; margin-bottom:50px; }
.section-title h2 { font-size:36px; font-weight:800; color:#273340; margin-bottom:12px; }
.section-title p { color:#777; font-size:16px; }

.features-grid {
    display:grid; grid-template-columns:repeat(auto-fit,minmax(300px,1fr));
    gap:25px; max-width:1200px; margin:0 auto;
}
.feature-card {
    background:white; padding:35px; border-radius:15px;
    box-shadow:0 5px 20px rgba(0,0,0,0.06); transition:.3s;
    border-top:5px solid #E3123D;
}
.feature-card:hover { transform:translateY(-8px); box-shadow:0 15px 35px rgba(0,0,0,0.12); }
.feature-icon {
    width:60px; height:60px; border-radius:12px;
    background:linear-gradient(135deg, #E3123D, #ff4d6d);
    display:flex; align-items:center; justify-content:center;
    font-size:28px; color:white; margin-bottom:20px;
}
.feature-card h3 { font-size:20px; color:#273340; margin-bottom:12px; }
.feature-card p { color:#666; font-size:14px; line-height:1.7; }

/* LIFECYCLE */
.lifecycle-section { background:white; padding:80px 60px; }
.lifecycle {
    display:flex; justify-content:space-between; align-items:center;
    max-width:1100px; margin:0 auto; flex-wrap:wrap; gap:15px;
}
.lifecycle-step {
    text-align:center; flex:1; min-width:100px; position:relative;
}
.lifecycle-step .circle {
    width:60px; height:60px; border-radius:50%;
    background:#E3123D; color:white;
    display:flex; align-items:center; justify-content:center;
    margin:0 auto 10px; font-weight:700; font-size:18px;
}
.lifecycle-step p { font-size:13px; font-weight:600; color:#273340; }
.lifecycle-arrow { color:#E3123D; font-size:22px; }

/* CTA */
.cta-section {
    background:linear-gradient(135deg, #E3123D, #c20f33);
    padding:70px 60px; text-align:center; color:white;
}
.cta-section h2 { font-size:34px; margin-bottom:15px; }
.cta-section p { font-size:17px; margin-bottom:30px; opacity:0.95; }
.cta-section .btn-white {
    background:white; color:#E3123D; padding:15px 40px; border-radius:10px;
    text-decoration:none; font-weight:700; font-size:16px; display:inline-block;
}
.cta-section .btn-white:hover { background:#f0f0f0; }

/* FOOTER */
footer {
    background:#273340; color:#cbd5e0; padding:50px 60px 20px;
}
.footer-grid {
    display:grid; grid-template-columns:2fr 1fr 1fr 1fr; gap:40px;
    max-width:1200px; margin:0 auto 30px;
}
.footer-grid h4 { color:white; margin-bottom:18px; font-size:16px; }
.footer-grid p, .footer-grid a {
    color:#a0aec0; font-size:14px; line-height:1.9;
    text-decoration:none; display:block;
}
.footer-grid a:hover { color:#E3123D; }
.footer-bottom {
    text-align:center; padding-top:25px; border-top:1px solid rgba(255,255,255,0.1);
    color:#718096; font-size:13px;
}

/* RESPONSIVE */
@media(max-width:900px){
    .navbar { padding:15px 20px; }
    .navbar .nav-links a:not(.btn-login):not(.btn-register) { display:none; }
    .hero { padding:60px 20px; }
    .hero h1 { font-size:32px; }
    .hero p { font-size:16px; }
    .section, .lifecycle-section, .cta-section { padding:50px 20px; }
    .section-title h2 { font-size:26px; }
    .footer-grid { grid-template-columns:1fr 1fr; gap:25px; }
    .lifecycle { flex-direction:column; }
    .lifecycle-arrow { transform:rotate(90deg); }
}
@media(max-width:480px){
    .hero h1 { font-size:26px; }
    .footer-grid { grid-template-columns:1fr; }
    .btn-primary, .btn-secondary { width:100%; justify-content:center; }
}
</style>
</head>
<body>

<!-- NAVBAR -->
<nav class="navbar">
    <div class="logo">🏢 <span>Post-Sales OS</span></div>
    <div class="nav-links">
        <a href="#features">Features</a>
        <a href="#lifecycle">Lifecycle</a>
        <a href="AdminLogin.jsp" class="btn-login">Admin Login</a>
        <a href="CustomerLogin.jsp" class="btn-register">Customer Login</a>
    </div>
</nav>

<!-- HERO -->
<section class="hero">
    <h1>Every Customer. Every Document. <br>Every Payment. <span>In One Place.</span></h1>
    <p>
        A Post-Sales & Handover Operating System for Indian real-estate developers —
        covering everything from Booking → Agreement → Construction → Possession →
        Defect Liability → Society Handover.
    </p>
    <div class="hero-buttons">
        <a href="AdminLogin.jsp" class="btn-primary">
            <i class="fas fa-user-shield"></i> Admin Login
        </a>
        <a href="CustomerLogin.jsp" class="btn-secondary">
            <i class="fas fa-user"></i> Customer Login
        </a>
    </div>
</section>

<!-- FEATURES -->
<section class="section" id="features">
    <div class="section-title">
        <h2>Core Modules</h2>
        <p>Everything a builder needs after the sale — in one platform</p>
    </div>
    <div class="features-grid">
        <div class="feature-card">
            <div class="feature-icon">📄</div>
            <h3>Digital Document Locker</h3>
            <p>Versioned, metadata-tagged document storage. Organized by Project → Tower → Unit → Customer. One-click download.</p>
        </div>
        <div class="feature-card">
            <div class="feature-icon">💳</div>
            <h3>Payments & Receipts</h3>
            <p>Read-only ledger with total consideration, paid, outstanding, next due date, TDS and GST break-up per payment.</p>
        </div>
        <div class="feature-card">
            <div class="feature-icon">🎫</div>
            <h3>Ticketing with SLA</h3>
            <p>Ticket-based communication with auto-routing, SLA tracking, and full history. No more WhatsApp chaos.</p>
        </div>
        <div class="feature-card">
            <div class="feature-icon">🏗️</div>
            <h3>Construction Updates</h3>
            <p>Milestone-based timeline with photos/videos. Customers see real-time progress.</p>
        </div>
        <div class="feature-card">
            <div class="feature-icon">🔑</div>
            <h3>Possession Workflow</h3>
            <p>Gated pre-possession checks, customer self-scheduled inspection, and digital handover checklist.</p>
        </div>
        <div class="feature-card">
            <div class="feature-icon">🔧</div>
            <h3>Snag Management</h3>
            <p>Photo/video-based snag raising with priority, assignment, and customer verification before closure.</p>
        </div>
    </div>
</section>

<!-- LIFECYCLE -->
<section class="lifecycle-section" id="lifecycle">
    <div class="section-title">
        <h2>Complete Lifecycle Coverage</h2>
        <p>One customer journey, end to end</p>
    </div>
    <div class="lifecycle">
        <div class="lifecycle-step"><div class="circle">1</div><p>Booking</p></div>
        <div class="lifecycle-arrow">→</div>
        <div class="lifecycle-step"><div class="circle">2</div><p>Agreement</p></div>
        <div class="lifecycle-arrow">→</div>
        <div class="lifecycle-step"><div class="circle">3</div><p>Construction</p></div>
        <div class="lifecycle-arrow">→</div>
        <div class="lifecycle-step"><div class="circle">4</div><p>Possession</p></div>
        <div class="lifecycle-arrow">→</div>
        <div class="lifecycle-step"><div class="circle">5</div><p>Snags</p></div>
        <div class="lifecycle-arrow">→</div>
        <div class="lifecycle-step"><div class="circle">6</div><p>Handover</p></div>
    </div>
</section>

<!-- CTA -->
<section class="cta-section">
    <h2>Ready to Transform Your Post-Sales?</h2>
    <p>Join the builders who are replacing WhatsApp, Excel, and physical files with one platform.</p>
    <a href="AdminLogin.jsp" class="btn-white">Get Started Free →</a>
</section>

<!-- FOOTER -->
<footer>
    <div class="footer-grid">
        <div>
            <h4>🏢 Post-Sales OS</h4>
            <p>A Post-Sales & Handover Operating System for Indian real-estate developers. From Booking to Society Handover.</p>
        </div>
        <div>
            <h4>Product</h4>
            <a href="#features">Features</a>
            <a href="#lifecycle">Lifecycle</a>
        </div>
        <div>
            <h4>Company</h4>
            <a href="#">About</a>
            <a href="#">Contact</a>
            <a href="#">Pricing</a>
        </div>
        <div>
            <h4>Legal</h4>
            <a href="#">Privacy Policy</a>
            <a href="#">Terms of Service</a>
            <a href="#">RERA Compliance</a>
        </div>
    </div>
    <div class="footer-bottom">
        © 2026 Post-Sales & Handover OS. All rights reserved.
    </div>
</footer>

</body>
</html>