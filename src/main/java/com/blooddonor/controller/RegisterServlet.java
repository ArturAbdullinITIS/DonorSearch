package com.blooddonor.controller;

import com.blooddonor.dao.ActivityDao;
import com.blooddonor.di.ServiceContainer;
import com.blooddonor.model.Activity;
import com.blooddonor.model.User;
import com.blooddonor.service.UserService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private UserService userService;
    private ActivityDao activityDao;

    @Override
    public void init() throws ServletException {
        super.init();
        ServiceContainer container = ServiceContainer.getInstance();
        userService = container.getService(UserService.class);
        activityDao = container.getService(ActivityDao.class);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String login = request.getParameter("login");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String email = request.getParameter("email");

        try {
            if (!password.equals(confirmPassword)) {
                request.setAttribute("error", "Пароли не совпадают");
                request.setAttribute("login", login);
                request.setAttribute("email", email);
                request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
                return;
            }

            if (userService.isLoginExists(login)) {
                request.setAttribute("error", "Пользователь с таким логином уже существует");
                request.setAttribute("email", email);
                request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
                return;
            }

            User user = new User();
            user.setLogin(login);
            user.setEmail(email);
            user.setPhone(null);
            user.setCity(null);
            user.setFullName(null);

            boolean success = userService.register(user, password);

            if (success) {
                try {
                    Activity activity = new Activity(
                        user.getId(),
                        "Регистрация",
                        "Добро пожаловать!",
                        "Вы успешно зарегистрировались в системе поиска доноров крови"
                    );
                    activityDao.createActivity(activity);
                } catch (Exception ignored) {
                }

                response.sendRedirect(request.getContextPath() + "/?registered=true");
            } else {
                request.setAttribute("error", "Ошибка при регистрации. Попробуйте еще раз.");
                request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            }

        } catch (Exception e) {
            request.setAttribute("error", "Произошла ошибка при регистрации: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
        }
    }
}