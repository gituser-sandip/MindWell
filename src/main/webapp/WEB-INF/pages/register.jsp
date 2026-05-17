<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ page import="com.mindwell.util.HtmlUtil" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - MindWell Nepal</title>
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
                <li><a href="${pageContext.request.contextPath}/home#about" class="nav-link">About Us</a></li>
                <li><a href="${pageContext.request.contextPath}/home#emergency" class="nav-link emergency-link">Emergency Help</a></li>
            </ul>
            <div class="nav-buttons">
                <a href="${pageContext.request.contextPath}/login" class="btn-login-nav">Login</a>
                <a href="${pageContext.request.contextPath}/register" class="btn-register-nav active">Register</a>
            </div>
            <div class="hamburger">
                <span class="bar"></span>
                <span class="bar"></span>
                <span class="bar"></span>
            </div>
        </div>
    </nav>

    <!-- Registration Form -->
    <main class="auth-container">
        <div class="auth-wrapper">
            <div class="auth-card">
                <div class="auth-header">
                    <div class="auth-icon">
                        <i class="fas fa-user-plus"></i>
                    </div>
                    <h2>Create Account</h2>
                    <p>Start your journey with us today</p>
                </div>
                
                <% if (request.getAttribute("errorMessage") != null) { %>
                    <div class="alert alert-error">
                        <i class="fas fa-exclamation-circle"></i>
                        <%= HtmlUtil.escape(request.getAttribute("errorMessage")) %>
                    </div>
                <% } %>
                
                <form action="${pageContext.request.contextPath}/register" method="POST" class="auth-form">
                    <div class="form-row">
                        <div class="form-group">
                            <label for="fullName">
                                <i class="fas fa-user"></i> Full Name
                            </label>
                            <div class="input-wrapper">
                                <i class="fas fa-user input-icon"></i>
                                <input type="text" id="fullName" name="fullName" 
                                       placeholder="Enter your full name" 
                                       required>
                            </div>
                        </div>
                        
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
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="password">
                                <i class="fas fa-lock"></i> Password
                            </label>
                            <div class="input-wrapper">
                                <i class="fas fa-lock input-icon"></i>
                                <input type="password" id="password" name="password" 
                                       placeholder="Create a strong password" 
                                       required>
                                <i class="fas fa-eye toggle-password" onclick="togglePassword('password')"></i>
                            </div>
                            <small class="form-hint"><i class="fas fa-shield-alt"></i> Minimum 8 characters</small>
                        </div>
                        
                        <div class="form-group">
                            <label for="confirmPassword">
                                <i class="fas fa-check-circle"></i> Confirm Password
                            </label>
                            <div class="input-wrapper">
                                <i class="fas fa-check-circle input-icon"></i>
                                <input type="password" id="confirmPassword" name="confirmPassword"
                                       placeholder="Confirm your password">
                                <i class="fas fa-eye toggle-password" onclick="togglePassword('confirmPassword')"></i>
                            </div>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="accountType">
                            <i class="fas fa-user-tag"></i> Account Request Type
                        </label>
                        <div class="input-wrapper">
                            <i class="fas fa-user-tag input-icon"></i>
                            <select id="accountType" name="accountType" required onchange="toggleCounselorFields()">
                                <option value="user" selected>Client / User Account</option>
                                <option value="counselor">Counselor Account</option>
                            </select>
                        </div>
                    </div>

                    <div id="counselorFields" style="display: none;">
                        <div class="form-row">
                            <div class="form-group">
                                <label for="specialization">
                                    <i class="fas fa-stethoscope"></i> Specialization
                                </label>
                                <div class="input-wrapper">
                                    <i class="fas fa-stethoscope input-icon"></i>
                                    <input type="text" id="specialization" name="specialization"
                                           placeholder="Clinical Psychology, CBT, Youth Counseling">
                                </div>
                            </div>
                            
                            <div class="form-group">
                                <label for="experienceYears">
                                    <i class="fas fa-briefcase"></i> Experience Years
                                </label>
                                <div class="input-wrapper">
                                    <i class="fas fa-briefcase input-icon"></i>
                                    <input type="number" id="experienceYears" name="experienceYears"
                                           min="0" placeholder="5">
                                </div>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="consultationFee">
                                    <i class="fas fa-rupee-sign"></i> Consultation Fee
                                </label>
                                <div class="input-wrapper">
                                    <i class="fas fa-rupee-sign input-icon"></i>
                                    <input type="number" id="consultationFee" name="consultationFee"
                                           min="0" step="0.01" placeholder="1500">
                                </div>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="bio">
                                <i class="fas fa-id-card"></i> Professional Bio
                            </label>
                            <div class="input-wrapper">
                                <i class="fas fa-id-card input-icon"></i>
                                <textarea id="bio" name="bio" placeholder="Briefly describe your qualifications and counseling approach."></textarea>
                            </div>
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="phone">
                                <i class="fas fa-phone"></i> Phone Number
                            </label>
                            <div class="input-wrapper">
                                <i class="fas fa-phone input-icon"></i>
                                <input type="tel" id="phone" name="phone" 
                                       placeholder="Enter your phone number">
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label for="city">
                                <i class="fas fa-map-marker-alt"></i> City
                            </label>
                            <div class="input-wrapper">
                                <i class="fas fa-map-marker-alt input-icon"></i>
                                <input type="text" id="city" name="city" 
                                       placeholder="Enter your city">
                            </div>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label class="checkbox-label">
                            <input type="checkbox" required> 
                            <span>I agree to the <a href="#">Terms of Service</a> and <a href="#">Privacy Policy</a></span>
                        </label>
                    </div>
                    
                    <button type="submit" class="btn-auth">
                        <i class="fas fa-user-plus"></i> Create Account
                    </button>
                </form>
                
                <div class="auth-footer">
                    <p>Already have an account? <a href="${pageContext.request.contextPath}/login">Sign in here</a></p>
                </div>
            </div>
            
			<div class="auth-sidebar">
			
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

    <footer class="footer">
        <div class="container">
            <div class="footer-bottom">
                <p>&copy; 2024 MindWell Nepal. Rooted in Healing.</p>
                <p>Kathmandu, Nepal | Designed with <i class="fas fa-heart"></i> Empathy</p>
            </div>
        </div>
    </footer>

    <script>
        function togglePassword(fieldId) {
            const passwordInput = document.getElementById(fieldId);
            const toggleIcon = event.target;
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

        function toggleCounselorFields() {
            const accountType = document.getElementById('accountType').value;
            const fields = document.getElementById('counselorFields');
            const required = accountType === 'counselor';
            fields.style.display = required ? 'block' : 'none';
            ['specialization', 'experienceYears', 'consultationFee', 'bio'].forEach(id => {
                document.getElementById(id).required = required;
            });
        }
        
        // Password confirmation check
        const password = document.getElementById('password');
        const confirmPassword = document.getElementById('confirmPassword');
        
        confirmPassword.addEventListener('change', function() {
            if (password.value !== this.value) {
                this.setCustomValidity('Passwords do not match');
                this.style.borderColor = '#f44336';
            } else {
                this.setCustomValidity('');
                this.style.borderColor = '#4caf50';
            }
        });
        
        password.addEventListener('change', function() {
            if (this.value.length > 0 && this.value.length < 8) {
                this.style.borderColor = '#f44336';
            } else {
                this.style.borderColor = '#4caf50';
            }
        });
        
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
        
        // Close mobile menu when clicking on a link
        document.querySelectorAll('.nav-link').forEach(link => {
            link.addEventListener('click', () => {
                hamburger.classList.remove('active');
                navMenu.classList.remove('active');
            });
        });

        toggleCounselorFields();
    </script>
</body>
</html>
