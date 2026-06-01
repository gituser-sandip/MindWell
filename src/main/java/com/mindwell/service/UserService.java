package com.mindwell.service;

import com.mindwell.config.DBConfig;
import com.mindwell.model.CounselorModel;
import com.mindwell.model.UserModel;
import com.mindwell.util.PasswordUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserService {
    
    public boolean registerUser(UserModel user) {
        return registerUser(user, null);
    }

    public boolean registerUser(UserModel user, CounselorModel counselorRequest) {
        String userSql = "INSERT INTO users (full_name, email, password, phone, city, user_type, requested_user_type, account_status) VALUES (?, ?, ?, ?, ?, 'user', ?, ?)";
        String counselorSql = "INSERT INTO counselors (user_id, specialization, experience_years, bio, consultation_fee, is_available, is_verified) VALUES (?, ?, ?, ?, ?, FALSE, FALSE)";
        String requestedRole = normalizeRequestedRole(user.getRequestedUserType());
        String accountStatus = "counselor".equals(requestedRole) ? "pending" : "approved";
        
        try (Connection conn = DBConfig.getConnection()) {
            conn.setAutoCommit(false);

            try (PreparedStatement pstmt = conn.prepareStatement(userSql, Statement.RETURN_GENERATED_KEYS)) {
                pstmt.setString(1, user.getFullName());
                pstmt.setString(2, user.getEmail());
                pstmt.setString(3, PasswordUtil.hashPassword(user.getPassword()));
                pstmt.setString(4, user.getPhone());
                pstmt.setString(5, user.getCity());
                pstmt.setString(6, requestedRole);
                pstmt.setString(7, accountStatus);
                
                if (pstmt.executeUpdate() == 0) {
                    conn.rollback();
                    return false;
                }

                int userId;
                try (ResultSet keys = pstmt.getGeneratedKeys()) {
                    if (!keys.next()) {
                        conn.rollback();
                        return false;
                    }
                    userId = keys.getInt(1);
                }

                if ("counselor".equals(requestedRole) && counselorRequest != null) {
                    try (PreparedStatement counselorStmt = conn.prepareStatement(counselorSql)) {
                        counselorStmt.setInt(1, userId);
                        counselorStmt.setString(2, counselorRequest.getSpecialization());
                        counselorStmt.setInt(3, counselorRequest.getExperienceYears());
                        counselorStmt.setString(4, counselorRequest.getBio());
                        counselorStmt.setDouble(5, counselorRequest.getConsultationFee());
                        counselorStmt.executeUpdate();
                    }
                }
            }
            
            conn.commit();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public UserModel loginUser(String email, String password) {
        String sql = "SELECT * FROM users WHERE email = ?";
        
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, email);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next() && isValidPassword(password, rs.getString("password"), rs.getInt("user_id"))
                    && canLogin(rs)) {
                UserModel user = new UserModel();
                mapUser(rs, user);
                return user;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    private boolean canLogin(ResultSet rs) throws SQLException {
        String status = rs.getString("account_status");
        String requestedRole = rs.getString("requested_user_type");
        if ("rejected".equals(status) || "disabled".equals(status)) {
            return false;
        }
        return "approved".equals(status) || "user".equals(requestedRole);
    }

    private boolean isValidPassword(String plainPassword, String storedPassword, int userId) {
        if (PasswordUtil.verifyPassword(plainPassword, storedPassword)) {
            return true;
        }

        if (storedPassword != null && storedPassword.equals(plainPassword)) {
            updatePasswordHash(userId, plainPassword);
            return true;
        }

        return false;
    }

    private void updatePasswordHash(int userId, String plainPassword) {
        String sql = "UPDATE users SET password = ? WHERE user_id = ?";

        try (Connection conn = DBConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, PasswordUtil.hashPassword(plainPassword));
            pstmt.setInt(2, userId);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<UserModel> getAllUsers() {
        List<UserModel> users = new ArrayList<>();
        String sql = "SELECT * FROM users ORDER BY created_at DESC";

        try (Connection conn = DBConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                UserModel user = new UserModel();
                mapUser(rs, user);
                users.add(user);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }

    public UserModel getUserById(int userId) {
        String sql = "SELECT * FROM users WHERE user_id = ?";

        try (Connection conn = DBConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    UserModel user = new UserModel();
                    mapUser(rs, user);
                    return user;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateProfile(UserModel user) {
        String sql = "UPDATE users SET full_name = ?, phone = ?, city = ? WHERE user_id = ?";

        try (Connection conn = DBConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, user.getFullName());
            pstmt.setString(2, user.getPhone());
            pstmt.setString(3, user.getCity());
            pstmt.setInt(4, user.getUserId());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean changePassword(int userId, String currentPassword, String newPassword) {
        String sql = "SELECT password FROM users WHERE user_id = ?";

        try (Connection conn = DBConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (!rs.next() || !isValidPassword(currentPassword, rs.getString("password"), userId)) {
                    return false;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }

        updatePasswordHash(userId, newPassword);
        return true;
    }

    public boolean approveUser(int userId) {
        String sql = "UPDATE users SET account_status = 'approved', user_type = requested_user_type WHERE user_id = ? AND account_status = 'pending'";

        try (Connection conn = DBConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, userId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean rejectUser(int userId) {
        String sql = "UPDATE users SET account_status = 'rejected' WHERE user_id = ? AND account_status = 'pending'";

        try (Connection conn = DBConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, userId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean disableUser(int userId) {
        String sql = "UPDATE users SET account_status = 'disabled' WHERE user_id = ? AND user_type <> 'super_admin'";

        try (Connection conn = DBConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, userId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean makeAdmin(int userId) {
        String sql = "UPDATE users SET user_type = 'admin', requested_user_type = 'admin', account_status = 'approved' WHERE user_id = ? AND user_type <> 'super_admin'";

        try (Connection conn = DBConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, userId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean removeAdmin(int userId) {
        String sql = "UPDATE users SET user_type = 'user', requested_user_type = 'user' WHERE user_id = ? AND user_type = 'admin'";

        try (Connection conn = DBConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, userId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private void mapUser(ResultSet rs, UserModel user) throws SQLException {
        user.setUserId(rs.getInt("user_id"));
        user.setFullName(rs.getString("full_name"));
        user.setEmail(rs.getString("email"));
        user.setPhone(rs.getString("phone"));
        user.setCity(rs.getString("city"));
        user.setUserType(rs.getString("user_type"));
        user.setRequestedUserType(rs.getString("requested_user_type"));
        user.setAccountStatus(rs.getString("account_status"));
        user.setCreatedAt(rs.getString("created_at"));
    }

    private String normalizeRequestedRole(String requestedRole) {
        if ("counselor".equals(requestedRole)) {
            return "counselor";
        }
        return "user";
    }
}
