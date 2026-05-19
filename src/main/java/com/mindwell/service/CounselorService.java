package com.mindwell.service;

import com.mindwell.config.DBConfig;
import com.mindwell.model.CounselorModel;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CounselorService {
    
    public List<CounselorModel> getAllCounselors() {
        List<CounselorModel> counselors = new ArrayList<>();
        String sql = "SELECT c.*, u.full_name, u.email, u.phone FROM counselors c JOIN users u ON c.user_id = u.user_id WHERE c.is_available = TRUE AND c.is_verified = TRUE AND u.account_status = 'approved'";
        
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                counselors.add(mapCounselor(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return counselors;
    }

    public List<CounselorModel> getAllCounselorProfiles() {
        List<CounselorModel> counselors = new ArrayList<>();
        String sql = "SELECT c.*, u.full_name, u.email, u.phone FROM counselors c JOIN users u ON c.user_id = u.user_id ORDER BY c.created_at DESC";

        try (Connection conn = DBConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                counselors.add(mapCounselor(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return counselors;
    }

    public boolean confirmCounselor(int counselorId) {
        String sql = "UPDATE counselors SET is_verified = TRUE, is_available = TRUE WHERE counselor_id = ?";

        try (Connection conn = DBConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, counselorId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean suspendCounselor(int counselorId) {
        String sql = "UPDATE counselors SET is_available = FALSE WHERE counselor_id = ?";

        try (Connection conn = DBConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, counselorId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public CounselorModel getCounselorByUserId(int userId) {
        String sql = "SELECT c.*, u.full_name, u.email, u.phone FROM counselors c JOIN users u ON c.user_id = u.user_id WHERE c.user_id = ?";

        try (Connection conn = DBConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapCounselor(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateCounselorProfile(CounselorModel counselor) {
        String sql = "UPDATE counselors SET specialization = ?, experience_years = ?, bio = ?, consultation_fee = ? WHERE user_id = ?";

        try (Connection conn = DBConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, counselor.getSpecialization());
            pstmt.setInt(2, counselor.getExperienceYears());
            pstmt.setString(3, counselor.getBio());
            pstmt.setDouble(4, counselor.getConsultationFee());
            pstmt.setInt(5, counselor.getUserId());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private CounselorModel mapCounselor(ResultSet rs) throws SQLException {
        CounselorModel counselor = new CounselorModel();
        counselor.setCounselorId(rs.getInt("counselor_id"));
        counselor.setUserId(rs.getInt("user_id"));
        counselor.setFullName(rs.getString("full_name"));
        counselor.setEmail(rs.getString("email"));
        counselor.setPhone(rs.getString("phone"));
        counselor.setSpecialization(rs.getString("specialization"));
        counselor.setExperienceYears(rs.getInt("experience_years"));
        counselor.setBio(rs.getString("bio"));
        counselor.setConsultationFee(rs.getDouble("consultation_fee"));
        counselor.setAvailable(rs.getBoolean("is_available"));
        counselor.setVerified(rs.getBoolean("is_verified"));
        return counselor;
    }
}
