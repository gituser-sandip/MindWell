<%@ page import="java.util.List" %>
<%@ page import="com.mindwell.model.BookingModel" %>
<%@ page import="com.mindwell.model.UserModel" %>
<%@ page import="com.mindwell.util.HtmlUtil" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Bookings - MindWell Nepal</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <header>
        <nav>
            <div class="logo">
                <h1>MindWell Nepal</h1>
            </div>
            <ul>
                <li><a href="${pageContext.request.contextPath}/home">Home</a></li>
                <li><a href="${pageContext.request.contextPath}/booking">Book Session</a></li>
                <li><a href="${pageContext.request.contextPath}/dashboard">Dashboard</a></li>
                <li><a href="${pageContext.request.contextPath}/logout">Logout</a></li>
            </ul>
        </nav>
    </header>
    
    <main class="dashboard-container">
        <h2>My Complete Booking History</h2>
        
        <% if (request.getParameter("success") != null) { %>
            <div class="success-message">
                <%= HtmlUtil.escape(request.getParameter("success")) %>
            </div>
        <% } %>
        
        <table class="bookings-table">
            <thead>
                <tr>
                    <th>Booking ID</th>
                    <th>Counselor</th>
                    <th>Specialization</th>
                    <th>Date</th>
                    <th>Time</th>
                    <th>Status</th>
                    <th>Message</th>
                    <th>Booked On</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <% 
                    List<BookingModel> bookings = (List<BookingModel>) request.getAttribute("bookings");
                    if (bookings != null && !bookings.isEmpty()) {
                        for (BookingModel booking : bookings) {
                %>
                    <tr>
                        <td>#<%= booking.getBookingId() %></td>
                        <td><%= HtmlUtil.escape(booking.getCounselorName()) %></td>
                        <td><%= HtmlUtil.escape(booking.getCounselorSpecialization()) %></td>
                        <td><%= HtmlUtil.escape(booking.getBookingDate()) %></td>
                        <td><%= HtmlUtil.escape(booking.getBookingTime()) %></td>
                        <td>
                            <span class="status-<%= HtmlUtil.escapeAttribute(booking.getStatus()) %>">
                                <%= HtmlUtil.escape(booking.getStatus().toUpperCase()) %>
                            </span>
                        </td>
                        <td><%= HtmlUtil.escape(booking.getMessage() != null && !booking.getMessage().isEmpty() ? booking.getMessage() : "-") %></td>
                        <td><%= HtmlUtil.escape(booking.getCreatedAt() != null ? booking.getCreatedAt() : "-") %></td>
                        <td>
                            <% if ("pending".equals(booking.getStatus())) { %>
                                <form action="${pageContext.request.contextPath}/cancelBooking" method="POST" style="display:inline;"
                                      onsubmit="return confirm('Are you sure you want to cancel this booking?')">
                                    <input type="hidden" name="bookingId" value="<%= booking.getBookingId() %>">
                                    <button type="submit" class="btn-cancel">Cancel</button>
                                </form>
                            <% } else if ("confirmed".equals(booking.getStatus())) { %>
                                <span style="color: #4CAF50;">Confirmed ✓</span>
                            <% } else if ("cancelled".equals(booking.getStatus())) { %>
                                <span style="color: #f44336;">Cancelled</span>
                            <% } else { %>
                                <span style="color: #2196F3;">Completed</span>
                            <% } %>
                        </td>
                    </tr>
                <% 
                        }
                    } else {
                %>
                    <tr>
                        <td colspan="9" class="no-data">No bookings found. <a href="${pageContext.request.contextPath}/booking">Book your first session!</a></td>
                    </tr>
                <% } %>
            </tbody>
        </table>
        
        <div style="margin-top: 20px; text-align: center;">
            <a href="${pageContext.request.contextPath}/booking" class="btn-primary">Book New Session</a>
            <a href="${pageContext.request.contextPath}/dashboard" style="margin-left: 10px;" class="btn-secondary">Back to Dashboard</a>
        </div>
    </main>
    
    <footer>
        <p>&copy; 2024 MindWell Nepal. All rights reserved.</p>
    </footer>
</body>
</html>
