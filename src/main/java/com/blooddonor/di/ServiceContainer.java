package com.blooddonor.di;

import com.blooddonor.dao.*;
import com.blooddonor.service.*;
import com.blooddonor.util.DatabaseConnection;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

public class ServiceContainer {
    private static ServiceContainer instance;
    private final Map<Class<?>, Object> services = new HashMap<>();
    private Connection connection;

    private ServiceContainer() {
        try {
            initializeServices();
        } catch (SQLException e) {
            throw new RuntimeException("Failed to initialize ServiceContainer", e);
        }
    }

    public static synchronized ServiceContainer getInstance() {
        if (instance == null) {
            instance = new ServiceContainer();
        }
        return instance;
    }

    private void initializeServices() throws SQLException {
        connection = DatabaseConnection.getConnection();

        UserDao userDao = new UserDao(connection);
        ActivityDao activityDao = new ActivityDao(connection);
        DonationRequestDao donationRequestDao = new DonationRequestDao();
        DonorProfileDao donorProfileDao = new DonorProfileDao();
        ResponseDao responseDao = new ResponseDao();

        UserService userService = new UserService(connection);
        DonationRequestService donationRequestService = new DonationRequestService();
        DonorProfileService donorProfileService = new DonorProfileService();
        ResponseService responseService = new ResponseService();

        services.put(Connection.class, connection);
        services.put(UserDao.class, userDao);
        services.put(ActivityDao.class, activityDao);
        services.put(DonationRequestDao.class, donationRequestDao);
        services.put(DonorProfileDao.class, donorProfileDao);
        services.put(ResponseDao.class, responseDao);
        services.put(UserService.class, userService);
        services.put(DonationRequestService.class, donationRequestService);
        services.put(DonorProfileService.class, donorProfileService);
        services.put(ResponseService.class, responseService);
    }

    @SuppressWarnings("unchecked")
    public <T> T getService(Class<T> serviceClass) {
        return (T) services.get(serviceClass);
    }

    public Connection getConnection() {
        return connection;
    }

    public void shutdown() {
        try {
            if (connection != null && !connection.isClosed()) {
                connection.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}

