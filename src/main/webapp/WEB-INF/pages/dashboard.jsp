<%@ page import="java.util.List" %>
<%@ page import="com.mindwell.model.BookingModel" %>
<%@ page import="com.mindwell.model.UserModel" %>
<%@ page import="com.mindwell.util.HtmlUtil" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - MindWell Nepal</title>
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
                <li><a href="${pageContext.request.contextPath}/booking" class="nav-link">Book Session</a></li>
                <li><a href="${pageContext.request.contextPath}/dashboard" class="nav-link active">Dashboard</a></li>
                <li><a href="${pageContext.request.contextPath}/home#emergency" class="nav-link emergency-link">Emergency Help</a></li>
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

    <!-- Dashboard Content -->
    <main class="dashboard-main">
        <div class="dashboard-header">
            <div class="dashboard-welcome">
                <h1>Welcome back, <%= HtmlUtil.escape(((UserModel) session.getAttribute("user")).getFullName()) %>!</h1>
                <p>Your mental health journey matters. Here's your activity summary.</p>
            </div>
            <div class="dashboard-stats">
                <div class="stat-card">
                    <i class="fas fa-calendar-check"></i>
                    <div>
                        <h3>Total Sessions</h3>
                        <p class="stat-number">
                            <% 
                                List<BookingModel> bookings = (List<BookingModel>) request.getAttribute("bookings");
                                int totalBookings = bookings != null ? bookings.size() : 0;
                            %>
                            <%= totalBookings %>
                        </p>
                    </div>
                </div>
                <div class="stat-card">
                    <i class="fas fa-heartbeat"></i>
                    <div>
                        <h3>Wellness Score</h3>
                        <p class="stat-number">Good</p>
                    </div>
                </div>
                <div class="stat-card">
                    <i class="fas fa-smile"></i>
                    <div>
                        <h3>Mood Today</h3>
                        <p class="stat-number">Positive</p>
                    </div>
                </div>
            </div>
        </div>

        <div class="dashboard-actions">
            <a href="${pageContext.request.contextPath}/booking" class="btn-primary">
                <i class="fas fa-plus-circle"></i> Book New Session
            </a>
            <a href="${pageContext.request.contextPath}/home#resources" class="btn-secondary">
                <i class="fas fa-book-open"></i> Browse Resources
            </a>
        </div>

        <div class="bookings-section">
            <h2><i class="fas fa-history"></i> Your Booking History</h2>
            
            <% if (request.getParameter("success") != null) { %>
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i> <%= HtmlUtil.escape(request.getParameter("success")) %>
                </div>
            <% } %>

            <% if (request.getParameter("error") != null) { %>
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-circle"></i> <%= HtmlUtil.escape(request.getParameter("error")) %>
                </div>
            <% } %>
            
            <% if (request.getAttribute("errorMessage") != null) { %>
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-circle"></i> <%= HtmlUtil.escape(request.getAttribute("errorMessage")) %>
                </div>
            <% } %>
            
            <div class="bookings-table-container">
                <table class="bookings-table">
                    <thead>
                        <tr>
                            <th><i class="fas fa-user-md"></i> Counselor</th>
                            <th><i class="fas fa-stethoscope"></i> Specialization</th>
                            <th><i class="fas fa-calendar"></i> Date</th>
                            <th><i class="fas fa-clock"></i> Time</th>
                            <th><i class="fas fa-tag"></i> Status</th>
                            <th><i class="fas fa-cog"></i> Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (bookings != null && !bookings.isEmpty()) { 
                            for (BookingModel booking : bookings) { %>
                            <tr>
                                <td><strong><%= HtmlUtil.escape(booking.getCounselorName() != null ? booking.getCounselorName() : "N/A") %></strong></td>
                                <td><%= HtmlUtil.escape(booking.getCounselorSpecialization() != null ? booking.getCounselorSpecialization() : "N/A") %></td>
                                <td><%= HtmlUtil.escape(booking.getBookingDate()) %></td>
                                <td><%= HtmlUtil.escape(booking.getBookingTime()) %></td>
                                <td>
                                    <span class="status-badge status-<%= HtmlUtil.escapeAttribute(booking.getStatus()) %>">
                                        <%= HtmlUtil.escape(booking.getStatus().toUpperCase()) %>
                                    </span>
                                </td>
                                <td>
                                    <% if ("pending".equals(booking.getStatus())) { %>
                                        <form action="${pageContext.request.contextPath}/cancelBooking" method="POST" style="display:inline;"
                                              onsubmit="return confirm('Are you sure you want to cancel this booking?')">
                                            <input type="hidden" name="bookingId" value="<%= booking.getBookingId() %>">
                                            <button type="submit" class="btn-cancel">
                                                <i class="fas fa-times"></i> Cancel
                                            </button>
                                        </form>
                                    <% } else if ("confirmed".equals(booking.getStatus())) { %>
                                        <span class="confirmed-badge"><i class="fas fa-check"></i> Confirmed</span>
                                    <% } else if ("completed".equals(booking.getStatus())) { %>
                                        <span class="completed-badge"><i class="fas fa-star"></i> Completed</span>
                                    <% } else { %>
                                        <span class="cancelled-badge"><i class="fas fa-ban"></i> Cancelled</span>
                                    <% } %>
                                </td>
                            </tr>
                        <% } 
                        } else { %>
                            <tr>
                                <td colspan="6" class="no-data">
                                    <i class="fas fa-inbox"></i>
                                    <p>No bookings found.</p>
                                    <a href="${pageContext.request.contextPath}/booking" class="btn-primary-small">Book Your First Session</a>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Wellness Tips Section -->
        <div class="wellness-tips">
            <h3><i class="fas fa-lightbulb"></i> Daily Wellness Tip</h3>
            <p>"Take a moment to breathe deeply. Your mental health is a priority, not an afterthought."</p>
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
