/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.ikaza.controlador;

import com.ikaza.dao.ProductoDAO;
import com.ikaza.modelo.Mueble;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/GestionProductosServlet")
public class GestionProductosServlet extends HttpServlet {
    ProductoDAO dao = new ProductoDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String nombre = request.getParameter("nombre");
        String minStr = request.getParameter("minPrecio");
        String maxStr = request.getParameter("maxPrecio");
        String catStr = request.getParameter("categoriaIdFiltro");

        Double min = (minStr != null && !minStr.isEmpty()) ? Double.valueOf(minStr) : null;
        Double max = (maxStr != null && !maxStr.isEmpty()) ? Double.valueOf(maxStr) : null;
        Integer cat = (catStr != null && !catStr.isEmpty()) ? Integer.valueOf(catStr) : null;

        request.setAttribute("productos", dao.listar(nombre, min, max, cat));
        request.setAttribute("listaCategorias", dao.listarCategorias());
        request.getRequestDispatcher("admin/gestion_productos.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String accion = request.getParameter("accion");
        if ("eliminar".equals(accion)) {
            dao.eliminar(Integer.parseInt(request.getParameter("id")));
        } else {
            Mueble m = new Mueble();
            m.setNombre(request.getParameter("nombre"));
            m.setPrecio(Double.parseDouble(request.getParameter("precio")));
            m.setStock(Integer.parseInt(request.getParameter("stock")));
            m.setCategoriaId(Integer.parseInt(request.getParameter("categoriaId")));
            m.setMaterial(request.getParameter("material"));
            m.setAlto(Double.parseDouble(request.getParameter("alto")));
            m.setAncho(Double.parseDouble(request.getParameter("ancho")));
            m.setProfundidad(Double.parseDouble(request.getParameter("profundidad")));
            m.setImagenUrl(request.getParameter("imagenUrl")); // Captura de la URL de la imagen
            
            if ("editar".equals(accion)) {
                m.setId(Integer.parseInt(request.getParameter("id")));
                dao.guardar(m, true);
            } else {
                dao.guardar(m, false);
            }
        }
        response.sendRedirect("GestionProductosServlet");
    }
}
