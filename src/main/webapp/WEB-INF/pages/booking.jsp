<%@ page import="java.util.List" %>
<%@ page import="com.mindwell.model.CounselorModel" %>
<%@ page import="com.mindwell.model.UserModel" %>
<%@ page import="com.mindwell.util.HtmlUtil" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book Session - MindWell Nepal</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
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
                <li><a href="${pageContext.request.contextPath}/booking" class="nav-link active">Book Session</a></li>
                <li><a href="${pageContext.request.contextPath}/dashboard" class="nav-link">Dashboard</a></li>
                <li><a href="${pageContext.request.contextPath}/profile" class="nav-link">Profile</a></li>
                <li><a href="${pageContext.request.contextPath}/settings" class="nav-link nav-icon-link" title="Settings" aria-label="Settings"><i class="fas fa-cog"></i></a></li>
            </ul>
            <div class="nav-buttons">
                <span class="user-greeting">
                    <i class="fas fa-user-circle"></i>
                    <%= HtmlUtil.escape(((UserModel) session.getAttribute("user")).getFullName()) %>
                </span>
                <a href="${pageContext.request.contextPath}/logout" class="btn-logout">
                    <i class="fas fa-sign-out-alt"></i> Logout
                </a>
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

    <!-- Main Booking Content -->
    <main class="booking-main">
        <div class="booking-header">
            <h1><i class="fas fa-calendar-plus"></i> Book a Counseling Session</h1>
            <p>Connect with our verified professionals for personalized support</p>
        </div>

        <!-- Error Message Display -->
        <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="alert alert-error">
                <i class="fas fa-exclamation-circle"></i>
                <%= HtmlUtil.escape(request.getAttribute("errorMessage")) %>
            </div>
        <% } %>

        <!-- Counselors Selection Section -->
        <div class="counselors-section">
            <h2><i class="fas fa-user-md"></i> Choose Your Counselor</h2>
            <div class="counselor-grid" id="counselorGrid">
                <% 
                	@SuppressWarnings("unchecked")
                    List<CounselorModel> counselors = (List<CounselorModel>) request.getAttribute("counselors");
                    if (counselors != null && !counselors.isEmpty()) {
                        for (CounselorModel counselor : counselors) {
                %>
                    <div class="counselor-card" 
                         data-id="<%= counselor.getCounselorId() %>" 
                         data-name="<%= HtmlUtil.escapeAttribute(counselor.getFullName()) %>" 
                         data-fee="<%= counselor.getConsultationFee() %>">
                        <div class="counselor-avatar">
                            <i class="fas fa-user-circle"></i>
                        </div>
                        <h4><%= HtmlUtil.escape(counselor.getFullName()) %></h4>
                        <span class="specialization-badge"><%= HtmlUtil.escape(counselor.getSpecialization()) %></span>
                        <div class="counselor-details">
                            <p><i class="fas fa-briefcase"></i> <%= counselor.getExperienceYears() %>+ years experience</p>
                            <p><i class="fas fa-rupee-sign"></i> Rs. <%= counselor.getConsultationFee() %> per session</p>
                            <p class="counselor-bio"><%= HtmlUtil.escape(counselor.getBio()) %></p>
                        </div>
                        <% if(counselor.isAvailable()) { %>
                            <span class="available-badge"><i class="fas fa-check-circle"></i> Available</span>
                        <% } else { %>
                            <span class="unavailable-badge"><i class="fas fa-clock"></i> Not Available</span>
                        <% } %>
                        <button class="select-counselor-btn" onclick="selectCounselor(this)">
                            <i class="fas fa-hand-pointer"></i> Select
                        </button>
                    </div>
                <% 
                        }
                    } else {
                %>
                    <div class="no-counselors">
                        <i class="fas fa-frown"></i>
                        <p>No counselors available at the moment. Please check back later.</p>
                    </div>
                <% } %>
            </div>
        </div>

        <!-- Booking Form Section (Hidden by default) -->
        <div class="booking-form-section" id="bookingForm" style="display: none;">
            <div class="form-header">
                <div class="form-header-icon">
                    <i class="fas fa-clipboard-list"></i>
                </div>
                <div>
                    <h2>Session Details</h2>
                    <p>Complete the information below to confirm your appointment</p>
                </div>
            </div>

            <form action="${pageContext.request.contextPath}/booking" method="POST" class="booking-form" id="bookingFormElement">
                <!-- Selected Counselor Card -->
                <div class="selected-counselor-card">
                    <div class="selected-counselor-icon">
                        <i class="fas fa-user-md"></i>
                    </div>
                    <div class="selected-counselor-info">
                        <label>Selected Counselor</label>
                        <input type="text" id="selectedCounselorName" readonly placeholder="Click on a counselor above">
                        <input type="hidden" id="counselorId" name="counselorId" required>
                    </div>
                    <div class="selected-counselor-badge">
                        <i class="fas fa-check-circle"></i> Verified
                    </div>
                </div>

                <!-- Date & Time Row -->
                <div class="form-row-modern">
                    <div class="form-group-modern">
                        <label for="bookingDate">
                            <i class="fas fa-calendar-alt"></i> Preferred Date
                        </label>
                        <div class="input-group">
                            <input type="date" id="bookingDate" name="bookingDate" required 
                                   min="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>">
                            <span class="input-suffix"><i class="fas fa-calendar-day"></i></span>
                        </div>
                    </div>

                    <div class="form-group-modern">
                        <label for="bookingTime">
                            <i class="fas fa-clock"></i> Preferred Time
                        </label>
                        <div class="input-group">
                            <select id="bookingTime" name="bookingTime" required>
                                <option value="" disabled selected>Select time</option>
                                <option value="09:00:00">09:00 AM</option>
                                <option value="10:00:00">10:00 AM</option>
                                <option value="11:00:00">11:00 AM</option>
                                <option value="12:00:00">12:00 PM</option>
                                <option value="14:00:00">02:00 PM</option>
                                <option value="15:00:00">03:00 PM</option>
                                <option value="16:00:00">04:00 PM</option>
                                <option value="17:00:00">05:00 PM</option>
                            </select>
                            <span class="input-suffix"><i class="fas fa-chevron-down"></i></span>
                        </div>
                    </div>
                </div>

                <!-- Message Field -->
                <div class="form-group-modern full-width">
                    <label for="message">
                        <i class="fas fa-comment-dots"></i> Additional Message <span class="optional">(Optional)</span>
                    </label>
                    <div class="textarea-wrapper">
                        <textarea id="message" name="message" rows="4" 
                                  placeholder="Share any specific concerns or preferences you'd like the counselor to know..."></textarea>
                        <i class="fas fa-edit textarea-icon"></i>
                    </div>
                </div>

                <!-- Session Summary Card -->
                <div class="summary-card">
                    <div class="summary-header">
                        <i class="fas fa-receipt"></i>
                        <h4>Session Summary</h4>
                    </div>
                    <div class="summary-details-modern">
                        <div class="summary-item">
                            <span class="summary-label">
                                <i class="fas fa-rupee-sign"></i> Consultation Fee
                            </span>
                            <span class="summary-value" id="feeDisplay">Rs. 0</span>
                        </div>
                        <div class="summary-item">
                            <span class="summary-label">
                                <i class="fas fa-hourglass-half"></i> Duration
                            </span>
                            <span class="summary-value">50 minutes</span>
                        </div>
                        <div class="summary-item">
                            <span class="summary-label">
                                <i class="fas fa-video"></i> Platform
                            </span>
                            <span class="summary-value">Online / In-person</span>
                        </div>
                    </div>
                    <div class="summary-total">
                        <span>Total Amount</span>
                        <strong id="totalAmount">Rs. 0</strong>
                    </div>
                </div>

                <!-- Action Buttons -->
                <div class="form-actions">
                    <button type="button" class="btn-cancel-form" onclick="cancelBooking()">
                        <i class="fas fa-times"></i> Cancel
                    </button>
                    <button type="submit" class="btn-confirm">
                        <i class="fas fa-check-circle"></i> Confirm Booking
                    </button>
                </div>
            </form>
        </div>
    </main>

    <!-- Footer -->
    <footer class="footer">
        <div class="container">
            <div class="footer-bottom">
                <p>&copy; 2024 MindWell Nepal. Rooted in Healing.</p>
                <p>Kathmandu, Nepal | Designed with <i class="fas fa-heart"></i> Empathy</p>
            </div>
        </div>
    </footer>

    <!-- JavaScript -->
    <script>
        // Variables to store selected counselor info
        let selectedCounselorId = null;
        let selectedCounselorName = null;
        let selectedCounselorFee = 0;
        
        // Function to select a counselor
        function selectCounselor(button) {
            const card = button.closest('.counselor-card');
            selectedCounselorId = card.getAttribute('data-id');
            selectedCounselorName = card.getAttribute('data-name');
            selectedCounselorFee = card.getAttribute('data-fee');
            
            // Update form fields
            document.getElementById('counselorId').value = selectedCounselorId;
            document.getElementById('selectedCounselorName').value = selectedCounselorName;
            document.getElementById('feeDisplay').innerText = 'Rs. ' + selectedCounselorFee;
            document.getElementById('totalAmount').innerText = 'Rs. ' + selectedCounselorFee;
            
            // Show the booking form
            document.getElementById('bookingForm').style.display = 'block';
            
            // Remove highlight from all cards
            document.querySelectorAll('.counselor-card').forEach(c => {
                c.style.borderColor = 'transparent';
                c.classList.remove('selected');
            });
            
            // Highlight selected card
            card.style.borderColor = '#667eea';
            card.classList.add('selected');
            
            // Smooth scroll to booking form
            document.getElementById('bookingForm').scrollIntoView({ 
                behavior: 'smooth', 
                block: 'start' 
            });
        }
        
        // Cancel booking - hide form and reset values
        function cancelBooking() {
            document.getElementById('bookingForm').style.display = 'none';
            document.getElementById('selectedCounselorName').value = '';
            document.getElementById('counselorId').value = '';
            document.getElementById('feeDisplay').innerText = 'Rs. 0';
            document.getElementById('totalAmount').innerText = 'Rs. 0';
            document.getElementById('bookingDate').value = '';
            document.getElementById('bookingTime').value = '';
            document.getElementById('message').value = '';
            selectedCounselorId = null;
            selectedCounselorName = null;
            selectedCounselorFee = 0;
            
            // Remove highlight from all cards
            document.querySelectorAll('.counselor-card').forEach(card => {
                card.style.borderColor = 'transparent';
                card.classList.remove('selected');
            });
        }
        
        // Form validation before submit
        document.getElementById('bookingFormElement').addEventListener('submit', function(e) {
            console.log("Form submission started");
            
            if (!selectedCounselorId) {
                e.preventDefault();
                alert('Please select a counselor first');
                console.log("No counselor selected");
                return false;
            }
            
            const date = document.getElementById('bookingDate').value;
            const time = document.getElementById('bookingTime').value;
            
            if (!date) {
                e.preventDefault();
                alert('Please select a preferred date');
                console.log("No date selected");
                return false;
            }
            
            if (!time) {
                e.preventDefault();
                alert('Please select a preferred time');
                console.log("No time selected");
                return false;
            }
            
            console.log("Form validation passed - submitting");
            return true;
        });
        
        // Set minimum date for date picker (cannot select past dates)
        const today = new Date().toISOString().split('T')[0];
        const dateInput = document.getElementById('bookingDate');
        if (dateInput) {
            dateInput.setAttribute('min', today);
        }
        
        // Mobile menu toggle
        const hamburger = document.querySelector('.hamburger');
        const navMenu = document.querySelector('.nav-menu');
        
        if (hamburger) {
            hamburger.addEventListener('click', () => {
                hamburger.classList.toggle('active');
                navMenu.classList.toggle('active');
            });
        }
        
        // Navbar scroll effect
        window.addEventListener('scroll', () => {
            const navbar = document.querySelector('.navbar');
            if (navbar) {
                if (window.scrollY > 50) {
                    navbar.classList.add('scrolled');
                } else {
                    navbar.classList.remove('scrolled');
                }
            }
        });
        
        // Close mobile menu when clicking nav links
        document.querySelectorAll('.nav-link').forEach(link => {
            link.addEventListener('click', () => {
                if (hamburger) {
                    hamburger.classList.remove('active');
                    navMenu.classList.remove('active');
                }
            });
        });
    </script>
</body>
</html>
