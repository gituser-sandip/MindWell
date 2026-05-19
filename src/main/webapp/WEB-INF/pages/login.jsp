<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ page import="com.mindwell.util.HtmlUtil" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - MindWell Nepal</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body class="auth-body">
    <!-- Navigation Bar -->
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
                <li><a href="${pageContext.request.contextPath}/home#resources" class="nav-link">Resources</a></li>
                <li><a href="${pageContext.request.contextPath}/about" class="nav-link">About Us</a></li>
            </ul>
            <div class="nav-buttons">
                <a href="${pageContext.request.contextPath}/login" class="btn-login-nav active">Login</a>
                <a href="${pageContext.request.contextPath}/register" class="btn-register-nav">Sign Up</a>
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

    <!-- Login Form -->
    <main class="auth-container">
        <div class="auth-wrapper">
            <div class="auth-card">
                <div class="auth-header">
                    <div class="auth-icon">
                        <i class="fas fa-brain"></i>
                    </div>
                    <h2>Welcome Back</h2>
                    <p>Continue your journey to mental well-being</p>
                </div>
                
                <% if (request.getAttribute("errorMessage") != null) { %>
                    <div class="alert alert-error">
                        <i class="fas fa-exclamation-circle"></i>
                        <%= HtmlUtil.escape(request.getAttribute("errorMessage")) %>
                    </div>
                <% } %>
                
                <% if (request.getAttribute("successMessage") != null) { %>
                    <div class="alert alert-success">
                        <i class="fas fa-check-circle"></i>
                        <%= HtmlUtil.escape(request.getAttribute("successMessage")) %>
                    </div>
                <% } %>
                
                <form action="${pageContext.request.contextPath}/login" method="POST" class="auth-form" id="loginForm">
                    <div class="form-group">
                        <label for="email">
                            <i class="fas fa-envelope"></i> Email Address
                        </label>
                        <div class="input-wrapper">
                            <i class="fas fa-envelope input-icon"></i>
                            <input type="email" id="email" name="email" 
                                   placeholder="Enter your email address" 
                                   required>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="password">
                            <i class="fas fa-lock"></i> Password
                        </label>
                        <div class="input-wrapper">
                            <i class="fas fa-lock input-icon"></i>
                            <input type="password" id="password" name="password" 
                                   placeholder="Enter your password" 
                                   required>
                            <i class="fas fa-eye toggle-password" onclick="togglePassword()"></i>
                        </div>
                    </div>
                    
                    <div class="form-options">
                        <label class="checkbox-label">
                            <input type="checkbox" name="remember"> 
                            <span>Remember me</span>
                        </label>
                        <a href="#" class="forgot-password" onclick="showForgotPassword()">Forgot Password?</a>
                    </div>
                    
                    <button type="submit" class="btn-auth">
                        <i class="fas fa-sign-in-alt"></i> Login
                    </button>
                </form>
                
                <div class="auth-footer">
                    <p>Don't have an account? <a href="${pageContext.request.contextPath}/register">Create an account</a></p>
                </div>
            </div>
            
			<div class="auth-sidebar">
			    <div class="sidebar-card testimonial">
			        <i class="fas fa-quote-left quote-icon"></i>
			        <p class="testimonial-text">"MindWell Nepal helped me find the right counselor. The culturally sensitive approach made all the difference in my healing journey."</p>
			        <div class="testimonial-author">
			            <img src="https://ui-avatars.com/api/?name=Priya+S&background=667eea&color=fff&size=40" alt="Avatar" class="author-img">
			            <div>
			                <h4>Priya Sharma</h4>
			                <span>Kathmandu, Nepal</span>
			            </div>
			        </div>
			        <div class="rating">
			            <i class="fas fa-star"></i>
			            <i class="fas fa-star"></i>
			            <i class="fas fa-star"></i>
			            <i class="fas fa-star"></i>
			            <i class="fas fa-star"></i>
			        </div>
			    </div>
			
			    <div class="sidebar-card benefits">
			        <div class="benefits-header">
			            <i class="fas fa-gem"></i>
			            <h3>Why Join Us?</h3>
			        </div>
			        <ul class="benefits-list">
			            <li><i class="fas fa-check-circle"></i> <span>Verified Professionals</span></li>
			            <li><i class="fas fa-check-circle"></i> <span>Culturally Sensitive</span></li>
			            <li><i class="fas fa-check-circle"></i> <span>100% Confidential</span></li>
			            <li><i class="fas fa-check-circle"></i> <span>Easy Online Booking</span></li>
			            <li><i class="fas fa-check-circle"></i> <span>Free Resources</span></li>
			            <li><i class="fas fa-check-circle"></i> <span>24/7 Crisis Support</span></li>
			        </ul>
			    </div>
			
			    <div class="sidebar-card emergency">
			        <div class="emergency-badge">
			            <i class="fas fa-phone-alt"></i>
			            <span>EMERGENCY</span>
			        </div>
			        <div class="emergency-number">1166</div>
			        <p>24/7 Crisis Support<br>Free & Confidential</p>
			    </div>
			</div>
        </div>
    </main>

    <!-- Forgot Password Modal (Hidden by default) -->
    <div id="forgotModal" class="modal" style="display: none;">
        <div class="modal-content">
            <span class="close" onclick="closeModal()">&times;</span>
            <h3>Reset Password</h3>
            <p>Enter your email address and we'll send you a link to reset your password.</p>
            <div class="form-group">
                <input type="email" id="resetEmail" placeholder="Enter your email" class="modal-input">
            </div>
            <button class="btn-auth" onclick="sendResetLink()">Send Reset Link</button>
        </div>
    </div>

    <footer class="footer">
        <div class="container">
            <div class="footer-bottom">
                <p>&copy; 2024 MindWell Nepal. Rooted in Healing.</p>
                <p>Kathmandu, Nepal | Designed with <i class="fas fa-heart"></i> Empathy</p>
            </div>
        </div>
    </footer>

    <script>
        function togglePassword() {
            const passwordInput = document.getElementById('password');
            const toggleIcon = document.querySelector('.toggle-password');
            if (passwordInput.type === 'password') {
                passwordInput.type = 'text';
                toggleIcon.classList.remove('fa-eye');
                toggleIcon.classList.add('fa-eye-slash');
            } else {
                passwordInput.type = 'password';
                toggleIcon.classList.remove('fa-eye-slash');
                toggleIcon.classList.add('fa-eye');
            }
        }
        
        function showForgotPassword() {
            document.getElementById('forgotModal').style.display = 'flex';
        }
        
        function closeModal() {
            document.getElementById('forgotModal').style.display = 'none';
        }
        
        function sendResetLink() {
            const email = document.getElementById('resetEmail').value;
            if (email) {
                alert('Password reset link sent to ' + email);
                closeModal();
            } else {
                alert('Please enter your email address');
            }
        }
        
        // Mobile menu toggle
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
        
        document.querySelectorAll('.nav-link').forEach(link => {
            link.addEventListener('click', () => {
                hamburger.classList.remove('active');
                navMenu.classList.remove('active');
            });
        });
    </script>
</body>
</html>
