package com.blooddonor.controller;

import com.blooddonor.dao.ActivityDao;
import com.blooddonor.di.ServiceContainer;
import com.blooddonor.model.Activity;
import com.blooddonor.model.User;
import com.blooddonor.model.DonorProfile;
import com.blooddonor.service.UserService;
import com.blooddonor.service.DonorProfileService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {

    private UserService userService;
    private DonorProfileService donorProfileService;
    private ActivityDao activityDao;

    @Override
    public void init() throws ServletException {
        super.init();
        ServiceContainer container = ServiceContainer.getInstance();
        userService = container.getService(UserService.class);
        donorProfileService = container.getService(DonorProfileService.class);
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

        User user = (User) session.getAttribute("user");

        try {
            User freshUser = userService.findById(user.getId());
            if (freshUser != null) {
                session.setAttribute("user", freshUser);
                request.setAttribute("user", freshUser);
            } else {
                request.setAttribute("user", user);
            }

            DonorProfile donorProfile = donorProfileService.getDonorProfileByUserId(user.getId());
            request.setAttribute("donorProfile", donorProfile);
        } catch (Exception e) {
            request.setAttribute("user", user);
        }

        request.getRequestDispatcher("/WEB-INF/views/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User currentUser = (User) session.getAttribute("user");

        String form = request.getParameter("form");

        if ("delete".equals(form)) {
            handleDeleteProfile(request, response, currentUser, session);
            return;
        }

        if ("donor".equals(form)) {
            handleDonorProfile(request, response, currentUser);
            return;
        }

        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String city = request.getParameter("city");
        String email = request.getParameter("email");

        try {
            currentUser.setFullName(fullName != null ? fullName.trim() : null);
            currentUser.setPhone(phone != null ? phone.trim() : null);
            currentUser.setCity(city != null ? city.trim() : null);
            currentUser.setEmail(email != null ? email.trim() : null);

            boolean success = userService.updateUser(currentUser);

            if (success) {
                User updatedUser = userService.findById(currentUser.getId());
                session.setAttribute("user", updatedUser);
                request.setAttribute("user", updatedUser);
                request.setAttribute("success", "Профиль успешно обновлен!");

                try {
                    Activity activity = new Activity(
                        currentUser.getId(),
                        "Профиль",
                        "Обновление профиля",
                        "Вы обновили информацию в своём профиле"
                    );
                    activityDao.createActivity(activity);
                } catch (Exception ignored) {
                }
            } else {
                request.setAttribute("error", "Ошибка при обновлении профиля в базе данных");
            }

        } catch (Exception e) {
            request.setAttribute("error", "Произошла ошибка при обновлении профиля: " + e.getMessage());
        }

        try {
            DonorProfile donorProfile = donorProfileService.getDonorProfileByUserId(currentUser.getId());
            request.setAttribute("donorProfile", donorProfile);
        } catch (Exception ignored) {}

        request.getRequestDispatcher("/WEB-INF/views/profile.jsp").forward(request, response);
    }

    private void handleDeleteProfile(HttpServletRequest request, HttpServletResponse response, User currentUser, HttpSession session)
            throws ServletException, IOException {
        try {
            boolean success = userService.deleteUser(currentUser.getId());

            if (success) {
                try {
                    Activity activity = new Activity(
                        currentUser.getId(),
                        "Профиль",
                        "Удаление профиля",
                        "Пользователь удалил свой профиль"
                    );
                    activityDao.createActivity(activity);
                } catch (Exception ignored) {
                }

                session.invalidate();
                response.sendRedirect(request.getContextPath() + "/?deleted=true");
            } else {
                request.setAttribute("error", "Ошибка при удалении профиля");
                DonorProfile donorProfile = donorProfileService.getDonorProfileByUserId(currentUser.getId());
                request.setAttribute("donorProfile", donorProfile);
                request.getRequestDispatcher("/WEB-INF/views/profile.jsp").forward(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Произошла ошибка при удалении профиля: " + e.getMessage());
            try {
                DonorProfile donorProfile = donorProfileService.getDonorProfileByUserId(currentUser.getId());
                request.setAttribute("donorProfile", donorProfile);
            } catch (Exception ignored) {}
            request.getRequestDispatcher("/WEB-INF/views/profile.jsp").forward(request, response);
        }
    }

    private void handleDonorProfile(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {
        try {
            String bloodType = request.getParameter("bloodType");
            String rhFactor = request.getParameter("rhFactor");
            String readyParam = request.getParameter("readyToDonate");
            String additionalInfo = request.getParameter("additionalInfo");

            DonorProfile existing = donorProfileService.getDonorProfileByUserId(currentUser.getId());
            boolean isNewProfile = (existing == null);

            DonorProfile profile = existing != null ? existing : new DonorProfile();
            profile.setUserId(currentUser.getId());
            profile.setBloodType(bloodType);
            profile.setRhFactor(rhFactor);
            profile.setReadyToDonate("on".equalsIgnoreCase(readyParam) || "true".equalsIgnoreCase(readyParam));
            profile.setAdditionalInfo(additionalInfo != null ? additionalInfo.trim() : null);

            if (isNewProfile) {
                donorProfileService.createDonorProfile(profile);
                request.setAttribute("success", "Профиль донора создан");

                try {
                    Activity activity = new Activity(
                        currentUser.getId(),
                        "Донор",
                        "Создан профиль донора",
                        String.format("Вы стали донором! Группа крови: %s%s",
                            bloodType, rhFactor.equals("POSITIVE") ? "+" : "-")
                    );
                    activityDao.createActivity(activity);
                } catch (Exception ignored) {
                }
            } else {
                donorProfileService.updateDonorProfile(profile);
                request.setAttribute("success", "Профиль донора обновлен");

                try {
                    Activity activity = new Activity(
                        currentUser.getId(),
                        "Донор",
                        "Обновлен профиль донора",
                        String.format("Обновлена информация донора (группа крови: %s%s)",
                            bloodType, rhFactor.equals("POSITIVE") ? "+" : "-")
                    );
                    activityDao.createActivity(activity);
                } catch (Exception ignored) {
                }
            }

            DonorProfile reloaded = donorProfileService.getDonorProfileByUserId(currentUser.getId());
            request.setAttribute("donorProfile", reloaded);
            request.setAttribute("user", currentUser);

        } catch (Exception e) {
            request.setAttribute("error", "Ошибка при сохранении профиля донора: " + e.getMessage());
        }

        request.getRequestDispatcher("/WEB-INF/views/profile.jsp").forward(request, response);
    }
}
