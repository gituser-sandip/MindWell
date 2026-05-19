<%@ page import="com.mindwell.model.UserModel" %>
<%@ page import="com.mindwell.model.CounselorModel" %>
<%@ page import="com.mindwell.util.HtmlUtil" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profile - MindWell Nepal</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <%
        UserModel userProfile = (UserModel) request.getAttribute("userProfile");
        if (userProfile == null) {
            userProfile = (UserModel) session.getAttribute("user");
        }
        CounselorModel counselorProfile = (CounselorModel) request.getAttribute("counselorProfile");
        boolean isAdmin = userProfile != null && ("admin".equals(userProfile.getUserType()) || "super_admin".equals(userProfile.getUserType()));
    %>
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
                <li><a href="${pageContext.request.contextPath}/profile" class="nav-link active">Profile</a></li>
                <li><a href="${pageContext.request.contextPath}/settings" class="nav-link nav-icon-link" title="Settings" aria-label="Settings"><i class="fas fa-cog"></i></a></li>
                <li><a href="${pageContext.request.contextPath}/<%= isAdmin ? "admin" : "dashboard" %>" class="nav-link"><%= isAdmin ? "Admin" : "Dashboard" %></a></li>
            </ul>
            <div class="nav-buttons">
                <span class="user-greeting">
                    <i class="fas fa-user-circle"></i>
                    <%= HtmlUtil.escape(userProfile.getFullName()) %>
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

    <main class="profile-main">
        <section class="profile-header">
            <div>
                <h1>My Profile</h1>
                <p>Manage your personal details and how your account appears in the system.</p>
            </div>
            <span class="status-badge status-<%= HtmlUtil.escapeAttribute(userProfile.getAccountStatus()) %>">
                <%= HtmlUtil.escape(userProfile.getAccountStatus().toUpperCase()) %>
            </span>
        </section>

        <% if (request.getAttribute("successMessage") != null) { %>
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i> <%= HtmlUtil.escape(request.getAttribute("successMessage")) %>
            </div>
        <% } %>
        <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="alert alert-error">
                <i class="fas fa-exclamation-circle"></i> <%= HtmlUtil.escape(request.getAttribute("errorMessage")) %>
            </div>
        <% } %>

        <form action="${pageContext.request.contextPath}/profile" method="POST" class="profile-grid">
            <section class="profile-panel">
                <h2><i class="fas fa-id-card"></i> Account Details</h2>
                <div class="form-row">
                    <div class="form-group">
                        <label for="fullName">Full Name</label>
                        <input type="text" id="fullName" name="fullName" value="<%= HtmlUtil.escapeAttribute(userProfile.getFullName()) %>" required>
                    </div>
                    <div class="form-group">
                        <label>Email</label>
                        <input type="email" value="<%= HtmlUtil.escapeAttribute(userProfile.getEmail()) %>" readonly>
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label for="phone">Phone</label>
                        <input type="tel" id="phone" name="phone" value="<%= HtmlUtil.escapeAttribute(userProfile.getPhone()) %>">
                    </div>
                    <div class="form-group">
                        <label for="city">City</label>
                        <input type="text" id="city" name="city" value="<%= HtmlUtil.escapeAttribute(userProfile.getCity()) %>">
                    </div>
                </div>
                <div class="profile-meta">
                    <span><strong>Role:</strong> <%= HtmlUtil.escape(userProfile.getUserType()) %></span>
                    <span><strong>Requested:</strong> <%= HtmlUtil.escape(userProfile.getRequestedUserType()) %></span>
                    <span><strong>Joined:</strong> <%= HtmlUtil.escape(userProfile.getCreatedAt()) %></span>
                </div>
            </section>

            <% if (counselorProfile != null) { %>
                <section class="profile-panel">
                    <h2><i class="fas fa-user-md"></i> Counselor Profile</h2>
                    <div class="form-row">
                        <div class="form-group">
                            <label for="specialization">Specialization</label>
                            <input type="text" id="specialization" name="specialization" value="<%= HtmlUtil.escapeAttribute(counselorProfile.getSpecialization()) %>" required>
                        </div>
                        <div class="form-group">
                            <label for="experienceYears">Experience Years</label>
                            <input type="number" id="experienceYears" name="experienceYears" min="0" value="<%= counselorProfile.getExperienceYears() %>" required>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group">
                            <label for="consultationFee">Consultation Fee</label>
                            <input type="number" id="consultationFee" name="consultationFee" min="0" step="0.01" value="<%= counselorProfile.getConsultationFee() %>" required>
                        </div>
                        <div class="form-group">
                            <label>Status</label>
                            <input type="text" value="<%= counselorProfile.isVerified() ? (counselorProfile.isAvailable() ? "Verified and visible" : "Verified but suspended") : "Waiting for admin confirmation" %>" readonly>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="bio">Bio</label>
                        <textarea id="bio" name="bio" rows="5" required><%= HtmlUtil.escape(counselorProfile.getBio()) %></textarea>
                    </div>
                </section>
            <% } %>

            <div class="profile-actions">
                <button type="submit" class="btn-primary">
                    <i class="fas fa-save"></i> Save Profile
                </button>
                <a href="${pageContext.request.contextPath}/settings" class="btn-secondary">
                    <i class="fas fa-cog"></i> Settings
                </a>
            </div>
        </form>
    </main>
    <script>
        const hamburger = document.querySelector('.hamburger');
        const navMenu = document.querySelector('.nav-menu');
        
        if (hamburger) {
            hamburger.addEventListener('click', () => {
                hamburger.classList.toggle('active');
                navMenu.classList.toggle('active');
            });
        }
    </script>
</body>
</html>
