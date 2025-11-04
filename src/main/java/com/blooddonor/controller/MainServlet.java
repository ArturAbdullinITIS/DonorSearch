package com.blooddonor.controller;

import com.blooddonor.di.ServiceContainer;
import com.blooddonor.model.DonationRequest;
import com.blooddonor.service.DonationRequestService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/")
public class MainServlet extends HttpServlet {

    private DonationRequestService requestService;

    @Override
    public void init() throws ServletException {
        super.init();
        ServiceContainer container = ServiceContainer.getInstance();
        requestService = container.getService(DonationRequestService.class);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session != null && session.getAttribute("user") != null) {
            try {
                List<DonationRequest> requests = requestService.getAllActiveRequests();
                request.setAttribute("requests", requests);
                request.getRequestDispatcher("/WEB-INF/views/list.jsp").forward(request, response);
            } catch (SQLException e) {
                throw new ServletException("Ошибка при загрузке запросов", e);
            }
        } else {
            request.getRequestDispatcher("/index.jsp").forward(request, response);
        }
    }
}