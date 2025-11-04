package com.blooddonor.controller;

import com.blooddonor.di.ServiceContainer;
import com.blooddonor.model.DonorProfile;
import com.blooddonor.service.DonorProfileService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/search")
public class SearchDonorsServlet extends HttpServlet {

    private DonorProfileService donorProfileService;

    @Override
    public void init() throws ServletException {
        super.init();
        ServiceContainer container = ServiceContainer.getInstance();
        donorProfileService = container.getService(DonorProfileService.class);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String bloodType = request.getParameter("bloodType");
        String rhFactor = request.getParameter("rhFactor");
        String city = request.getParameter("city");

        try {
            List<DonorProfile> donors = null;

            if (bloodType != null && rhFactor != null) {
                if (city != null && !city.trim().isEmpty()) {
                    donors = donorProfileService.searchDonors(bloodType, rhFactor, city.trim());
                } else {
                    donors = donorProfileService.searchDonors(bloodType, rhFactor, null);
                }
                request.setAttribute("searchPerformed", true);
            }

            request.setAttribute("donors", donors);
            request.setAttribute("bloodType", bloodType);
            request.setAttribute("rhFactor", rhFactor);
            request.setAttribute("city", city);

            request.getRequestDispatcher("/WEB-INF/views/search-donors.jsp").forward(request, response);

        } catch (SQLException e) {
            throw new ServletException("Ошибка при поиске доноров", e);
        }
    }
}
