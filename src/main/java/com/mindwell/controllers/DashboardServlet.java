package com.mindwell.controllers;

import com.mindwell.model.BookingModel;
import com.mindwell.model.UserModel;
import com.mindwell.service.BookingService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {
    
    /**
	 * 
	 */
	private static final long serialVersionUID = -8489945401562361147L;
	private BookingService bookingService = new BookingService();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        UserModel user = (session != null) ? (UserModel) session.getAttribute("user") : null;
        
        if (user == null) {
            response.sendRedirect("login");
            return;
        }
        
        List<BookingModel> bookings = bookingService.getUserBookings(user.getUserId());
        request.setAttribute("bookings", bookings);
        request.getRequestDispatcher("/WEB-INF/pages/dashboard.jsp").forward(request, response);
    }
}