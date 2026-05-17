package com.mindwell.controllers;

import com.mindwell.model.UserModel;
import com.mindwell.service.BookingService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@WebServlet("/cancelBooking")
public class CancelBookingServlet extends HttpServlet {
    
    /**
	 * 
	 */
	private static final long serialVersionUID = 2323066862914961155L;
	private BookingService bookingService = new BookingService();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendRedirect("dashboard");
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

        int bookingId;
        try {
            bookingId = Integer.parseInt(request.getParameter("bookingId"));
        } catch (NumberFormatException e) {
            redirectWithMessage(response, "error", "Invalid booking request.");
            return;
        }

        boolean cancelled = bookingService.cancelBooking(bookingId, user.getUserId());
        if (cancelled) {
            redirectWithMessage(response, "success", "Booking cancelled successfully!");
        } else {
            redirectWithMessage(response, "error", "Unable to cancel this booking.");
        }
    }

    private void redirectWithMessage(HttpServletResponse response, String type, String message) throws IOException {
        response.sendRedirect("dashboard?" + type + "=" + URLEncoder.encode(message, StandardCharsets.UTF_8));
    }
}
