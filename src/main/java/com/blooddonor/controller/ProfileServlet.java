package com.blooddonor.controller;

import com.blooddonor.model.User;
import com.blooddonor.service.UserService;
import com.blooddonor.util.DatabaseConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {

    private UserService userService;

    @Override
    public void init() throws ServletException {
        super.init();
        try {
            userService = new UserService(DatabaseConnection.getConnection());
            System.out.println("ProfileServlet initialized");
        } catch (Exception e) {
            throw new ServletException("Error initializing ProfileServlet", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");

        try {
            User freshUser = userService.findById(user.getId());
            if (freshUser != null) {
                session.setAttribute("user", freshUser);
                request.setAttribute("user", freshUser);
            } else {
                request.setAttribute("user", user);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("user", user);
        }

        request.getRequestDispatcher("/WEB-INF/views/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User currentUser = (User) session.getAttribute("user");

        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String city = request.getParameter("city");
        String email = request.getParameter("email");

        try {
            currentUser.setFullName(fullName != null ? fullName.trim() : null);
            currentUser.setPhone(phone != null ? phone.trim() : null);
            currentUser.setCity(city != null ? city.trim() : null);
            currentUser.setEmail(email != null ? email.trim() : null);

            boolean success = userService.updateUser(currentUser);

            if (success) {
                User updatedUser = userService.findById(currentUser.getId());
                session.setAttribute("user", updatedUser);
                request.setAttribute("user", updatedUser);
                request.setAttribute("success", "Профиль успешно обновлен!");
            } else {
                request.setAttribute("error", "Ошибка при обновлении профиля в базе данных");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Произошла ошибка при обновлении профиля: " + e.getMessage());
        }

        request.getRequestDispatcher("/WEB-INF/views/profile.jsp").forward(request, response);
    }
}