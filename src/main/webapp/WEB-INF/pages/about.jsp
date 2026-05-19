<%@ page import="com.mindwell.model.UserModel" %>
<%@ page import="com.mindwell.util.HtmlUtil" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>About Us - MindWell Nepal</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <nav class="navbar">
        <div class="nav-container">
            <div class="nav-logo">
                <a href="${pageContext.request.contextPath}/home">
                    <h1>MindWell Nepal</h1>
                    <span class="logo-tagline">Rooted in Healing</span>
                </a>
            </div>
            <ul class="nav-menu">
                <li><a href="${pageContext.request.contextPath}/home" class="nav-link">Home</a></li>
                <li><a href="${pageContext.request.contextPath}/home#professionals" class="nav-link">Professionals</a></li>
                <li><a href="${pageContext.request.contextPath}/resources" class="nav-link">Resources</a></li>
                <li><a href="${pageContext.request.contextPath}/about" class="nav-link active">About Us</a></li>
            </ul>
            <%
                UserModel currentUser = (UserModel) session.getAttribute("user");
                boolean isAdmin = currentUser != null && ("admin".equals(currentUser.getUserType()) || "super_admin".equals(currentUser.getUserType()));
            %>
            <div class="nav-buttons">
                <% if (currentUser != null) { %>
                    <span class="user-greeting">
                        <i class="fas fa-user-circle"></i>
                        <%= HtmlUtil.escape(currentUser.getFullName()) %>
                    </span>
                    <a href="${pageContext.request.contextPath}/<%= isAdmin ? "admin" : "dashboard" %>" class="btn-login-nav">
                        <%= isAdmin ? "Admin" : "Dashboard" %>
                    </a>
                    <a href="${pageContext.request.contextPath}/profile" class="btn-login-nav">Profile</a>
                    <a href="${pageContext.request.contextPath}/settings" class="btn-login-nav nav-icon-link" title="Settings" aria-label="Settings">
                        <i class="fas fa-cog"></i>
                    </a>
                    <a href="${pageContext.request.contextPath}/logout" class="btn-logout">
                        <i class="fas fa-sign-out-alt"></i> Logout
                    </a>
                <% } else { %>
                    <a href="${pageContext.request.contextPath}/login" class="btn-login-nav">Login</a>
                    <a href="${pageContext.request.contextPath}/register" class="btn-register-nav">Sign Up</a>
                <% } %>
            </div>
            <div class="hamburger">
                <span class="bar"></span>
                <span class="bar"></span>
                <span class="bar"></span>
            </div>
        </div>
    </nav>
    <a href="${pageContext.request.contextPath}/home#emergency" class="floating-emergency-help" aria-label="Emergency help">
        <i class="fas fa-phone-alt"></i>
        <span>Emergency</span>
    </a>

    <main class="about-main">
        <div class="about-hero">
            <h1>About MindWell Nepal</h1>
            <p>A compassionate digital ecosystem dedicated to democratizing mental healthcare across Nepal</p>
        </div>

        <div class="about-content">
            <div class="mission-section">
                <div class="mission-card">
                    <i class="fas fa-bullseye"></i>
                    <h2>Our Mission</h2>
                    <p>To break the stigma around mental health and provide accessible, professional, and culturally sensitive mental health support to every Nepali.</p>
                </div>
                <div class="mission-card">
                    <i class="fas fa-eye"></i>
                    <h2>Our Vision</h2>
                    <p>A Nepal where mental health is prioritized, understood, and everyone has access to quality mental health care without judgment.</p>
                </div>
            </div>

            <div class="values-section">
                <h2>Our Core Values</h2>
                <div class="values-grid">
                    <div class="value-item">
                        <i class="fas fa-heart"></i>
                        <h3>Compassion</h3>
                        <p>We approach every interaction with empathy and understanding.</p>
                    </div>
                    <div class="value-item">
                        <i class="fas fa-shield-alt"></i>
                        <h3>Confidentiality</h3>
                        <p>Your privacy is our highest priority.</p>
                    </div>
                    <div class="value-item">
                        <i class="fas fa-hand-sparkles"></i>
                        <h3>Cultural Sensitivity</h3>
                        <p>Respecting and integrating Nepalese cultural values.</p>
                    </div>
                    <div class="value-item">
                        <i class="fas fa-chart-line"></i>
                        <h3>Excellence</h3>
                        <p>Committed to the highest standards of care.</p>
                    </div>
                </div>
            </div>

            <div class="story-section">
                <div class="story-content">
                    <h2>Our Story</h2>
                    <p>Founded in 2024, MindWell Nepal emerged from a simple yet powerful belief: everyone deserves access to quality mental health care. In a country where mental health has long been stigmatized and overlooked, we saw an opportunity to create change.</p>
                    <p>Today, we connect thousands of Nepalis with verified mental health professionals, provide educational resources, and foster a community of support. Our platform bridges the gap between those seeking help and those ready to provide it, all while respecting the unique cultural landscape of Nepal.</p>
                </div>
                <div class="story-stats">
                    <div class="stat">
                        <h3>1000+</h3>
                        <p>Happy Clients</p>
                    </div>
                    <div class="stat">
                        <h3>50+</h3>
                        <p>Expert Counselors</p>
                    </div>
                    <div class="stat">
                        <h3>100%</h3>
                        <p>Confidential Support</p>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <footer class="footer">
        <div class="container">
            <div class="footer-bottom">
                <p>&copy; 2024 MindWell Nepal. Rooted in Healing.</p>
                <p>Kathmandu, Nepal | Designed with <i class="fas fa-heart"></i> Empathy</p>
            </div>
        </div>
    </footer>

    <script>
        const hamburger = document.querySelector('.hamburger');
        const navMenu = document.querySelector('.nav-menu');
        
        hamburger.addEventListener('click', () => {
            hamburger.classList.toggle('active');
            navMenu.classList.toggle('active');
        });
        
        window.addEventListener('scroll', () => {
            const navbar = document.querySelector('.navbar');
            if (window.scrollY > 50) {
                navbar.classList.add('scrolled');
            } else {
                navbar.classList.remove('scrolled');
            }
        });
    </script>
</body>
</html>
