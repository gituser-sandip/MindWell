package com.mindwell.service;

import com.mindwell.config.DBConfig;
import com.mindwell.model.BookingModel;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BookingService {
    
    public boolean createBooking(BookingModel booking) {
        String sql = "INSERT INTO bookings (user_id, counselor_id, booking_date, booking_time, message, status) VALUES (?, ?, ?, ?, ?, 'pending')";
        
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, booking.getUserId());
            pstmt.setInt(2, booking.getCounselorId());
            pstmt.setDate(3, Date.valueOf(booking.getBookingDate()));
            pstmt.setTime(4, Time.valueOf(booking.getBookingTime()));
            pstmt.setString(5, booking.getMessage());
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public List<BookingModel> getUserBookings(int userId) {
        List<BookingModel> bookings = new ArrayList<>();
        String sql = "SELECT b.*, u.full_name as counselor_name, c.specialization as counselor_specialization " +
                    "FROM bookings b " +
                    "JOIN counselors c ON b.counselor_id = c.counselor_id " +
                    "JOIN users u ON c.user_id = u.user_id " +
                    "WHERE b.user_id = ? ORDER BY b.booking_date DESC";
        
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                BookingModel booking = new BookingModel();
                booking.setBookingId(rs.getInt("booking_id"));
                booking.setUserId(rs.getInt("user_id"));
                booking.setCounselorId(rs.getInt("counselor_id"));
                booking.setBookingDate(rs.getString("booking_date"));
                booking.setBookingTime(rs.getString("booking_time"));
                booking.setStatus(rs.getString("status"));
                booking.setMessage(rs.getString("message"));
                booking.setCounselorName(rs.getString("counselor_name"));
                booking.setCounselorSpecialization(rs.getString("counselor_specialization"));
                bookings.add(booking);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookings;
    }
    
    public boolean cancelBooking(int bookingId, int userId) {
        String sql = "UPDATE bookings SET status = 'cancelled' WHERE booking_id = ? AND user_id = ? AND status = 'pending'";
        
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, bookingId);
            pstmt.setInt(2, userId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
