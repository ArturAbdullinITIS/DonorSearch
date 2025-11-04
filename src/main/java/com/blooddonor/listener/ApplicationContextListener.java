package com.blooddonor.listener;

import com.blooddonor.di.ServiceContainer;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

@WebListener
public class ApplicationContextListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        ServletContext context = sce.getServletContext();
        ServiceContainer container = ServiceContainer.getInstance();
        context.setAttribute("serviceContainer", container);
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        ServiceContainer container = (ServiceContainer) sce.getServletContext().getAttribute("serviceContainer");
        if (container != null) {
            container.shutdown();
        }
    }
}