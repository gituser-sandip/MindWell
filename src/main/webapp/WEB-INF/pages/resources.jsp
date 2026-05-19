<%@ page import="com.mindwell.model.UserModel" %>
<%@ page import="com.mindwell.util.HtmlUtil" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Resources - MindWell Nepal</title>
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
                <li><a href="${pageContext.request.contextPath}/home#professionals" class="nav-link">Professionals</a></li>
                <li><a href="${pageContext.request.contextPath}/resources" class="nav-link active">Resources</a></li>
                <li><a href="${pageContext.request.contextPath}/home#about" class="nav-link">About Us</a></li>
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

    <main class="resources-main">
        <section class="resources-hero-page">
            <h1>Resource Library</h1>
            <p>Practical mental health guides, self-care tools, and crisis support information for everyday life in Nepal.</p>
        </section>

        <section class="resource-section">
            <div class="resource-tools">
                <article class="resource-tool-card">
                    <i class="fas fa-phone-alt"></i>
                    <h3>Crisis Support</h3>
                    <p>If you or someone nearby may be in immediate danger, contact local emergency services or trusted support immediately.</p>
                    <strong>Helpline: 1166</strong>
                </article>
                <article class="resource-tool-card">
                    <i class="fas fa-calendar-check"></i>
                    <h3>Prepare for Therapy</h3>
                    <p>Write down your main concern, recent mood patterns, sleep changes, and what you hope will feel different after support.</p>
                </article>
                <article class="resource-tool-card">
                    <i class="fas fa-heartbeat"></i>
                    <h3>Daily Check-In</h3>
                    <p>Rate your mood, energy, stress, sleep, and social connection once a day to notice patterns before they become heavy.</p>
                </article>
            </div>
        </section>

        <section class="resource-section">
            <div class="section-header">
                <h2>Guides</h2>
                <p>Short reads for common concerns</p>
            </div>
            <div class="resources-grid">
                <article class="resource-card">
                    <div class="resource-category relationships">
                        <i class="fas fa-users"></i> RELATIONSHIPS
                    </div>
                    <h3>Building Stronger Community Bonds</h3>
                    <p>How family, friends, and community support can help recovery feel less lonely.</p>
                    <ul class="resource-list">
                        <li>Choose one trusted person for regular check-ins.</li>
                        <li>Be specific about what support helps you.</li>
                        <li>Respect privacy while accepting care.</li>
                    </ul>
                </article>

                <article class="resource-card">
                    <div class="resource-category selfcare">
                        <i class="fas fa-spa"></i> SELF-CARE
                    </div>
                    <h3>5 Daily Rituals for Inner Peace</h3>
                    <p>Small practices that support emotional regulation without needing special equipment.</p>
                    <ul class="resource-list">
                        <li>Three slow breaths before checking your phone.</li>
                        <li>A ten-minute walk after one meal.</li>
                        <li>Write one worry and one next step.</li>
                    </ul>
                </article>

                <article class="resource-card">
                    <div class="resource-category therapy">
                        <i class="fas fa-comments"></i> THERAPY
                    </div>
                    <h3>What to Expect in Your First Session</h3>
                    <p>Your counselor will ask about your concerns, history, safety, and goals. You do not have to explain everything perfectly.</p>
                    <ul class="resource-list">
                        <li>Bring questions about confidentiality.</li>
                        <li>Share only what feels manageable.</li>
                        <li>Ask how progress will be tracked.</li>
                    </ul>
                </article>

                <article class="resource-card featured">
                    <div class="resource-category mindfulness">
                        <i class="fas fa-brain"></i> MINDFULNESS
                    </div>
                    <h3>Understanding Anxiety in a Modern Nepal</h3>
                    <p>Changing work, study, family, and migration pressures can affect the body and mind. Anxiety is treatable, and support can start with small grounding steps.</p>
                    <ul class="resource-list">
                        <li>Name five things you can see.</li>
                        <li>Relax your jaw and shoulders.</li>
                        <li>Book support if worry interrupts daily life.</li>
                    </ul>
                </article>
            </div>
        </section>

        <section class="resource-section">
            <div class="section-header">
                <h2>Quick Tools</h2>
                <p>Simple exercises you can use today</p>
            </div>
            <div class="quick-tools-grid">
                <div class="quick-tool">
                    <h4><i class="fas fa-wind"></i> 4-4-6 Breathing</h4>
                    <p>Inhale for 4, hold for 4, exhale for 6. Repeat five times.</p>
                </div>
                <div class="quick-tool">
                    <h4><i class="fas fa-pen"></i> Thought Note</h4>
                    <p>Write the thought, the feeling, and one kinder alternative.</p>
                </div>
                <div class="quick-tool">
                    <h4><i class="fas fa-moon"></i> Sleep Reset</h4>
                    <p>Dim screens, reduce caffeine late in the day, and keep one consistent wake time.</p>
                </div>
            </div>
        </section>
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
        
        if (hamburger) {
            hamburger.addEventListener('click', () => {
                hamburger.classList.toggle('active');
                navMenu.classList.toggle('active');
            });
        }
    </script>
</body>
</html>
