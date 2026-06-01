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
                    <div class="resource-category selfcare">
                        <i class="fas fa-wind"></i> ANXIETY
                    </div>
                    <h3>Calming Anxiety During Study or Work Pressure</h3>
                    <p>Anxiety can feel like fast thoughts, tight breathing, stomach discomfort, or fear that something bad will happen. Start by slowing the body, then handle one task at a time.</p>
                    <ul class="resource-list">
                        <li>Use 4-4-6 breathing: inhale 4, hold 4, exhale 6.</li>
                        <li>Break work into one 20-minute task.</li>
                        <li>Reduce caffeine if it increases panic symptoms.</li>
                        <li>Talk to a counselor if anxiety affects sleep, study, work, or relationships.</li>
                    </ul>
                </article>

                <article class="resource-card">
                    <div class="resource-category mindfulness">
                        <i class="fas fa-cloud-rain"></i> LOW MOOD
                    </div>
                    <h3>What to Do When You Feel Low for Many Days</h3>
                    <p>Low mood is not laziness. It can reduce energy, interest, appetite, sleep, and hope. Gentle routine and support can help you move through it safely.</p>
                    <ul class="resource-list">
                        <li>Keep a simple wake-up and sleep time.</li>
                        <li>Eat something small even when appetite is low.</li>
                        <li>Spend ten minutes in sunlight or fresh air.</li>
                        <li>Ask for urgent help if you feel unsafe or think about self-harm.</li>
                    </ul>
                </article>

                <article class="resource-card">
                    <div class="resource-category therapy">
                        <i class="fas fa-comments"></i> THERAPY
                    </div>
                    <h3>What to Expect in Your First Session</h3>
                    <p>Your first counseling session is a conversation, not an exam. The counselor will try to understand your concern, background, safety, and goals.</p>
                    <ul class="resource-list">
                        <li>Bring questions about confidentiality.</li>
                        <li>Share only what feels manageable.</li>
                        <li>Ask how progress will be tracked.</li>
                        <li>Tell the counselor if a suggestion does not fit your culture, family, or routine.</li>
                    </ul>
                </article>

                <article class="resource-card featured">
                    <div class="resource-category relationships">
                        <i class="fas fa-users"></i> FAMILY
                    </div>
                    <h3>Talking About Mental Health With Family</h3>
                    <p>In many families, mental health is hard to discuss. A calm, simple explanation works better than trying to convince everyone at once.</p>
                    <ul class="resource-list">
                        <li>Choose one trusted family member first.</li>
                        <li>Use clear words: "I am struggling and need support."</li>
                        <li>Explain what helps: listening, privacy, or help booking counseling.</li>
                        <li>Avoid arguing when someone reacts with confusion at first.</li>
                    </ul>
                </article>

                <article class="resource-card">
                    <div class="resource-category selfcare">
                        <i class="fas fa-bed"></i> SLEEP
                    </div>
                    <h3>Improving Sleep When Your Mind Feels Busy</h3>
                    <p>Sleep problems often become worse when we force ourselves to sleep. A regular wind-down routine teaches the body that night is safe.</p>
                    <ul class="resource-list">
                        <li>Keep phones away for the last 30 minutes.</li>
                        <li>Write tomorrow's worries on paper before bed.</li>
                        <li>Use the bed mainly for sleep, not scrolling.</li>
                        <li>Contact a professional if poor sleep continues for weeks.</li>
                    </ul>
                </article>

                <article class="resource-card">
                    <div class="resource-category therapy">
                        <i class="fas fa-hands-helping"></i> CRISIS
                    </div>
                    <h3>Helping a Friend Who May Be in Crisis</h3>
                    <p>If someone talks about self-harm, hopelessness, or disappearing, take it seriously. You do not need perfect words; staying present matters.</p>
                    <ul class="resource-list">
                        <li>Ask directly if they feel unsafe.</li>
                        <li>Stay with them or connect them with a trusted adult or emergency support.</li>
                        <li>Remove immediate danger if possible.</li>
                        <li>Do not promise secrecy when safety is at risk.</li>
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
