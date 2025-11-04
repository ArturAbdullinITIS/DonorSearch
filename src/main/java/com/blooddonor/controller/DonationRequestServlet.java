package com.blooddonor.controller;

import com.blooddonor.dao.ActivityDao;
import com.blooddonor.di.ServiceContainer;
import com.blooddonor.model.Activity;
import com.blooddonor.model.DonationRequest;
import com.blooddonor.model.Response;
import com.blooddonor.model.User;
import com.blooddonor.model.DonorProfile;
import com.blooddonor.service.DonationRequestService;
import com.blooddonor.service.DonorProfileService;
import com.blooddonor.service.ResponseService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/requests/*")
public class DonationRequestServlet extends HttpServlet {

    private DonationRequestService requestService;
    private ActivityDao activityDao;
    private DonorProfileService donorProfileService;
    private ResponseService responseService;

    @Override
    public void init() throws ServletException {
        super.init();
        ServiceContainer container = ServiceContainer.getInstance();
        requestService = container.getService(DonationRequestService.class);
        activityDao = container.getService(ActivityDao.class);
        donorProfileService = container.getService(DonorProfileService.class);
        responseService = container.getService(ResponseService.class);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String pathInfo = request.getPathInfo();

        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                showMyRequests(request, response);
            } else if ("/new".equals(pathInfo)) {
                showCreateForm(request, response);
            } else if ("/view".equals(pathInfo)) {
                showRequest(request, response);
            } else if ("/edit".equals(pathInfo)) {
                showEditForm(request, response);
            } else if ("/all".equals(pathInfo)) {
                showAllActiveRequests(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            throw new ServletException("Ошибка при обработке запроса", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String pathInfo = request.getPathInfo();

        try {
            if (pathInfo == null || pathInfo.equals("/create")) {
                createRequest(request, response);
            } else if ("/update".equals(pathInfo)) {
                updateRequest(request, response);
            } else if ("/close".equals(pathInfo)) {
                closeRequest(request, response);
            } else if ("/reopen".equals(pathInfo)) {
                reopenRequest(request, response);
            } else if ("/delete".equals(pathInfo)) {
                deleteRequest(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            throw new ServletException("Ошибка при обработке запроса", e);
        }
    }

    private void showAllActiveRequests(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        List<DonationRequest> requests = requestService.getAllActiveRequests();
        request.setAttribute("requests", requests);
        request.getRequestDispatcher("/WEB-INF/views/list.jsp").forward(request, response);
    }

    private void showMyRequests(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {

        User user = (User) request.getSession().getAttribute("user");
        List<DonationRequest> requests = requestService.getRequestsByAuthor(user.getId());

        request.setAttribute("requests", requests);
        request.getRequestDispatcher("/WEB-INF/views/my-requests.jsp").forward(request, response);
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) request.getSession().getAttribute("user");

        try {
            DonorProfile donorProfile = donorProfileService.getDonorProfileByUserId(user.getId());
            if (donorProfile != null) {
                request.setAttribute("donorProfile", donorProfile);
            }
        } catch (Exception ignored) {
        }

        request.getRequestDispatcher("/WEB-INF/views/create-request.jsp").forward(request, response);
    }

    private void showRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {

        String idParam = request.getParameter("id");
        if (idParam == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID запроса не указан");
            return;
        }

        try {
            Long id = Long.parseLong(idParam);
            DonationRequest donationRequest = requestService.getRequestById(id);

            if (donationRequest == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Запрос не найден");
                return;
            }

            User user = (User) request.getSession().getAttribute("user");

            List<Response> responses = responseService.getResponsesByRequest(id);
            request.setAttribute("responses", responses);

            boolean hasUserResponded = responses.stream()
                .anyMatch(resp -> resp.getDonorId().equals(user.getId()));
            request.setAttribute("hasUserResponded", hasUserResponded);

            boolean isBloodTypeCompatible = false;
            try {
                DonorProfile donorProfile = donorProfileService.getDonorProfileByUserId(user.getId());
                if (donorProfile != null) {
                    isBloodTypeCompatible = checkBloodTypeCompatibility(
                        donorProfile.getBloodType(),
                        donorProfile.getRhFactor(),
                        donationRequest.getBloodTypeNeeded(),
                        donationRequest.getRhFactorNeeded()
                    );
                    request.setAttribute("donorProfile", donorProfile);
                }
            } catch (Exception ignored) {
            }
            request.setAttribute("isBloodTypeCompatible", isBloodTypeCompatible);

            request.setAttribute("request", donationRequest);
            request.getRequestDispatcher("/WEB-INF/views/view-request.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Некорректный ID");
        }
    }

    private boolean checkBloodTypeCompatibility(String donorBloodType, String donorRhFactor,
                                                 String recipientBloodType, String recipientRhFactor) {
        if (donorBloodType == null || donorRhFactor == null ||
            recipientBloodType == null || recipientRhFactor == null) {
            return false;
        }

        if (donorRhFactor.equals("POSITIVE") && recipientRhFactor.equals("NEGATIVE")) {
            return false;
        }

        if (donorBloodType.equals("O")) {
            return true;
        }

        if (donorBloodType.equals("AB")) {
            return recipientBloodType.equals("AB");
        }

        if (donorBloodType.equals("A")) {
            return recipientBloodType.equals("A") || recipientBloodType.equals("AB");
        }

        if (donorBloodType.equals("B")) {
            return recipientBloodType.equals("B") || recipientBloodType.equals("AB");
        }

        return false;
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {

        String idParam = request.getParameter("id");
        if (idParam == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID запроса не указан");
            return;
        }

        try {
            Long id = Long.parseLong(idParam);
            DonationRequest donationRequest = requestService.getRequestById(id);

            if (donationRequest == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Запрос не найден");
                return;
            }

            User user = (User) request.getSession().getAttribute("user");
            if (!donationRequest.getAuthorId().equals(user.getId())) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Вы не можете редактировать чужой запрос");
                return;
            }

            request.setAttribute("request", donationRequest);
            request.getRequestDispatcher("/WEB-INF/views/edit-request.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Некорректный ID");
        }
    }

    private void createRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {

        User user = (User) request.getSession().getAttribute("user");

        String patientName = request.getParameter("patientName");
        String bloodType = request.getParameter("bloodType");
        String rhFactor = request.getParameter("rhFactor");
        String city = request.getParameter("city");
        String hospital = request.getParameter("hospital");
        String urgency = request.getParameter("urgency");
        String description = request.getParameter("description");
        String contactInfo = request.getParameter("contactInfo");

        if (patientName == null || bloodType == null || rhFactor == null ||
            city == null || hospital == null || contactInfo == null) {
            request.setAttribute("error", "Все обязательные поля должны быть заполнены");
            request.getRequestDispatcher("/WEB-INF/views/create-request.jsp").forward(request, response);
            return;
        }

        DonationRequest donationRequest = new DonationRequest();
        donationRequest.setAuthorId(user.getId());
        donationRequest.setPatientName(patientName.trim());
        donationRequest.setBloodTypeNeeded(bloodType);
        donationRequest.setRhFactorNeeded(rhFactor);
        donationRequest.setCity(city.trim());
        donationRequest.setHospital(hospital.trim());
        donationRequest.setUrgencyLevel(urgency != null ? urgency : "MEDIUM");
        donationRequest.setDescription(description != null ? description.trim() : "");
        donationRequest.setContactInfo(contactInfo.trim());

        DonationRequest created = requestService.createRequest(donationRequest);

        try {
            String urgencyText = "";
            switch (urgency != null ? urgency : "MEDIUM") {
                case "LOW": urgencyText = "низкой"; break;
                case "MEDIUM": urgencyText = "средней"; break;
                case "HIGH": urgencyText = "высокой"; break;
                case "CRITICAL": urgencyText = "критической"; break;
            }

            Activity activity = new Activity(
                user.getId(),
                "Запрос",
                "Создан запрос на донорство",
                String.format("Создан запрос для пациента %s, группа крови %s%s, срочность: %s",
                    patientName, bloodType, rhFactor.equals("POSITIVE") ? "+" : "-", urgencyText)
            );
            activityDao.createActivity(activity);
        } catch (Exception ignored) {
        }

        response.sendRedirect(request.getContextPath() + "/requests/view?id=" + created.getId());
    }

    private void updateRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {

        User user = (User) request.getSession().getAttribute("user");
        String idParam = request.getParameter("id");

        if (idParam == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID запроса не указан");
            return;
        }

        try {
            Long id = Long.parseLong(idParam);
            DonationRequest existing = requestService.getRequestById(id);

            if (existing == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Запрос не найден");
                return;
            }

            if (!existing.getAuthorId().equals(user.getId())) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Вы не можете редактировать чужой запрос");
                return;
            }

            existing.setPatientName(request.getParameter("patientName").trim());
            existing.setBloodTypeNeeded(request.getParameter("bloodType"));
            existing.setRhFactorNeeded(request.getParameter("rhFactor"));
            existing.setCity(request.getParameter("city").trim());
            existing.setHospital(request.getParameter("hospital").trim());
            existing.setUrgencyLevel(request.getParameter("urgency"));
            existing.setDescription(request.getParameter("description") != null ?
                request.getParameter("description").trim() : "");
            existing.setContactInfo(request.getParameter("contactInfo").trim());

            requestService.updateRequest(existing);

            response.sendRedirect(request.getContextPath() + "/requests/view?id=" + id);

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Некорректный ID");
        }
    }

    private void closeRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {

        User user = (User) request.getSession().getAttribute("user");
        String idParam = request.getParameter("id");

        if (idParam == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID запроса не указан");
            return;
        }

        try {
            Long id = Long.parseLong(idParam);
            DonationRequest existing = requestService.getRequestById(id);

            if (existing == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Запрос не найден");
                return;
            }

            if (!existing.getAuthorId().equals(user.getId())) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Вы не можете редактировать чужой запрос");
                return;
            }

            existing.setStatus("FULFILLED");
            requestService.updateRequest(existing);

            response.sendRedirect(request.getContextPath() + "/requests");

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Некорректный ID");
        }
    }

    private void reopenRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {

        User user = (User) request.getSession().getAttribute("user");
        String idParam = request.getParameter("id");

        if (idParam == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID запроса не указан");
            return;
        }

        try {
            Long id = Long.parseLong(idParam);
            DonationRequest existing = requestService.getRequestById(id);

            if (existing == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Запрос не найден");
                return;
            }

            if (!existing.getAuthorId().equals(user.getId())) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Вы не можете редактировать чужой запрос");
                return;
            }

            existing.setStatus("ACTIVE");
            requestService.updateRequest(existing);

            response.sendRedirect(request.getContextPath() + "/requests");

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Некорректный ID");
        }
    }

    private void deleteRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        String idParam = request.getParameter("id");

        if (idParam == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID запроса не указан");
            return;
        }

        try {
            Long id = Long.parseLong(idParam);
            requestService.deleteRequest(id);
            response.sendRedirect(request.getContextPath() + "/requests");
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Некорректный ID");
        }
    }
}
