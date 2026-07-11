/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.ikaza.controlador;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

//@WebFilter("/admin/gestion_usuarios.jsp")
public class FiltroAdmin implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Método requerido por Tomcat para inicializar el filtro
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) 
            throws IOException, ServletException {
        
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        String rol = (session != null) ? (String) session.getAttribute("rol") : null;

        if ("admin".equals(rol)) {
            chain.doFilter(request, response); // Deja pasar al admin
        } else {
            // Redirige a la raíz de la tienda de forma segura
            res.sendRedirect(req.getContextPath() + "/index.jsp"); 
        }
    }

    @Override
    public void destroy() {
        // Método requerido por Tomcat para apagar el filtro
    }
}
