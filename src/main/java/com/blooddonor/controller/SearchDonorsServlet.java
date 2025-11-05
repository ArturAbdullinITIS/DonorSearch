package com.blooddonor.controller;

import com.blooddonor.di.ServiceContainer;
import com.blooddonor.model.DonorProfile;
import com.blooddonor.service.DonorProfileService;
import com.fasterxml.jackson.databind.ObjectMapper;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/search")
public class SearchDonorsServlet extends HttpServlet {

    private DonorProfileService donorProfileService;
    private ObjectMapper objectMapper;

    @Override
    public void init() throws ServletException {
        super.init();
        ServiceContainer container = ServiceContainer.getInstance();
        donorProfileService = container.getService(DonorProfileService.class);
        objectMapper = new ObjectMapper();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String bloodType = request.getParameter("bloodType");
        String rhFactor = request.getParameter("rhFactor");
        String city = request.getParameter("city");
        String ajax = request.getParameter("ajax");

        try {
            List<DonorProfile> donors = null;

            if (bloodType != null && rhFactor != null) {
                if (city != null && !city.trim().isEmpty()) {
                    donors = donorProfileService.searchDonors(bloodType, rhFactor, city.trim());
                } else {
                    donors = donorProfileService.searchDonors(bloodType, rhFactor, null);
                }

                if ("true".equals(ajax)) {
                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");

                    Map<String, Object> result = new HashMap<>();
                    result.put("success", true);
                    result.put("donors", donors);
                    result.put("count", donors != null ? donors.size() : 0);

                    objectMapper.writeValue(response.getWriter(), result);
                    return;
                }

                request.setAttribute("searchPerformed", true);
            }

            request.setAttribute("donors", donors);
            request.setAttribute("bloodType", bloodType);
            request.setAttribute("rhFactor", rhFactor);
            request.setAttribute("city", city);

            request.getRequestDispatcher("/WEB-INF/views/search-donors.jsp").forward(request, response);

        } catch (SQLException e) {
            if ("true".equals(request.getParameter("ajax"))) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");

                Map<String, Object> error = new HashMap<>();
                error.put("success", false);
                error.put("message", "Ошибка при поиске доноров: " + e.getMessage());

                objectMapper.writeValue(response.getWriter(), error);
            } else {
                throw new ServletException("Ошибка при поиске доноров", e);
            }
        }
    }
}
