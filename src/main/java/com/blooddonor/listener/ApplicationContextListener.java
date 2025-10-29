package com.blooddonor.listener;

import com.blooddonor.service.UserService;
import com.blooddonor.util.DatabaseConnection;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;
import java.sql.Connection;
import java.sql.SQLException;

@WebListener
public class ApplicationContextListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        try {
            //БД
            Connection connection = DatabaseConnection.getConnection();

            //Сервисы
            UserService userService = new UserService(connection);

            //Сохраняем в контекст
            ServletContext context = sce.getServletContext();
            context.setAttribute("userService", userService);
            context.setAttribute("dbConnection", connection);

            System.out.println("Services inititalized successfully");

        } catch (SQLException e) {
            System.err.println("BD init failure: " + e.getMessage());
            e.printStackTrace();
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("App destroyed");

        //Закрываем подключение к БД
        try {
            Connection connection = (Connection) sce.getServletContext().getAttribute("dbConnection");
            if (connection != null && !connection.isClosed()) {
                connection.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}