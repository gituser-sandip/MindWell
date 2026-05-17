package com.mindwell.model;

public class BookingModel {
    private int bookingId;
    private int userId;
    private int counselorId;
    private String bookingDate;
    private String bookingTime;
    private String status;
    private String message;
    private String createdAt;
    private String counselorName;
    private String counselorSpecialization;
    
    public BookingModel() {
        this.status = "pending";
    }
    
    public BookingModel(int userId, int counselorId, String bookingDate, String bookingTime, String message) {
        this.userId = userId;
        this.counselorId = counselorId;
        this.bookingDate = bookingDate;
        this.bookingTime = bookingTime;
        this.message = message;
        this.status = "pending";
    }
    
    public int getBookingId() { return bookingId; }
    public void setBookingId(int bookingId) { this.bookingId = bookingId; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public int getCounselorId() { return counselorId; }
    public void setCounselorId(int counselorId) { this.counselorId = counselorId; }
    public String getBookingDate() { return bookingDate; }
    public void setBookingDate(String bookingDate) { this.bookingDate = bookingDate; }
    public String getBookingTime() { return bookingTime; }
    public void setBookingTime(String bookingTime) { this.bookingTime = bookingTime; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }
    public String getCreatedAt() { return createdAt; }
    public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }
    public String getCounselorName() { return counselorName; }
    public void setCounselorName(String counselorName) { this.counselorName = counselorName; }
    public String getCounselorSpecialization() { return counselorSpecialization; }
    public void setCounselorSpecialization(String counselorSpecialization) { this.counselorSpecialization = counselorSpecialization; }
}