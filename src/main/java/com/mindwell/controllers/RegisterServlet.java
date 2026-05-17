package com.mindwell.controllers;

import com.mindwell.model.CounselorModel;
import com.mindwell.model.UserModel;
import com.mindwell.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    
    /**
	 * 
	 */
	private static final long serialVersionUID = -6007438245961155888L;
	private UserService userService = new UserService();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        UserModel user = (session != null) ? (UserModel) session.getAttribute("user") : null;
        if (user != null) {
            if ("admin".equals(user.getUserType()) || "super_admin".equals(user.getUserType())) {
                response.sendRedirect("admin");
            } else {
                response.sendRedirect("dashboard");
            }
            return;
        }
        request.getRequestDispatcher("/WEB-INF/pages/register.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String phone = request.getParameter("phone");
        String city = request.getParameter("city");
        String accountType = request.getParameter("accountType");

        if (isBlank(fullName) || isBlank(email) || isBlank(password)) {
            request.setAttribute("errorMessage", "Full name, email, and password are required.");
            request.getRequestDispatcher("/WEB-INF/pages/register.jsp").forward(request, response);
            return;
        }

        if (password.length() < 8) {
            request.setAttribute("errorMessage", "Password must be at least 8 characters.");
            request.getRequestDispatcher("/WEB-INF/pages/register.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Passwords do not match.");
            request.getRequestDispatcher("/WEB-INF/pages/register.jsp").forward(request, response);
            return;
        }
        
        UserModel user = new UserModel(fullName.trim(), email.trim().toLowerCase(), password, trimToNull(phone), trimToNull(city));
        user.setRequestedUserType("counselor".equals(accountType) ? "counselor" : "user");

        CounselorModel counselorRequest = null;
        if ("counselor".equals(user.getRequestedUserType())) {
            counselorRequest = buildCounselorRequest(request);
            if (counselorRequest == null) {
                request.setAttribute("errorMessage", "Counselor requests need specialization, experience, bio, and consultation fee.");
                request.getRequestDispatcher("/WEB-INF/pages/register.jsp").forward(request, response);
                return;
            }
        }

        boolean isRegistered = userService.registerUser(user, counselorRequest);
        
        if (isRegistered) {
            request.setAttribute("successMessage", "Registration request submitted. An admin will review your account before login.");
            request.getRequestDispatcher("/WEB-INF/pages/login.jsp").forward(request, response);
        } else {
            request.setAttribute("errorMessage", "Registration failed. Email might already exist.");
            request.getRequestDispatcher("/WEB-INF/pages/register.jsp").forward(request, response);
        }
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    private String trimToNull(String value) {
        if (value == null || value.trim().isEmpty()) {
            return null;
        }
        return value.trim();
    }

    private CounselorModel buildCounselorRequest(jakarta.servlet.http.HttpServletRequest request) {
        String specialization = request.getParameter("specialization");
        String experienceYearsValue = request.getParameter("experienceYears");
        String bio = request.getParameter("bio");
        String consultationFeeValue = request.getParameter("consultationFee");

        if (isBlank(specialization) || isBlank(experienceYearsValue) || isBlank(bio) || isBlank(consultationFeeValue)) {
            return null;
        }

        try {
            int experienceYears = Integer.parseInt(experienceYearsValue);
            double consultationFee = Double.parseDouble(consultationFeeValue);
            if (experienceYears < 0 || consultationFee < 0) {
                return null;
            }

            CounselorModel counselor = new CounselorModel();
            counselor.setSpecialization(specialization.trim());
            counselor.setExperienceYears(experienceYears);
            counselor.setBio(bio.trim());
            counselor.setConsultationFee(consultationFee);
            return counselor;
        } catch (NumberFormatException e) {
            return null;
        }
    }
}
