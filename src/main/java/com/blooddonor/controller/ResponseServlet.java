package com.blooddonor.controller;

import com.blooddonor.dao.ActivityDao;
import com.blooddonor.di.ServiceContainer;
import com.blooddonor.model.Activity;
import com.blooddonor.model.DonationRequest;
import com.blooddonor.model.Response;
import com.blooddonor.model.User;
import com.blooddonor.service.DonationRequestService;
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

@WebServlet("/responses/*")
public class ResponseServlet extends HttpServlet {

    private ResponseService responseService;
    private DonationRequestService requestService;
    private ActivityDao activityDao;

    @Override
    public void init() throws ServletException {
        super.init();
        ServiceContainer container = ServiceContainer.getInstance();
        responseService = container.getService(ResponseService.class);
        requestService = container.getService(DonationRequestService.class);
        activityDao = container.getService(ActivityDao.class);
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
                showMyResponses(request, response);
            } else if (pathInfo.equals("/for-request")) {
                showResponsesForRequest(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            throw new ServletException("Ошибка при получении откликов", e);
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
                createResponse(request, response);
            } else if (pathInfo.equals("/update-status")) {
                updateStatus(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            throw new ServletException("Ошибка при обработке отклика", e);
        }
    }

    private void showMyResponses(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {

        User user = (User) request.getSession().getAttribute("user");
        List<Response> responses = responseService.getResponsesByDonor(user.getId());

        request.setAttribute("responses", responses);
        request.getRequestDispatcher("/WEB-INF/views/my-responses.jsp").forward(request, response);
    }

    private void showResponsesForRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {

        String requestIdParam = request.getParameter("requestId");
        if (requestIdParam == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID запроса не указан");
            return;
        }

        try {
            Long requestId = Long.parseLong(requestIdParam);

            DonationRequest donationRequest = requestService.getRequestById(requestId);
            if (donationRequest == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Запрос не найден");
                return;
            }

            List<Response> responses = responseService.getResponsesByRequest(requestId);

            request.setAttribute("request", donationRequest);
            request.setAttribute("responses", responses);
            response.sendRedirect(request.getContextPath() + "/requests/view?id=" + requestId);

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Некорректный ID");
        }
    }

    private void createResponse(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) request.getSession().getAttribute("user");
        String requestIdParam = request.getParameter("requestId");
        String message = request.getParameter("message");

        if (requestIdParam == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID запроса не указан");
            return;
        }

        try {
            Long requestId = Long.parseLong(requestIdParam);

            Response donorResponse = new Response();
            donorResponse.setRequestId(requestId);
            donorResponse.setDonorId(user.getId());
            donorResponse.setMessage(message != null ? message.trim() : "");

            try {
                responseService.createResponse(donorResponse);

                try {
                    DonationRequest donationRequest = requestService.getRequestById(requestId);
                    if (donationRequest != null) {
                        Activity activity = new Activity(
                            user.getId(),
                            "Отклик",
                            "Отклик на запрос",
                            String.format("Вы откликнулись на запрос для пациента %s (группа крови %s%s)",
                                donationRequest.getPatientName(),
                                donationRequest.getBloodTypeNeeded(),
                                donationRequest.getRhFactorNeeded().equals("POSITIVE") ? "+" : "-")
                        );
                        activityDao.createActivity(activity);
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }

                response.sendRedirect(request.getContextPath() + "/requests/view?id=" + requestId);
            } catch (IllegalArgumentException | IllegalStateException e) {
                request.setAttribute("error", e.getMessage());
                request.setAttribute("requestId", requestId);
                request.getRequestDispatcher("/WEB-INF/views/view-request.jsp").forward(request, response);
            } catch (SQLException e) {
                throw new ServletException("Ошибка базы данных", e);
            }

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Некорректный ID");
        } catch (SecurityException e) {
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/view-request.jsp").forward(request, response);
        }
    }

    private void updateStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");

        String responseIdParam = request.getParameter("responseId");
        String status = request.getParameter("status");
        String requestIdParam = request.getParameter("requestId");

        if (responseIdParam == null || status == null || requestIdParam == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Параметры не указаны");
            return;
        }

        try {
            Long responseId = Long.parseLong(responseIdParam);
            Long requestId = Long.parseLong(requestIdParam);

            DonationRequest donationRequest = requestService.getRequestById(requestId);
            if (donationRequest == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Запрос не найден");
                return;
            }

            if (!donationRequest.getAuthorId().equals(user.getId())) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "У вас нет прав для изменения этого отклика");
                return;
            }

            responseService.updateResponseStatus(responseId, status);

            try {
                String statusText = status.equals("CONTACTED") ? "связались с донором" :
                                  status.equals("REJECTED") ? "отклонили отклик" :
                                  "изменили статус отклика";
                Activity activity = new Activity(
                    user.getId(),
                    "Управление откликами",
                    "Изменение статуса отклика",
                    String.format("Вы %s на запрос для пациента %s", statusText, donationRequest.getPatientName())
                );
                activityDao.createActivity(activity);
            } catch (Exception e) {
                e.printStackTrace();
            }

            response.sendRedirect(request.getContextPath() + "/requests/view?id=" + requestId);

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Некорректный ID");
        } catch (SQLException e) {
            throw new ServletException("Ошибка базы данных при обновлении статуса отклика", e);
        }
    }
}
