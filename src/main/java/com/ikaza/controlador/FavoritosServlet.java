/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.ikaza.controlador;

import com.ikaza.dao.ProductoDAO;
import com.ikaza.modelo.Mueble;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "FavoritosServlet", urlPatterns = {"/FavoritosServlet"})
public class FavoritosServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String accion = request.getParameter("accion");
        HttpSession session = request.getSession();
        
        List<Mueble> favoritos = (List<Mueble>) session.getAttribute("favoritos");
        if (favoritos == null) {
            favoritos = new ArrayList<>();
        }

        if ("agregar".equals(accion)) {
            int id = Integer.parseInt(request.getParameter("id"));
            
            // Verificamos que no esté ya en la lista
            boolean existe = favoritos.stream().anyMatch(f -> f.getId() == id);
            
            if (!existe) {
                ProductoDAO dao = new ProductoDAO();
                Mueble m = dao.obtenerMueblePorId(id);
                if (m != null) {
                    favoritos.add(m);
                    session.setAttribute("favoritos", favoritos);
                    response.sendRedirect("ProductoServlet?id=" + id + "&success=favorito_added");
                } else {
                    response.sendRedirect("ProductoServlet?id=" + id);
                }
            } else {
                // Si ya existe, enviamos una señal de info
                response.sendRedirect("ProductoServlet?id=" + id + "&info=ya_en_favoritos");
            }
            
        } else if ("eliminar".equals(accion)) {
            int id = Integer.parseInt(request.getParameter("id"));
            favoritos.removeIf(f -> f.getId() == id);
            session.setAttribute("favoritos", favoritos);
            response.sendRedirect("PerfilServlet");
        }
    }
}
