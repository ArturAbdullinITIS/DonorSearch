package com.blooddonor.filter;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebFilter(value = "/*", asyncSupported = true)
public class EncodingFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        if (request instanceof HttpServletRequest) {
            HttpServletResponse httpResponse = (HttpServletResponse) response;
            httpResponse.setHeader("Content-Type", "text/html; charset=UTF-8");
        }

        System.out.println("🔧 EncodingFilter: UTF-8 установлена");
        chain.doFilter(request, response);
    }
}