package com.mindwell.controllers;

import com.mindwell.model.UserModel;
import com.mindwell.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    
    /**
	 * 
	 */
	private static final long serialVersionUID = -8486235416133404462L;
	private UserService userService = new UserService();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        UserModel user = (session != null) ? (UserModel) session.getAttribute("user") : null;
        if (user != null) {
            redirectLoggedInUser(response, user);
            return;
        }
        request.getRequestDispatcher("/WEB-INF/pages/login.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Please enter both email and password");
            request.getRequestDispatcher("/WEB-INF/pages/login.jsp").forward(request, response);
            return;
        }
        
        UserModel user = userService.loginUser(email.trim().toLowerCase(), password);
        
        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            redirectLoggedInUser(response, user);
        } else {
            request.setAttribute("errorMessage", "Invalid credentials or account is waiting for admin approval.");
            request.getRequestDispatcher("/WEB-INF/pages/login.jsp").forward(request, response);
        }
    }

    private void redirectLoggedInUser(HttpServletResponse response, UserModel user) throws IOException {
        if ("admin".equals(user.getUserType()) || "super_admin".equals(user.getUserType())) {
            response.sendRedirect("admin");
        } else {
            response.sendRedirect("dashboard");
        }
    }
}
