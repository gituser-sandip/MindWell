<%@ page import="com.mindwell.model.UserModel" %>
<%@ page import="com.mindwell.util.HtmlUtil" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MindWell Nepal - Your Journey to Mental Well-being Starts Here</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <!-- Navigation Bar -->
    <nav class="navbar">
        <div class="nav-container">
            <div class="nav-logo">
                <h1>MindWell Nepal</h1>
                <span class="logo-tagline">Rooted in Healing</span>
            </div>
            <ul class="nav-menu">
                <li><a href="#home" class="nav-link active">Home</a></li>
                <li><a href="#professionals" class="nav-link">Professionals</a></li>
                <li><a href="#resources" class="nav-link">Resources</a></li>
                <li><a href="#about" class="nav-link">About Us</a></li>
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
    <a href="#emergency" class="floating-emergency-help" aria-label="Emergency help">
        <i class="fas fa-phone-alt"></i>
        <span>Emergency</span>
    </a>

    <!-- Hero Section -->
    <section class="hero" id="home">
        <div class="hero-container">
            <div class="hero-content">
                <h1 class="hero-title">
                    Your Journey to <span class="highlight">Mental Well-being</span> Starts Here.
                </h1>
                <p class="hero-description">
                    A safe, culturally sensitive space rooted in the healing landscapes of Nepal. 
                    Connect with verified professionals dedicated to your growth.
                </p>
                <div class="hero-buttons">
                    <a href="${pageContext.request.contextPath}/booking" class="btn-primary btn-large">
                        <i class="fas fa-search"></i> Find a Professional
                    </a>
                    <a href="${pageContext.request.contextPath}/resources" class="btn-secondary btn-large">
                        <i class="fas fa-book-open"></i> Explore Resources
                    </a>
                </div>
            </div>
            <div class="hero-image">
                <div class="floating-card card-1">
                    <i class="fas fa-heart"></i>
                    <span>Safe Space</span>
                </div>
                <div class="floating-card card-2">
                    <i class="fas fa-hand-holding-heart"></i>
                    <span>24/7 Support</span>
                </div>
                <div class="floating-card card-3">
                    <i class="fas fa-leaf"></i>
                    <span>Holistic Care</span>
                </div>
                <div class="hero-illustration">
                    <i class="fas fa-brain"></i>
                    <i class="fas fa-hands-helping"></i>
                    <i class="fas fa-mountain"></i>
                </div>
            </div>
        </div>
    </section>

    <!-- Why Choose MindWell Section -->
    <section class="why-choose" id="about">
        <div class="container">
            <div class="section-header">
                <h2>Why Choose MindWell</h2>
                <p>Our commitment to excellence and cultural integrity ensures you receive the highest standard of care.</p>
            </div>
            <div class="features-grid">
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-shield-alt"></i>
                    </div>
                    <h3>Verified Professionals</h3>
                    <p>Every practitioner on our platform undergoes a rigorous vetting process to ensure clinical excellence.</p>
                </div>
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-hands"></i>
                    </div>
                    <h3>Culturally Sensitive</h3>
                    <p>Healing practices that respect and integrate Nepalese cultural nuances and traditional values.</p>
                </div>
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-lock"></i>
                    </div>
                    <h3>Confidential Support</h3>
                    <p>Your privacy is our paramount concern. All interactions are protected by industry-standard security.</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Emergency Help Section -->
    <section class="emergency" id="emergency">
        <div class="container">
            <div class="emergency-content">
                <div class="emergency-icon">
                    <i class="fas fa-phone-alt"></i>
                    <i class="fas fa-exclamation-triangle"></i>
                </div>
                <h2>In a Crisis? We're Here to Help.</h2>
                <div class="helpline-number">
                    <span>NATIONAL HELPLINE</span>
                    <h3>1166</h3>
                </div>
                <p>If you or someone you know is in immediate danger, please reach out to our local partners immediately.</p>
                <a href="#" class="btn-emergency">
                    <i class="fas fa-phone"></i> Get Immediate Help
                </a>
            </div>
        </div>
    </section>

    <!-- Knowledge Hub / Resources Section -->
    <section class="knowledge-hub" id="resources">
        <div class="container">
            <div class="section-header">
                <h2>Knowledge Hub</h2>
                <p>Resources for the Soul</p>
                <a href="${pageContext.request.contextPath}/resources" class="view-all">View All Library <i class="fas fa-arrow-right"></i></a>
            </div>
            <div class="resources-grid">
                <div class="resource-card">
                    <div class="resource-category relationships">
                        <i class="fas fa-users"></i> RELATIONSHIPS
                    </div>
                    <h3>Building Stronger Community Bonds</h3>
                    <p>The power of local support systems and family dynamics in healing.</p>
                    <a href="${pageContext.request.contextPath}/resources" class="read-more">Read More <i class="fas fa-arrow-right"></i></a>
                </div>
                <div class="resource-card">
                    <div class="resource-category selfcare">
                        <i class="fas fa-spa"></i> SELF-CARE
                    </div>
                    <h3>5 Daily Rituals for Inner Peace</h3>
                    <p>Simple, accessible practices for better emotional regulation throughout the day.</p>
                    <a href="${pageContext.request.contextPath}/resources" class="read-more">Read More <i class="fas fa-arrow-right"></i></a>
                </div>
                <div class="resource-card">
                    <div class="resource-category therapy">
                        <i class="fas fa-comments"></i> THERAPY
                    </div>
                    <h3>What to Expect in Your First Session</h3>
                    <p>Demystifying the therapy process for first-time seekers in Nepal.</p>
                    <a href="${pageContext.request.contextPath}/resources" class="read-more">Read More <i class="fas fa-arrow-right"></i></a>
                </div>
                <div class="resource-card featured">
                    <div class="resource-category mindfulness">
                        <i class="fas fa-brain"></i> GUIDED MINDFULNESS
                    </div>
                    <h3>Understanding Anxiety in a Modern Nepal</h3>
                    <p>How cultural pressures and changing urban landscapes affect our collective mental health, and steps to find balance.</p>
                    <a href="${pageContext.request.contextPath}/resources" class="read-more">Read More <i class="fas fa-arrow-right"></i></a>
                </div>
            </div>
        </div>
    </section>

    <!-- Professionals Preview Section -->
    <section class="professionals" id="professionals">
        <div class="container">
            <div class="section-header">
                <h2>Meet Our Experts</h2>
                <p>Verified professionals dedicated to your well-being</p>
            </div>
            <div class="professionals-grid">
                <div class="professional-card">
                    <div class="professional-image">
                        <i class="fas fa-user-circle"></i>
                    </div>
                    <h4>Dr. Sarah Sharma</h4>
                    <span class="specialization">Clinical Psychologist</span>
                    <p>8+ years of experience in anxiety and depression</p>
                    <div class="professional-rating">
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                        <span>(128 reviews)</span>
                    </div>
                    <a href="${pageContext.request.contextPath}/booking" class="btn-book">Book Session</a>
                </div>
                <div class="professional-card">
                    <div class="professional-image">
                        <i class="fas fa-user-circle"></i>
                    </div>
                    <h4>Rajesh Khanal</h4>
                    <span class="specialization">Counseling Psychologist</span>
                    <p>Specializing in relationship and family therapy</p>
                    <div class="professional-rating">
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star-half-alt"></i>
                        <span>(95 reviews)</span>
                    </div>
                    <a href="${pageContext.request.contextPath}/booking" class="btn-book">Book Session</a>
                </div>
                <div class="professional-card">
                    <div class="professional-image">
                        <i class="fas fa-user-circle"></i>
                    </div>
                    <h4>Dr. Anita Basnet</h4>
                    <span class="specialization">Psychiatrist</span>
                    <p>Expert in trauma and PTSD treatment</p>
                    <div class="professional-rating">
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                        <span>(203 reviews)</span>
                    </div>
                    <a href="${pageContext.request.contextPath}/booking" class="btn-book">Book Session</a>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer class="footer">
        <div class="container">
            <div class="footer-grid">
                <div class="footer-about">
                    <h3>MindWell Nepal</h3>
                    <p>A compassionate digital ecosystem dedicated to democratizing mental healthcare across Nepal through technology and empathy.</p>
                    <div class="social-links">
                        <a href="#"><i class="fab fa-facebook"></i></a>
                        <a href="#"><i class="fab fa-instagram"></i></a>
                        <a href="#"><i class="fab fa-twitter"></i></a>
                        <a href="#"><i class="fab fa-linkedin"></i></a>
                    </div>
                </div>
                <div class="footer-links">
                    <h4>Explore</h4>
                    <ul>
                        <li><a href="#professionals">Professionals</a></li>
                        <li><a href="${pageContext.request.contextPath}/resources">Resource Library</a></li>
                        <li><a href="#">Success Stories</a></li>
                        <li><a href="#">Workshops</a></li>
                    </ul>
                </div>
                <div class="footer-links">
                    <h4>Legal & Support</h4>
                    <ul>
                        <li><a href="#">Privacy Policy</a></li>
                        <li><a href="#">Terms of Service</a></li>
                        <li><a href="#">Crisis Hotline</a></li>
                        <li><a href="#">Contact Us</a></li>
                    </ul>
                </div>
                <div class="footer-newsletter">
                    <h4>Newsletter</h4>
                    <p>Get monthly insights on mental wellness and local events.</p>
                    <form class="newsletter-form">
                        <input type="email" placeholder="Your email address" required>
                        <button type="submit">Join <i class="fas fa-paper-plane"></i></button>
                    </form>
                </div>
            </div>
            <div class="footer-bottom">
                <p>&copy; 2024 MindWell Nepal. Rooted in Healing.</p>
                <p>Kathmandu, Nepal | Designed with <i class="fas fa-heart"></i> Empathy</p>
            </div>
        </div>
    </footer>

    <script>
        // Mobile menu toggle
        const hamburger = document.querySelector('.hamburger');
        const navMenu = document.querySelector('.nav-menu');
        
        hamburger.addEventListener('click', () => {
            hamburger.classList.toggle('active');
            navMenu.classList.toggle('active');
        });
        
        // Close mobile menu when clicking on a link
        document.querySelectorAll('.nav-link').forEach(link => {
            link.addEventListener('click', () => {
                hamburger.classList.remove('active');
                navMenu.classList.remove('active');
            });
        });
        
        // Smooth scrolling for anchor links
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                const target = document.querySelector(this.getAttribute('href'));
                if (target) {
                    target.scrollIntoView({
                        behavior: 'smooth',
                        block: 'start'
                    });
                }
            });
        });
        
        // Navbar scroll effect
        window.addEventListener('scroll', () => {
            const navbar = document.querySelector('.navbar');
            if (window.scrollY > 100) {
                navbar.classList.add('scrolled');
            } else {
                navbar.classList.remove('scrolled');
            }
        });
        
        // Animate elements on scroll
        const observerOptions = {
            threshold: 0.1,
            rootMargin: '0px 0px -50px 0px'
        };
        
        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.classList.add('animate');
                    observer.unobserve(entry.target);
                }
            });
        }, observerOptions);
        
        document.querySelectorAll('.feature-card, .resource-card, .professional-card').forEach(el => {
            observer.observe(el);
        });
    </script>
</body>
</html>
