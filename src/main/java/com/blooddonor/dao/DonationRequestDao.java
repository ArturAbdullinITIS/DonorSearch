package com.blooddonor.dao;

import com.blooddonor.model.DonationRequest;
import com.blooddonor.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DonationRequestDao {

    public DonationRequest create(DonationRequest request) throws SQLException {
        String sql = "INSERT INTO donation_requests (author_id, patient_name, " +
                "blood_type_needed, rh_factor_needed, hospital_name, hospital_address, " +
                "urgency, description, contact_info, status) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setLong(1, request.getAuthorId());
            stmt.setString(2, request.getPatientName());
            stmt.setString(3, request.getBloodTypeNeeded());
            stmt.setString(4, request.getRhFactorNeeded());
            stmt.setString(5, request.getHospital());
            stmt.setString(6, request.getCity());
            stmt.setString(7, request.getUrgencyLevel());
            stmt.setString(8, request.getDescription());
            stmt.setString(9, request.getContactInfo());
            stmt.setString(10, "ACTIVE");

            stmt.executeUpdate();

            try (ResultSet rs = stmt.getGeneratedKeys()) {
                if (rs.next()) {
                    request.setId(rs.getLong(1));
                }
            }

            return request;
        }
    }

    public DonationRequest findById(Long id) throws SQLException {
        String sql = "SELECT dr.id, dr.author_id, dr.patient_name, dr.blood_type_needed, dr.rh_factor_needed, " +
                "dr.hospital_name AS hospital, dr.hospital_address AS city, dr.urgency AS urgency_level, " +
                "dr.description, dr.contact_info, dr.status, dr.created_at, dr.updated_at, " +
                "u.full_name as author_name, (SELECT COUNT(*) FROM responses WHERE request_id = dr.id) as responses_count " +
                "FROM donation_requests dr " +
                "JOIN users u ON dr.author_id = u.id " +
                "WHERE dr.id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, id);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return extractDonationRequest(rs);
                }
            }
        }
        return null;
    }

    public List<DonationRequest> findAll() throws SQLException {
        String sql = "SELECT dr.id, dr.author_id, dr.patient_name, dr.blood_type_needed, dr.rh_factor_needed, " +
                "dr.hospital_name AS hospital, dr.hospital_address AS city, dr.urgency AS urgency_level, " +
                "dr.description, dr.contact_info, dr.status, dr.created_at, dr.updated_at, " +
                "u.full_name as author_name, (SELECT COUNT(*) FROM responses WHERE request_id = dr.id) as responses_count " +
                "FROM donation_requests dr " +
                "JOIN users u ON dr.author_id = u.id " +
                "WHERE dr.status = 'ACTIVE' " +
                "ORDER BY dr.urgency DESC, dr.created_at DESC";

        return executeQueryForList(sql);
    }

    public List<DonationRequest> findByAuthor(Long authorId) throws SQLException {
        String sql = "SELECT dr.id, dr.author_id, dr.patient_name, dr.blood_type_needed, dr.rh_factor_needed, " +
                "dr.hospital_name AS hospital, dr.hospital_address AS city, dr.urgency AS urgency_level, " +
                "dr.description, dr.contact_info, dr.status, dr.created_at, dr.updated_at, " +
                "u.full_name as author_name, (SELECT COUNT(*) FROM responses WHERE request_id = dr.id) as responses_count " +
                "FROM donation_requests dr " +
                "JOIN users u ON dr.author_id = u.id " +
                "WHERE dr.author_id = ? " +
                "ORDER BY dr.created_at DESC";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, authorId);

            try (ResultSet rs = stmt.executeQuery()) {
                List<DonationRequest> requests = new ArrayList<>();
                while (rs.next()) {
                    requests.add(extractDonationRequest(rs));
                }
                return requests;
            }
        }
    }

    public List<DonationRequest> searchByBloodType(String bloodType, String rhFactor)
            throws SQLException {
        String sql = "SELECT dr.id, dr.author_id, dr.patient_name, dr.blood_type_needed, dr.rh_factor_needed, " +
                "dr.hospital_name AS hospital, dr.hospital_address AS city, dr.urgency AS urgency_level, " +
                "dr.description, dr.contact_info, dr.status, dr.created_at, dr.updated_at, " +
                "u.full_name as author_name, (SELECT COUNT(*) FROM responses WHERE request_id = dr.id) as responses_count " +
                "FROM donation_requests dr " +
                "JOIN users u ON dr.author_id = u.id " +
                "WHERE dr.status = 'ACTIVE' " +
                "AND dr.blood_type_needed = ? AND dr.rh_factor_needed = ? " +
                "ORDER BY dr.urgency DESC, dr.created_at DESC";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, bloodType);
            stmt.setString(2, rhFactor);

            try (ResultSet rs = stmt.executeQuery()) {
                List<DonationRequest> requests = new ArrayList<>();
                while (rs.next()) {
                    requests.add(extractDonationRequest(rs));
                }
                return requests;
            }
        }
    }

    public void update(DonationRequest request) throws SQLException {
        String sql = "UPDATE donation_requests SET patient_name = ?, " +
                "blood_type_needed = ?, rh_factor_needed = ?, hospital_address = ?, " +
                "hospital_name = ?, urgency = ?, description = ?, " +
                "contact_info = ?, status = ?, updated_at = CURRENT_TIMESTAMP " +
                "WHERE id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, request.getPatientName());
            stmt.setString(2, request.getBloodTypeNeeded());
            stmt.setString(3, request.getRhFactorNeeded());
            stmt.setString(4, request.getCity());
            stmt.setString(5, request.getHospital());
            stmt.setString(6, request.getUrgencyLevel());
            stmt.setString(7, request.getDescription());
            stmt.setString(8, request.getContactInfo());
            stmt.setString(9, request.getStatus());
            stmt.setLong(10, request.getId());

            stmt.executeUpdate();
        }
    }

    public void delete(Long id) throws SQLException {
        String sql = "DELETE FROM donation_requests WHERE id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, id);
            stmt.executeUpdate();
        }
    }

    private List<DonationRequest> executeQueryForList(String sql) throws SQLException {
        List<DonationRequest> requests = new ArrayList<>();

        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                requests.add(extractDonationRequest(rs));
            }
        }

        return requests;
    }

    private DonationRequest extractDonationRequest(ResultSet rs) throws SQLException {
        DonationRequest request = new DonationRequest();
        request.setId(rs.getLong("id"));
        request.setAuthorId(rs.getLong("author_id"));
        request.setPatientName(rs.getString("patient_name"));
        request.setBloodTypeNeeded(rs.getString("blood_type_needed"));
        request.setRhFactorNeeded(rs.getString("rh_factor_needed"));
        request.setCity(rs.getString("city"));
        request.setHospital(rs.getString("hospital"));
        request.setUrgencyLevel(rs.getString("urgency_level"));
        request.setDescription(rs.getString("description"));
        request.setContactInfo(rs.getString("contact_info"));
        request.setStatus(rs.getString("status"));

        Timestamp created = rs.getTimestamp("created_at");
        if (created != null) {
            request.setCreatedAt(created.toLocalDateTime());
        }

        Timestamp updated = rs.getTimestamp("updated_at");
        if (updated != null) {
            request.setUpdatedAt(updated.toLocalDateTime());
        }

        request.setAuthorName(rs.getString("author_name"));
        request.setResponsesCount(rs.getInt("responses_count"));

        return request;
    }
}
