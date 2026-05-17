<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>500 - Server Error | MindWell Nepal</title>
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
                <li><a href="${pageContext.request.contextPath}/services">Services</a></li>
                <li><a href="${pageContext.request.contextPath}/about">About Us</a></li>
            </ul>
        </nav>
    </header>
    
    <main class="auth-container">
        <div class="auth-box" style="text-align: center;">
            <h2 style="font-size: 72px; color: #667eea;">500</h2>
            <h3>Something Went Wrong</h3>
            <p style="margin: 20px 0;">We're experiencing technical difficulties. Please try again later.</p>
            <a href="${pageContext.request.contextPath}/home" class="btn-primary">Return to Home</a>
        </div>
    </main>
    
    <footer>
        <p>&copy; 2024 MindWell Nepal. All rights reserved.</p>
    </footer>
</body>
</html>