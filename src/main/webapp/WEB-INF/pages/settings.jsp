<%@ page import="com.mindwell.model.UserModel" %>
<%@ page import="com.mindwell.util.HtmlUtil" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Settings - MindWell Nepal</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <%
        UserModel currentUser = (UserModel) session.getAttribute("user");
        boolean isAdmin = currentUser != null && ("admin".equals(currentUser.getUserType()) || "super_admin".equals(currentUser.getUserType()));
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
                <li><a href="${pageContext.request.contextPath}/profile" class="nav-link">Profile</a></li>
                <li><a href="${pageContext.request.contextPath}/settings" class="nav-link nav-icon-link active" title="Settings" aria-label="Settings"><i class="fas fa-cog"></i></a></li>
                <li><a href="${pageContext.request.contextPath}/<%= isAdmin ? "admin" : "dashboard" %>" class="nav-link"><%= isAdmin ? "Admin" : "Dashboard" %></a></li>
            </ul>
            <div class="nav-buttons">
                <span class="user-greeting">
                    <i class="fas fa-user-circle"></i>
                    <%= HtmlUtil.escape(currentUser.getFullName()) %>
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
        <section class="profile-header settings-hero">
            <div>
                <span class="settings-eyebrow"><i class="fas fa-shield-alt"></i> Account Security</span>
                <h1>Settings</h1>
                <p>Manage password security and account preferences for your MindWell profile.</p>
            </div>
            <div class="settings-hero-icon">
                <i class="fas fa-cog"></i>
            </div>
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

        <div class="settings-layout">
            <aside class="settings-summary-card">
                <div class="settings-avatar">
                    <i class="fas fa-user-circle"></i>
                </div>
                <h2><%= HtmlUtil.escape(currentUser.getFullName()) %></h2>
                <p><%= HtmlUtil.escape(currentUser.getEmail()) %></p>
                <div class="settings-summary-list">
                    <span><i class="fas fa-user-tag"></i> <%= HtmlUtil.escape(currentUser.getUserType()) %></span>
                    <span><i class="fas fa-check-circle"></i> <%= HtmlUtil.escape(currentUser.getAccountStatus()) %></span>
                    <span><i class="fas fa-map-marker-alt"></i> <%= HtmlUtil.escape(currentUser.getCity() != null ? currentUser.getCity() : "Not set") %></span>
                </div>
                <a href="${pageContext.request.contextPath}/profile" class="btn-secondary settings-profile-link">
                    <i class="fas fa-id-card"></i> Edit Profile
                </a>
            </aside>

            <section class="profile-panel settings-panel">
                <div class="settings-panel-header">
                    <div>
                        <h2><i class="fas fa-lock"></i> Change Password</h2>
                        <p>Use a strong password with at least 8 characters.</p>
                    </div>
                    <i class="fas fa-key settings-panel-icon"></i>
                </div>
                <form action="${pageContext.request.contextPath}/settings" method="POST" class="settings-form">
                    <div class="form-group">
                        <label for="currentPassword"><i class="fas fa-lock"></i> Current Password</label>
                        <input type="password" id="currentPassword" name="currentPassword" placeholder="Enter current password" required>
                    </div>
                    <div class="form-row">
                        <div class="form-group">
                            <label for="newPassword"><i class="fas fa-key"></i> New Password</label>
                            <input type="password" id="newPassword" name="newPassword" minlength="8" placeholder="Minimum 8 characters" required>
                        </div>
                        <div class="form-group">
                            <label for="confirmPassword"><i class="fas fa-check-circle"></i> Confirm Password</label>
                            <input type="password" id="confirmPassword" name="confirmPassword" minlength="8" placeholder="Repeat new password" required>
                        </div>
                    </div>
                    <button type="submit" class="btn-primary">
                        <i class="fas fa-key"></i> Update Password
                    </button>
                </form>
            </section>
        </div>
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
