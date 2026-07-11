/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.ikaza.controlador;

import com.ikaza.config.Conexion;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.HashMap;
import java.util.Map;

@WebServlet(name = "ProductoServlet", urlPatterns = {"/ProductoServlet"})
public class ProductoServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            // Redirige al Servlet controlador para no perder los datos del inicio
            response.sendRedirect("IndexServlet");
            return;
        }

        Map<String, String> producto = new HashMap<>();
        Conexion con = new Conexion();

        try (Connection connection = con.conectar()) {
            // Se añade LEFT JOIN para traer el nombre de la categoría y los nuevos campos técnicos
            String sql = "SELECT p.*, c.nombre as categoria_nombre " +
                         "FROM productos p " +
                         "LEFT JOIN categorias c ON p.categoria_id = c.id " +
                         "WHERE p.id = ?";
                         
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, Integer.parseInt(idParam));
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                producto.put("id", rs.getString("id"));
                producto.put("nombre", rs.getString("nombre"));
                producto.put("descripcion", rs.getString("descripcion"));
                producto.put("precio", rs.getString("precio"));
                producto.put("imagenUrl", rs.getString("imagen_url"));
                producto.put("stock", rs.getString("stock"));
                
                // Mapeo de las nuevas especificaciones para la ficha técnica
                producto.put("categoria", rs.getString("categoria_nombre") != null ? rs.getString("categoria_nombre") : "General");
                producto.put("material", rs.getString("material") != null ? rs.getString("material") : "No especificado");
                producto.put("alto", rs.getString("alto") != null ? rs.getString("alto") : "0");
                producto.put("ancho", rs.getString("ancho") != null ? rs.getString("ancho") : "0");
                producto.put("profundidad", rs.getString("profundidad") != null ? rs.getString("profundidad") : "0");
                
                request.setAttribute("p", producto);
                request.getRequestDispatcher("producto.jsp").forward(request, response);
            } else {
                response.sendRedirect("IndexServlet");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("IndexServlet");
        }
    }
}
