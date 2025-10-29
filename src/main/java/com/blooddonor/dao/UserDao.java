package com.blooddonor.dao;

import com.blooddonor.model.User;

import java.sql.*;
import java.util.Optional;

public class UserDao {

    private final Connection connection;

    public UserDao(Connection connection) {
        this.connection = connection;
    }
    public Optional<User> findByLogin(String login) {
        String sql = "SELECT * FROM users WHERE login = ? AND is_active = true";

        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, login);

            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return Optional.of(mapResultSetToUser(resultSet));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return Optional.empty();
    }
    public Optional<User> findById(Long id) {
        String sql = "SELECT * FROM users WHERE id = ? AND is_active = true";

        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, id);

            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return Optional.of(mapResultSetToUser(resultSet));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return Optional.empty();
    }

    public boolean create(User user) {
        String sql = "INSERT INTO users (login, password_hash, email, phone, city, full_name) " +
                "VALUES (?, ?, ?, ?, ?, ?)";

        try (PreparedStatement statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            statement.setString(1, user.getLogin());
            statement.setString(2, user.getPasswordHash());
            statement.setString(3, user.getEmail());
            statement.setString(4, user.getPhone());
            statement.setString(5, user.getCity());
            statement.setString(6, user.getFullName());

            int affectedRows = statement.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = statement.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        user.setId(generatedKeys.getLong(1));
                        return true;
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    private User mapResultSetToUser(ResultSet resultSet) throws SQLException {
        User user = new User();
        user.setId(resultSet.getLong("id"));
        user.setLogin(resultSet.getString("login"));
        user.setPasswordHash(resultSet.getString("password_hash"));
        user.setEmail(resultSet.getString("email"));
        user.setPhone(resultSet.getString("phone"));
        user.setCity(resultSet.getString("city"));
        user.setFullName(resultSet.getString("full_name"));
        user.setCreatedAt(resultSet.getTimestamp("created_at").toLocalDateTime());
        user.setActive(resultSet.getBoolean("is_active"));
        return user;
    }
}