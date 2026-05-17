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
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@WebServlet("/admin/action")
public class AdminActionServlet extends HttpServlet {
    private static final long serialVersionUID = 2278733567440682105L;

    private UserService userService = new UserService();
    private CounselorService counselorService = new CounselorService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        UserModel admin = getLoggedInUser(request);
        if (!isAdmin(admin)) {
            response.sendRedirect("../login");
            return;
        }

        String action = request.getParameter("action");
        boolean success = false;

        try {
            if ("approveUser".equals(action)) {
                success = userService.approveUser(Integer.parseInt(request.getParameter("userId")));
            } else if ("rejectUser".equals(action)) {
                success = userService.rejectUser(Integer.parseInt(request.getParameter("userId")));
            } else if ("disableUser".equals(action)) {
                success = userService.disableUser(Integer.parseInt(request.getParameter("userId")));
            } else if ("confirmCounselor".equals(action)) {
                success = counselorService.confirmCounselor(Integer.parseInt(request.getParameter("counselorId")));
            } else if ("suspendCounselor".equals(action)) {
                success = counselorService.suspendCounselor(Integer.parseInt(request.getParameter("counselorId")));
            } else if ("makeAdmin".equals(action) && "super_admin".equals(admin.getUserType())) {
                success = userService.makeAdmin(Integer.parseInt(request.getParameter("userId")));
            } else if ("removeAdmin".equals(action) && "super_admin".equals(admin.getUserType())) {
                success = userService.removeAdmin(Integer.parseInt(request.getParameter("userId")));
            }
        } catch (NumberFormatException e) {
            success = false;
        }

        String message = success ? "System updated successfully." : "Unable to complete that admin action.";
        response.sendRedirect("../admin?" + (success ? "success=" : "error=") + URLEncoder.encode(message, StandardCharsets.UTF_8));
    }

    private UserModel getLoggedInUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return (session != null) ? (UserModel) session.getAttribute("user") : null;
    }

    private boolean isAdmin(UserModel user) {
        return user != null && ("admin".equals(user.getUserType()) || "super_admin".equals(user.getUserType()));
    }
}
