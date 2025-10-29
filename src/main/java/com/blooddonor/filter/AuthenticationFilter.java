package com.blooddonor.filter;

import com.blooddonor.model.User;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter("/*")
public class AuthenticationFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        String path = httpRequest.getRequestURI().substring(httpRequest.getContextPath().length());

        boolean isLoggedIn = (session != null && session.getAttribute("user") != null);
        boolean isLoginPage = path.equals("/login");
        boolean isRegisterPage = path.equals("/register");
        boolean isStaticResource = path.startsWith("/css/") || path.startsWith("/js/") || path.startsWith("/images/");

        if (isLoggedIn && (isLoginPage || isRegisterPage)) {
            // Если пользователь уже вошел, перенаправляем на главную
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/");
            return;
        }

        chain.doFilter(request, response);
    }
}