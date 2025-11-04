package com.blooddonor.dao;

import com.blooddonor.model.Activity;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ActivityDao {
    private Connection connection;

    public ActivityDao(Connection connection) {
        this.connection = connection;
    }

    public void createActivity(Activity activity) throws SQLException {
        String sql = "INSERT INTO activities (user_id, type, title, description, created_at) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setLong(1, activity.getUserId());
            stmt.setString(2, activity.getType());
            stmt.setString(3, activity.getTitle());
            stmt.setString(4, activity.getDescription());
            stmt.setTimestamp(5, Timestamp.valueOf(activity.getCreatedAt()));
            stmt.executeUpdate();

            ResultSet rs = stmt.getGeneratedKeys();
            if (rs.next()) {
                activity.setId(rs.getLong(1));
            }
        }
    }

    public List<Activity> getRecentActivitiesByUserId(Long userId, int limit) throws SQLException {
        String sql = "SELECT * FROM activities WHERE user_id = ? ORDER BY created_at DESC LIMIT ?";
        List<Activity> activities = new ArrayList<>();

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, userId);
            stmt.setInt(2, limit);

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Activity activity = new Activity();
                activity.setId(rs.getLong("id"));
                activity.setUserId(rs.getLong("user_id"));
                activity.setType(rs.getString("type"));
                activity.setTitle(rs.getString("title"));
                activity.setDescription(rs.getString("description"));

                Timestamp timestamp = rs.getTimestamp("created_at");
                if (timestamp != null) {
                    activity.setCreatedAt(timestamp.toLocalDateTime());
                }

                activities.add(activity);
            }
        }

        return activities;
    }

    public void deleteActivitiesByUserId(Long userId) throws SQLException {
        String sql = "DELETE FROM activities WHERE user_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, userId);
            stmt.executeUpdate();
        }
    }
}
