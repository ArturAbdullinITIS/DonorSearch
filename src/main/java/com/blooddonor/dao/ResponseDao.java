package com.blooddonor.dao;

import com.blooddonor.model.Response;
import com.blooddonor.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ResponseDao {

    public Response create(Response response) throws SQLException {
        String sql = "INSERT INTO responses (request_id, donor_id, message, status) " +
                "VALUES (?, ?, ?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setLong(1, response.getRequestId());
            stmt.setLong(2, response.getDonorId());
            stmt.setString(3, response.getMessage());
            stmt.setString(4, response.getStatus());

            stmt.executeUpdate();

            try (ResultSet rs = stmt.getGeneratedKeys()) {
                if (rs.next()) {
                    response.setId(rs.getLong(1));
                }
            }

            return response;
        }
    }

    public Response findById(Long id) throws SQLException {
        String sql = "SELECT r.*, u.full_name as donor_name, u.phone as donor_phone, " +
                "dp.blood_type || ' ' || dp.rh_factor as donor_blood_type, " +
                "dr.patient_name as request_patient_name " +
                "FROM responses r " +
                "JOIN users u ON r.donor_id = u.id " +
                "LEFT JOIN donor_profiles dp ON dp.user_id = u.id " +
                "JOIN donation_requests dr ON r.request_id = dr.id " +
                "WHERE r.id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, id);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return extractResponse(rs);
                }
            }
        }
        return null;
    }

    public List<Response> findByRequest(Long requestId) throws SQLException {
        String sql = "SELECT r.*, u.full_name as donor_name, u.phone as donor_phone, " +
                "dp.blood_type || ' ' || dp.rh_factor as donor_blood_type, " +
                "dr.patient_name as request_patient_name " +
                "FROM responses r " +
                "JOIN users u ON r.donor_id = u.id " +
                "LEFT JOIN donor_profiles dp ON dp.user_id = u.id " +
                "JOIN donation_requests dr ON r.request_id = dr.id " +
                "WHERE r.request_id = ? " +
                "ORDER BY r.response_date DESC";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, requestId);

            try (ResultSet rs = stmt.executeQuery()) {
                List<Response> responses = new ArrayList<>();
                while (rs.next()) {
                    responses.add(extractResponse(rs));
                }
                return responses;
            }
        }
    }

    public List<Response> findByDonor(Long donorId) throws SQLException {
        String sql = "SELECT r.*, u.full_name as donor_name, u.phone as donor_phone, " +
                "dp.blood_type || ' ' || dp.rh_factor as donor_blood_type, " +
                "dr.patient_name as request_patient_name " +
                "FROM responses r " +
                "JOIN users u ON r.donor_id = u.id " +
                "LEFT JOIN donor_profiles dp ON dp.user_id = u.id " +
                "JOIN donation_requests dr ON r.request_id = dr.id " +
                "WHERE r.donor_id = ? " +
                "ORDER BY r.response_date DESC";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, donorId);

            try (ResultSet rs = stmt.executeQuery()) {
                List<Response> responses = new ArrayList<>();
                while (rs.next()) {
                    responses.add(extractResponse(rs));
                }
                return responses;
            }
        }
    }

    public boolean hasUserResponded(Long requestId, Long userId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM responses WHERE request_id = ? AND donor_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, requestId);
            stmt.setLong(2, userId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    public void updateStatus(Long id, String status) throws SQLException {
        String sql = "UPDATE responses SET status = ? WHERE id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, status);
            stmt.setLong(2, id);

            stmt.executeUpdate();
        }
    }

    public void delete(Long id) throws SQLException {
        String sql = "DELETE FROM responses WHERE id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, id);
            stmt.executeUpdate();
        }
    }

    private Response extractResponse(ResultSet rs) throws SQLException {
        Response response = new Response();
        response.setId(rs.getLong("id"));
        response.setRequestId(rs.getLong("request_id"));
        response.setDonorId(rs.getLong("donor_id"));
        response.setMessage(rs.getString("message"));
        response.setStatus(rs.getString("status"));

        Timestamp created = rs.getTimestamp("response_date");
        if (created != null) {
            response.setCreatedAt(created.toLocalDateTime());
        }

        response.setDonorName(rs.getString("donor_name"));
        response.setDonorPhone(rs.getString("donor_phone"));
        response.setDonorBloodType(rs.getString("donor_blood_type"));
        response.setRequestPatientName(rs.getString("request_patient_name"));

        return response;
    }
}
