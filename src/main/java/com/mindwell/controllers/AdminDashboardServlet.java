package com.mindwell.controllers;

import com.mindwell.model.UserModel;
import com.mindwell.service.CounselorService;
import com.mindwell.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/admin")
public class AdminDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 6074162443358779124L;

    private UserService userService = new UserService();
    private CounselorService counselorService = new CounselorService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        UserModel admin = getLoggedInUser(request);
        if (!isAdmin(admin)) {
            response.sendRedirect("login");
            return;
        }

        request.setAttribute("users", userService.getAllUsers());
        request.setAttribute("counselors", counselorService.getAllCounselorProfiles());
        request.setAttribute("isSuperAdmin", "super_admin".equals(admin.getUserType()));
        request.getRequestDispatcher("/WEB-INF/pages/admin.jsp").forward(request, response);
    }

    private UserModel getLoggedInUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return (session != null) ? (UserModel) session.getAttribute("user") : null;
    }

    private boolean isAdmin(UserModel user) {
        return user != null && ("admin".equals(user.getUserType()) || "super_admin".equals(user.getUserType()));
    }
}
