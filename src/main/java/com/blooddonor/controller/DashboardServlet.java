package com.blooddonor.controller;

import com.blooddonor.dao.ActivityDao;
import com.blooddonor.di.ServiceContainer;
import com.blooddonor.model.Activity;
import com.blooddonor.model.User;
import com.blooddonor.service.UserService;
import com.blooddonor.service.DonationRequestService;
import com.blooddonor.service.ResponseService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    private UserService userService;
    private ActivityDao activityDao;
    private DonationRequestService requestService;
    private ResponseService responseService;

    @Override
    public void init() throws ServletException {
        super.init();
        ServiceContainer container = ServiceContainer.getInstance();
        userService = container.getService(UserService.class);
        activityDao = container.getService(ActivityDao.class);
        requestService = container.getService(DonationRequestService.class);
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

        User user = (User) session.getAttribute("user");

        try {
            User freshUser = userService.findById(user.getId());
            if (freshUser != null) {
                session.setAttribute("user", freshUser);
                request.setAttribute("user", freshUser);

                List<Activity> recentActivities = activityDao.getRecentActivitiesByUserId(freshUser.getId(), 5);
                request.setAttribute("recentActivities", recentActivities);

                int myRequestsCount = requestService.getRequestsByAuthor(freshUser.getId()).size();
                request.setAttribute("myRequestsCount", myRequestsCount);

                int myResponsesCount = responseService.getResponsesByDonor(freshUser.getId()).size();
                request.setAttribute("myResponsesCount", myResponsesCount);

                int fulfilledRequestsCount = (int) requestService.getRequestsByAuthor(freshUser.getId())
                    .stream()
                    .filter(req -> "FULFILLED".equals(req.getStatus()))
                    .count();
                request.setAttribute("fulfilledRequestsCount", fulfilledRequestsCount);

            } else {
                request.setAttribute("user", user);
            }
        } catch (Exception e) {
            request.setAttribute("user", user);
        }

        request.getRequestDispatcher("/WEB-INF/views/dashboard.jsp").forward(request, response);
    }
}