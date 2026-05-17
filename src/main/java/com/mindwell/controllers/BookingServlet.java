package com.mindwell.controllers;

import com.mindwell.model.BookingModel;
import com.mindwell.model.UserModel;
import com.mindwell.service.BookingService;
import com.mindwell.service.CounselorService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeParseException;

@WebServlet("/booking")
public class BookingServlet extends HttpServlet {
    
    /**
	 * 
	 */
	private static final long serialVersionUID = 4253328376277216616L;
	private BookingService bookingService = new BookingService();
    private CounselorService counselorService = new CounselorService();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        UserModel user = (session != null) ? (UserModel) session.getAttribute("user") : null;
        
        if (user == null) {
            response.sendRedirect("login");
            return;
        }
        
        request.setAttribute("counselors", counselorService.getAllCounselors());
        request.getRequestDispatcher("/WEB-INF/pages/booking.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        UserModel user = (session != null) ? (UserModel) session.getAttribute("user") : null;
        
        if (user == null) {
            response.sendRedirect("login");
            return;
        }
        
        int counselorId;
        try {
            counselorId = Integer.parseInt(request.getParameter("counselorId"));
        } catch (NumberFormatException e) {
            showBookingError(request, response, "Please select a valid counselor.");
            return;
        }

        String bookingDate = request.getParameter("bookingDate");
        String bookingTime = request.getParameter("bookingTime");
        String message = request.getParameter("message");

        if (!isValidBookingDate(bookingDate)) {
            showBookingError(request, response, "Please select today or a future date.");
            return;
        }

        if (!isValidBookingTime(bookingTime)) {
            showBookingError(request, response, "Please select a valid appointment time.");
            return;
        }

        if (message != null && message.length() > 1000) {
            showBookingError(request, response, "Message must be 1000 characters or less.");
            return;
        }
        
        BookingModel booking = new BookingModel(user.getUserId(), counselorId, bookingDate, bookingTime, message);
        boolean isBooked = bookingService.createBooking(booking);
        
        if (isBooked) {
            response.sendRedirect("dashboard?success=" + URLEncoder.encode("Booking confirmed successfully!", StandardCharsets.UTF_8));
        } else {
            showBookingError(request, response, "Something went wrong. Please try again.");
        }
    }

    private void showBookingError(HttpServletRequest request, HttpServletResponse response, String message)
            throws ServletException, IOException {
        request.setAttribute("errorMessage", message);
        request.setAttribute("counselors", counselorService.getAllCounselors());
        request.getRequestDispatcher("/WEB-INF/pages/booking.jsp").forward(request, response);
    }

    private boolean isValidBookingDate(String value) {
        try {
            LocalDate date = LocalDate.parse(value);
            return !date.isBefore(LocalDate.now());
        } catch (DateTimeParseException | NullPointerException e) {
            return false;
        }
    }

    private boolean isValidBookingTime(String value) {
        try {
            LocalTime time = LocalTime.parse(value);
            return !time.isBefore(LocalTime.of(9, 0)) && !time.isAfter(LocalTime.of(17, 0));
        } catch (DateTimeParseException | NullPointerException e) {
            return false;
        }
    }
}
