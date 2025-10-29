package com.blooddonor.service;

import com.blooddonor.dao.UserDao;
import com.blooddonor.model.User;
import com.blooddonor.util.PasswordHasher;

import java.sql.Connection;

public class UserService {

    private final UserDao userDao;

    public UserService(Connection connection) {
        this.userDao = new UserDao(connection);
    }

    public User authenticate(String login, String password) {
        var userOpt = userDao.findByLogin(login);

        if (userOpt.isPresent()) {
            User user = userOpt.get();

            if (PasswordHasher.verifyPassword(password, user.getPasswordHash())) {
                return user;
            }
        }

        return null;
    }

    public boolean register(User user, String password) {
        String passwordHash = PasswordHasher.hashPassword(password);
        user.setPasswordHash(passwordHash);
        user.setActive(true);

        return userDao.create(user);
    }

    public boolean isLoginExists(String login) {
        return userDao.findByLogin(login).isPresent();
    }

    public User findById(Long id) {
        return userDao.findById(id).orElse(null);
    }
}