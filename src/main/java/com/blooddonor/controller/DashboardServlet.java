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

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    private UserService userService;

    @Override
    public void init() throws ServletException {
        super.init();
        try {
            userService = new UserService(DatabaseConnection.getConnection());
            System.out.println("DashboardServlet initialized");
        } catch (Exception e) {
            throw new ServletException("Error initializing DashboardServlet", e);
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

        request.getRequestDispatcher("/WEB-INF/views/dashboard.jsp").forward(request, response);
    }
}