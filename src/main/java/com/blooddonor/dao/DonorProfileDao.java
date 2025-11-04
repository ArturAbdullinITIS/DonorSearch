package com.blooddonor.dao;

import com.blooddonor.model.DonorProfile;
import com.blooddonor.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DonorProfileDao {

    public DonorProfile create(DonorProfile profile) throws SQLException {
        String sql = "INSERT INTO donor_profiles (user_id, blood_type, rh_factor, " +
                "is_ready_to_donate, additional_info) " +
                "VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setLong(1, profile.getUserId());
            stmt.setString(2, profile.getBloodType());
            stmt.setString(3, profile.getRhFactor());
            stmt.setBoolean(4, profile.isReadyToDonate());
            stmt.setString(5, profile.getAdditionalInfo());

            stmt.executeUpdate();

            try (ResultSet rs = stmt.getGeneratedKeys()) {
                if (rs.next()) {
                    profile.setId(rs.getLong(1));
                }
            }

            return profile;
        }
    }

    public DonorProfile findByUserId(Long userId) throws SQLException {
        String sql = "SELECT dp.*, u.full_name, u.city, u.phone " +
                "FROM donor_profiles dp " +
                "JOIN users u ON dp.user_id = u.id " +
                "WHERE dp.user_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, userId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return extractDonorProfile(rs);
                }
            }
        }
        return null;
    }

    public DonorProfile findById(Long id) throws SQLException {
        String sql = "SELECT dp.*, u.full_name, u.city, u.phone " +
                "FROM donor_profiles dp " +
                "JOIN users u ON dp.user_id = u.id " +
                "WHERE dp.id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, id);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return extractDonorProfile(rs);
                }
            }
        }
        return null;
    }

    public List<DonorProfile> searchDonors(String bloodType, String rhFactor, String city)
            throws SQLException {
        StringBuilder sql = new StringBuilder(
                "SELECT dp.*, u.full_name, u.city, u.phone " +
                        "FROM donor_profiles dp " +
                        "JOIN users u ON dp.user_id = u.id " +
                        "WHERE dp.is_ready_to_donate = true AND u.is_active = true");

        List<String> params = new ArrayList<>();

        if (bloodType != null && !bloodType.isEmpty()) {
            sql.append(" AND dp.blood_type = ?");
            params.add(bloodType);
        }

        if (rhFactor != null && !rhFactor.isEmpty()) {
            sql.append(" AND dp.rh_factor = ?");
            params.add(rhFactor);
        }

        if (city != null && !city.isEmpty()) {
            sql.append(" AND LOWER(u.city) LIKE LOWER(?)");
            params.add("%" + city + "%");
        }

        sql.append(" ORDER BY u.full_name");

        List<DonorProfile> donors = new ArrayList<>();

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                stmt.setString(i + 1, params.get(i));
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    donors.add(extractDonorProfile(rs));
                }
            }
        }

        return donors;
    }

    public void update(DonorProfile profile) throws SQLException {
        String sql = "UPDATE donor_profiles SET blood_type = ?, rh_factor = ?, " +
                "is_ready_to_donate = ?, additional_info = ? " +
                "WHERE id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, profile.getBloodType());
            stmt.setString(2, profile.getRhFactor());
            stmt.setBoolean(3, profile.isReadyToDonate());
            stmt.setString(4, profile.getAdditionalInfo());
            stmt.setLong(5, profile.getId());

            stmt.executeUpdate();
        }
    }

    public void delete(Long id) throws SQLException {
        String sql = "DELETE FROM donor_profiles WHERE id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, id);
            stmt.executeUpdate();
        }
    }

    private DonorProfile extractDonorProfile(ResultSet rs) throws SQLException {
        DonorProfile profile = new DonorProfile();
        profile.setId(rs.getLong("id"));
        profile.setUserId(rs.getLong("user_id"));
        profile.setBloodType(rs.getString("blood_type"));
        profile.setRhFactor(rs.getString("rh_factor"));
        profile.setReadyToDonate(rs.getBoolean("is_ready_to_donate"));
        profile.setAdditionalInfo(rs.getString("additional_info"));

        profile.setUserName(rs.getString("full_name"));
        profile.setUserCity(rs.getString("city"));
        profile.setUserPhone(rs.getString("phone"));

        return profile;
    }
}
