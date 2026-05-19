<%@ page import="com.mindwell.model.UserModel" %>
<%@ page import="com.mindwell.util.HtmlUtil" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Services - MindWell Nepal</title>
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
                <li><a href="${pageContext.request.contextPath}/services" class="nav-link active">Services</a></li>
                <li><a href="${pageContext.request.contextPath}/resources" class="nav-link">Resources</a></li>
                <li><a href="${pageContext.request.contextPath}/about" class="nav-link">About Us</a></li>
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

    <main class="services-main">
        <div class="services-hero">
            <h1>Our Services</h1>
            <p>Comprehensive mental health support tailored to your needs</p>
        </div>

        <div class="services-grid">
            <div class="service-card">
                <div class="service-icon">
                    <i class="fas fa-user-friends"></i>
                </div>
                <h3>Individual Therapy</h3>
                <p>One-on-one sessions with experienced therapists to address personal challenges, anxiety, depression, and more.</p>
                <div class="service-features">
                    <span><i class="fas fa-check"></i> 50-min sessions</span>
                    <span><i class="fas fa-check"></i> Personalized approach</span>
                    <span><i class="fas fa-check"></i> Flexible scheduling</span>
                </div>
                <a href="${pageContext.request.contextPath}/booking" class="service-btn">Book Now</a>
            </div>

            <div class="service-card">
                <div class="service-icon">
                    <i class="fas fa-heart"></i>
                </div>
                <h3>Couples Counseling</h3>
                <p>Strengthen your relationship with professional guidance for communication, conflict resolution, and intimacy.</p>
                <div class="service-features">
                    <span><i class="fas fa-check"></i> Joint sessions</span>
                    <span><i class="fas fa-check"></i> Communication tools</span>
                    <span><i class="fas fa-check"></i> Conflict resolution</span>
                </div>
                <a href="${pageContext.request.contextPath}/booking" class="service-btn">Book Now</a>
            </div>

            <div class="service-card">
                <div class="service-icon">
                    <i class="fas fa-brain"></i>
                </div>
                <h3>Stress Management</h3>
                <p>Learn effective techniques to manage stress, anxiety, and build resilience in daily life.</p>
                <div class="service-features">
                    <span><i class="fas fa-check"></i> Mindfulness training</span>
                    <span><i class="fas fa-check"></i> Relaxation techniques</span>
                    <span><i class="fas fa-check"></i> Coping strategies</span>
                </div>
                <a href="${pageContext.request.contextPath}/booking" class="service-btn">Book Now</a>
            </div>

            <div class="service-card">
                <div class="service-icon">
                    <i class="fas fa-child"></i>
                </div>
                <h3>Youth & Teen Counseling</h3>
                <p>Specialized support for adolescents dealing with academic pressure, peer relationships, and identity issues.</p>
                <div class="service-features">
                    <span><i class="fas fa-check"></i> Age-appropriate approach</span>
                    <span><i class="fas fa-check"></i> Parent consultations</span>
                    <span><i class="fas fa-check"></i> School collaboration</span>
                </div>
                <a href="${pageContext.request.contextPath}/booking" class="service-btn">Book Now</a>
            </div>

            <div class="service-card">
                <div class="service-icon">
                    <i class="fas fa-hands-helping"></i>
                </div>
                <h3>Group Therapy</h3>
                <p>Connect with others facing similar challenges in a supportive group environment.</p>
                <div class="service-features">
                    <span><i class="fas fa-check"></i> Peer support</span>
                    <span><i class="fas fa-check"></i> Shared experiences</span>
                    <span><i class="fas fa-check"></i> Affordable rates</span>
                </div>
                <a href="${pageContext.request.contextPath}/booking" class="service-btn">Book Now</a>
            </div>

            <div class="service-card">
                <div class="service-icon">
                    <i class="fas fa-chalkboard-user"></i>
                </div>
                <h3>Online Workshops</h3>
                <p>Educational workshops on various mental health topics led by expert psychologists.</p>
                <div class="service-features">
                    <span><i class="fas fa-check"></i> Live sessions</span>
                    <span><i class="fas fa-check"></i> Recorded access</span>
                    <span><i class="fas fa-check"></i> Interactive learning</span>
                </div>
                <a href="${pageContext.request.contextPath}/booking" class="service-btn">Book Now</a>
            </div>
        </div>

        <div class="pricing-section">
            <h2>Simple, Transparent Pricing</h2>
            <div class="pricing-grid">
                <div class="pricing-card">
                    <h3>Single Session</h3>
                    <div class="price">Rs. 1,500</div>
                    <ul>
                        <li>50-minute session</li>
                        <li>Choose any counselor</li>
                        <li>Flexible scheduling</li>
                        <li>Secure platform</li>
                    </ul>
                    <a href="${pageContext.request.contextPath}/booking" class="btn-primary">Get Started</a>
                </div>
                <div class="pricing-card featured">
                    <div class="popular-tag">Most Popular</div>
                    <h3>Monthly Package</h3>
                    <div class="price">Rs. 5,500</div>
                    <ul>
                        <li>4 sessions per month</li>
                        <li>Same counselor</li>
                        <li>Priority booking</li>
                        <li>Free resources access</li>
                    </ul>
                    <a href="${pageContext.request.contextPath}/booking" class="btn-primary">Get Started</a>
                </div>
                <div class="pricing-card">
                    <h3>Quarterly Plan</h3>
                    <div class="price">Rs. 15,000</div>
                    <ul>
                        <li>12 sessions</li>
                        <li>Dedicated counselor</li>
                        <li>Progress tracking</li>
                        <li>24/7 chat support</li>
                    </ul>
                    <a href="${pageContext.request.contextPath}/booking" class="btn-primary">Get Started</a>
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
