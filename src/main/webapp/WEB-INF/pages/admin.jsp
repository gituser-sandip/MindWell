<%@ page import="java.util.List" %>
<%@ page import="com.mindwell.model.UserModel" %>
<%@ page import="com.mindwell.model.CounselorModel" %>
<%@ page import="com.mindwell.util.HtmlUtil" %>
<%!
    private String requestedRole(UserModel user) {
        try {
            return String.valueOf(UserModel.class.getMethod("getRequestedUserType").invoke(user));
        } catch (Exception e) {
            return user.getUserType();
        }
    }

    private String accountStatus(UserModel user) {
        try {
            return String.valueOf(UserModel.class.getMethod("getAccountStatus").invoke(user));
        } catch (Exception e) {
            return "approved";
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin - MindWell Nepal</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <nav class="navbar">
        <div class="nav-container">
            <div class="nav-logo">
                <a href="${pageContext.request.contextPath}/admin">
                    <h1>MindWell Nepal</h1>
                    <span class="logo-tagline">Admin Console</span>
                </a>
            </div>
            <ul class="nav-menu">
                <li><a href="${pageContext.request.contextPath}/admin" class="nav-link active">Admin</a></li>
                <li><a href="${pageContext.request.contextPath}/home" class="nav-link">Site</a></li>
                <li><a href="${pageContext.request.contextPath}/dashboard" class="nav-link">Dashboard</a></li>
            </ul>
            <div class="nav-buttons">
                <a href="${pageContext.request.contextPath}/logout" class="btn-logout">
                    <i class="fas fa-sign-out-alt"></i> Logout
                </a>
            </div>
        </div>
    </nav>

    <main class="dashboard-main admin-main">
        <div class="dashboard-header">
            <div class="dashboard-welcome">
                <h1>Admin Console</h1>
                <p>Review registrations, confirm counselors, and manage system access.</p>
            </div>
        </div>

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

        <section class="bookings-section">
            <h2><i class="fas fa-user-clock"></i> Registration Requests</h2>
            <div class="bookings-table-container">
                <table class="bookings-table">
                    <thead>
                        <tr>
                            <th>Name</th>
                            <th>Email</th>
                            <th>Requested Role</th>
                            <th>Status</th>
                            <th>Registered</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            @SuppressWarnings("unchecked")
                            List<UserModel> users = (List<UserModel>) request.getAttribute("users");
                            boolean hasPending = false;
                            if (users != null) {
                                for (UserModel managedUser : users) {
                                    if ("pending".equals(accountStatus(managedUser))) {
                                        hasPending = true;
                        %>
                            <tr>
                                <td><strong><%= HtmlUtil.escape(managedUser.getFullName()) %></strong></td>
                                <td><%= HtmlUtil.escape(managedUser.getEmail()) %></td>
                                <td><%= HtmlUtil.escape(requestedRole(managedUser)) %></td>
                                <td><span class="status-badge status-pending">PENDING</span></td>
                                <td><%= HtmlUtil.escape(managedUser.getCreatedAt()) %></td>
                                <td class="admin-actions">
                                    <form action="${pageContext.request.contextPath}/admin/action" method="POST">
                                        <input type="hidden" name="action" value="approveUser">
                                        <input type="hidden" name="userId" value="<%= managedUser.getUserId() %>">
                                        <button type="submit" class="btn-confirm-small">Approve</button>
                                    </form>
                                    <form action="${pageContext.request.contextPath}/admin/action" method="POST">
                                        <input type="hidden" name="action" value="rejectUser">
                                        <input type="hidden" name="userId" value="<%= managedUser.getUserId() %>">
                                        <button type="submit" class="btn-cancel">Reject</button>
                                    </form>
                                </td>
                            </tr>
                        <%
                                    }
                                }
                            }
                            if (!hasPending) {
                        %>
                            <tr><td colspan="6" class="no-data">No pending registration requests.</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </section>

        <section class="bookings-section">
            <h2><i class="fas fa-user-md"></i> Counselor Confirmation</h2>
            <div class="bookings-table-container">
                <table class="bookings-table">
                    <thead>
                        <tr>
                            <th>Counselor</th>
                            <th>Specialization</th>
                            <th>Experience</th>
                            <th>Fee</th>
                            <th>Status</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            @SuppressWarnings("unchecked")
                            List<CounselorModel> counselors = (List<CounselorModel>) request.getAttribute("counselors");
                            if (counselors != null && !counselors.isEmpty()) {
                                for (CounselorModel counselor : counselors) {
                        %>
                            <tr>
                                <td>
                                    <strong><%= HtmlUtil.escape(counselor.getFullName()) %></strong><br>
                                    <span class="admin-muted"><%= HtmlUtil.escape(counselor.getEmail()) %></span>
                                </td>
                                <td><%= HtmlUtil.escape(counselor.getSpecialization()) %></td>
                                <td><%= counselor.getExperienceYears() %> years</td>
                                <td>Rs. <%= counselor.getConsultationFee() %></td>
                                <td>
                                    <% if (counselor.isVerified() && counselor.isAvailable()) { %>
                                        <span class="status-badge status-confirmed">CONFIRMED</span>
                                    <% } else if (counselor.isVerified()) { %>
                                        <span class="status-badge status-cancelled">SUSPENDED</span>
                                    <% } else { %>
                                        <span class="status-badge status-pending">WAITING</span>
                                    <% } %>
                                </td>
                                <td class="admin-actions">
                                    <form action="${pageContext.request.contextPath}/admin/action" method="POST">
                                        <input type="hidden" name="action" value="confirmCounselor">
                                        <input type="hidden" name="counselorId" value="<%= counselor.getCounselorId() %>">
                                        <button type="submit" class="btn-confirm-small">Confirm</button>
                                    </form>
                                    <form action="${pageContext.request.contextPath}/admin/action" method="POST">
                                        <input type="hidden" name="action" value="suspendCounselor">
                                        <input type="hidden" name="counselorId" value="<%= counselor.getCounselorId() %>">
                                        <button type="submit" class="btn-cancel">Suspend</button>
                                    </form>
                                </td>
                            </tr>
                        <%
                                }
                            } else {
                        %>
                            <tr><td colspan="6" class="no-data">No counselor profiles yet.</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </section>

        <section class="bookings-section">
            <h2><i class="fas fa-users-cog"></i> All Users</h2>
            <div class="bookings-table-container">
                <table class="bookings-table">
                    <thead>
                        <tr>
                            <th>Name</th>
                            <th>Email</th>
                            <th>Role</th>
                            <th>Status</th>
                            <th>Requested</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (users != null && !users.isEmpty()) {
                            Boolean isSuperAdmin = (Boolean) request.getAttribute("isSuperAdmin");
                            for (UserModel managedUser : users) { %>
                            <tr>
                                <td><strong><%= HtmlUtil.escape(managedUser.getFullName()) %></strong></td>
                                <td><%= HtmlUtil.escape(managedUser.getEmail()) %></td>
                                <td><%= HtmlUtil.escape(managedUser.getUserType()) %></td>
                                <td><span class="status-badge status-<%= HtmlUtil.escapeAttribute(accountStatus(managedUser)) %>"><%= HtmlUtil.escape(accountStatus(managedUser).toUpperCase()) %></span></td>
                                <td><%= HtmlUtil.escape(requestedRole(managedUser)) %></td>
                                <td class="admin-actions">
                                    <% if (Boolean.TRUE.equals(isSuperAdmin) && !"super_admin".equals(managedUser.getUserType())) { %>
                                        <% if (!"admin".equals(managedUser.getUserType())) { %>
                                            <form action="${pageContext.request.contextPath}/admin/action" method="POST">
                                                <input type="hidden" name="action" value="makeAdmin">
                                                <input type="hidden" name="userId" value="<%= managedUser.getUserId() %>">
                                                <button type="submit" class="btn-secondary-small">Make Admin</button>
                                            </form>
                                        <% } else { %>
                                            <form action="${pageContext.request.contextPath}/admin/action" method="POST">
                                                <input type="hidden" name="action" value="removeAdmin">
                                                <input type="hidden" name="userId" value="<%= managedUser.getUserId() %>">
                                                <button type="submit" class="btn-secondary-small">Remove Admin</button>
                                            </form>
                                        <% } %>
                                    <% } %>
                                    <% if (!"super_admin".equals(managedUser.getUserType())) { %>
                                        <form action="${pageContext.request.contextPath}/admin/action" method="POST">
                                            <input type="hidden" name="action" value="disableUser">
                                            <input type="hidden" name="userId" value="<%= managedUser.getUserId() %>">
                                            <button type="submit" class="btn-cancel">Disable</button>
                                        </form>
                                    <% } %>
                                </td>
                            </tr>
                        <% }
                        } else { %>
                            <tr><td colspan="6" class="no-data">No users found.</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </section>
    </main>
</body>
</html>
