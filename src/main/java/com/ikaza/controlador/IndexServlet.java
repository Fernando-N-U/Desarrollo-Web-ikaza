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
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "IndexServlet", urlPatterns = {"/IndexServlet", "/inicio"})
public class IndexServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        List<Map<String, String>> productosDestacados = new ArrayList<>();
        Conexion con = new Conexion();
        
        try (Connection connection = con.conectar()) {
            // Traer 3 aleatorios
            String sql = "SELECT * FROM productos ORDER BY RANDOM() LIMIT 3";
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Map<String, String> p = new HashMap<>();
                p.put("id", rs.getString("id"));
                p.put("nombre", rs.getString("nombre"));
                p.put("descripcion", rs.getString("descripcion"));
                p.put("precio", rs.getString("precio"));
                // Importante: tu JSP lee "imagenUrl" sin guion bajo
                p.put("imagenUrl", rs.getString("imagen_url")); 
                productosDestacados.add(p);
            }
            
            request.setAttribute("productos", productosDestacados);
            request.getRequestDispatcher("index.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
