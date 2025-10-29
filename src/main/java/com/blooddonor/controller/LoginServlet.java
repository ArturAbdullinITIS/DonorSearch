package com.blooddonor.controller;

import com.blooddonor.service.UserService;
import com.blooddonor.model.User;
import com.blooddonor.util.DatabaseConnection;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private UserService userService;

    @Override
    public void init() throws ServletException {
        super.init();

        ServletContext context = getServletContext();
        UserService service = (UserService) context.getAttribute("userService");

        if (service == null) {
            try {
                Connection connection = DatabaseConnection.getConnection();
                userService = new UserService(connection);
                context.setAttribute("userService", userService);
            } catch (SQLException e) {
                throw new ServletException("failed to init UserService", e);
            }
        } else {
            userService = service;
            System.out.println("UserService from context success");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String successParam = request.getParameter("success");
        if ("registered".equals(successParam)) {
            request.setAttribute("success", "Регистрация прошла успешно! Теперь вы можете войти.");
        }

        request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String login = request.getParameter("login");
        String password = request.getParameter("password");

        try {
            User user = userService.authenticate(login, password);

            if (user != null) {
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                session.setAttribute("userId", user.getId());
                session.setAttribute("userLogin", user.getLogin());

                response.sendRedirect(request.getContextPath() + "/");
            } else {
                request.setAttribute("error", "Неверный логин или пароль");
                request.setAttribute("login", login);
                request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Произошла ошибка при входе в систему");
            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
        }
    }
}