package com.mindwell.controllers;

import com.mindwell.model.CounselorModel;
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

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {
    private static final long serialVersionUID = -1952824781866531780L;

    private UserService userService = new UserService();
    private CounselorService counselorService = new CounselorService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        UserModel user = getLoggedInUser(request);
        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        request.setAttribute("userProfile", userService.getUserById(user.getUserId()));
        request.setAttribute("counselorProfile", counselorService.getCounselorByUserId(user.getUserId()));
        request.getRequestDispatcher("/WEB-INF/pages/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        UserModel currentUser = (session != null) ? (UserModel) session.getAttribute("user") : null;
        if (currentUser == null) {
            response.sendRedirect("login");
            return;
        }

        String fullName = request.getParameter("fullName");
        if (fullName == null || fullName.trim().isEmpty()) {
            forwardWithMessage(request, response, currentUser, "Full name is required.", false);
            return;
        }

        UserModel updatedUser = userService.getUserById(currentUser.getUserId());
        updatedUser.setFullName(fullName.trim());
        updatedUser.setPhone(trimToNull(request.getParameter("phone")));
        updatedUser.setCity(trimToNull(request.getParameter("city")));

        boolean updated = userService.updateProfile(updatedUser);

        CounselorModel counselor = counselorService.getCounselorByUserId(currentUser.getUserId());
        if (counselor != null) {
            CounselorModel updatedCounselor = buildCounselorProfile(request, currentUser.getUserId());
            if (updatedCounselor == null) {
                forwardWithMessage(request, response, updatedUser, "Counselor profile fields are invalid.", false);
                return;
            }
            updated = counselorService.updateCounselorProfile(updatedCounselor) && updated;
        }

        UserModel refreshedUser = userService.getUserById(currentUser.getUserId());
        session.setAttribute("user", refreshedUser);
        forwardWithMessage(request, response, refreshedUser,
                updated ? "Profile updated successfully." : "Unable to update profile.", updated);
    }

    private void forwardWithMessage(HttpServletRequest request, HttpServletResponse response, UserModel user,
            String message, boolean success) throws ServletException, IOException {
        request.setAttribute(success ? "successMessage" : "errorMessage", message);
        request.setAttribute("userProfile", user);
        request.setAttribute("counselorProfile", counselorService.getCounselorByUserId(user.getUserId()));
        request.getRequestDispatcher("/WEB-INF/pages/profile.jsp").forward(request, response);
    }

    private CounselorModel buildCounselorProfile(HttpServletRequest request, int userId) {
        try {
            String specialization = request.getParameter("specialization");
            String bio = request.getParameter("bio");
            int experienceYears = Integer.parseInt(request.getParameter("experienceYears"));
            double consultationFee = Double.parseDouble(request.getParameter("consultationFee"));

            if (specialization == null || specialization.trim().isEmpty() || bio == null || bio.trim().isEmpty()
                    || experienceYears < 0 || consultationFee < 0) {
                return null;
            }

            CounselorModel counselor = new CounselorModel();
            counselor.setUserId(userId);
            counselor.setSpecialization(specialization.trim());
            counselor.setExperienceYears(experienceYears);
            counselor.setBio(bio.trim());
            counselor.setConsultationFee(consultationFee);
            return counselor;
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private String trimToNull(String value) {
        if (value == null || value.trim().isEmpty()) {
            return null;
        }
        return value.trim();
    }

    private UserModel getLoggedInUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return (session != null) ? (UserModel) session.getAttribute("user") : null;
    }
}
