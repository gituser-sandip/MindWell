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

@WebServlet("/settings")
public class SettingsServlet extends HttpServlet {
    private static final long serialVersionUID = 6016743733459859978L;

    private UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        UserModel user = getLoggedInUser(request);
        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        request.getRequestDispatcher("/WEB-INF/pages/settings.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        UserModel user = getLoggedInUser(request);
        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (isBlank(currentPassword) || isBlank(newPassword) || isBlank(confirmPassword)) {
            request.setAttribute("errorMessage", "All password fields are required.");
        } else if (newPassword.length() < 8) {
            request.setAttribute("errorMessage", "New password must be at least 8 characters.");
        } else if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "New passwords do not match.");
        } else if (userService.changePassword(user.getUserId(), currentPassword, newPassword)) {
            request.setAttribute("successMessage", "Password changed successfully.");
        } else {
            request.setAttribute("errorMessage", "Current password is incorrect.");
        }

        request.getRequestDispatcher("/WEB-INF/pages/settings.jsp").forward(request, response);
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    private UserModel getLoggedInUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return (session != null) ? (UserModel) session.getAttribute("user") : null;
    }
}
