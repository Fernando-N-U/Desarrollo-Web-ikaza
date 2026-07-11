package com.ikaza.controlador;

import com.ikaza.config.Conexion;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet(name = "CatalogoAPIServlet", urlPatterns = {"/api/productos"})
public class CatalogoAPIServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        String termino = request.getParameter("q");
        String minStr = request.getParameter("min");
        String maxStr = request.getParameter("max");
        String soloStock = request.getParameter("stock");
        String categoriaId = request.getParameter("cat"); // NUEVO FILTRO

        Conexion con = new Conexion();
        try (Connection connection = con.conectar(); PrintWriter out = response.getWriter()) {
            
            // Hacemos un INNER JOIN para traer el nombre de la categoría también
            StringBuilder sql = new StringBuilder(
                "SELECT p.*, c.nombre as categoria_nombre " +
                "FROM productos p " +
                "LEFT JOIN categorias c ON p.categoria_id = c.id " +
                "WHERE p.nombre ILIKE ?"
            );
            
            if (minStr != null && !minStr.isEmpty()) sql.append(" AND p.precio >= ?");
            if (maxStr != null && !maxStr.isEmpty()) sql.append(" AND p.precio <= ?");
            if ("true".equals(soloStock)) sql.append(" AND p.stock > 0");
            if (categoriaId != null && !categoriaId.isEmpty()) sql.append(" AND p.categoria_id = ?");
            
            sql.append(" ORDER BY p.id DESC");

            PreparedStatement ps = connection.prepareStatement(sql.toString());
            
            int paramIndex = 1;
            ps.setString(paramIndex++, "%" + (termino == null ? "" : termino) + "%");
            if (minStr != null && !minStr.isEmpty()) ps.setDouble(paramIndex++, Double.parseDouble(minStr));
            if (maxStr != null && !maxStr.isEmpty()) ps.setDouble(paramIndex++, Double.parseDouble(maxStr));
            if (categoriaId != null && !categoriaId.isEmpty()) ps.setInt(paramIndex++, Integer.parseInt(categoriaId));

            ResultSet rs = ps.executeQuery();
            
            StringBuilder json = new StringBuilder("[");
            boolean primero = true;
            while (rs.next()) {
                if (!primero) json.append(",");
                json.append("{");
                json.append("\"id\":").append(rs.getInt("id")).append(",");
                json.append("\"nombre\":\"").append(rs.getString("nombre")).append("\",");
                json.append("\"precio\":").append(rs.getDouble("precio")).append(",");
                json.append("\"stock\":").append(rs.getInt("stock")).append(",");
                json.append("\"imagenUrl\":\"").append(rs.getString("imagen_url")).append("\",");
                json.append("\"categoria\":\"").append(rs.getString("categoria_nombre")).append("\",");
                json.append("\"material\":\"").append(rs.getString("material") != null ? rs.getString("material") : "").append("\",");
                json.append("\"medidas\":\"").append(rs.getString("alto")).append("x").append(rs.getString("ancho")).append("x").append(rs.getString("profundidad")).append(" cm\"");
                json.append("}");
                primero = false;
            }
            json.append("]");
            
            out.print(json.toString());
        } catch (Exception e) {
            // Obligamos a Java a enviarle el error real a tu F12 en formato JSON
            response.setStatus(500);
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().print("{\"error\": \"Error en BD: " + e.getMessage().replace("\"", "'") + "\"}");
            e.printStackTrace();
        }
    }
}