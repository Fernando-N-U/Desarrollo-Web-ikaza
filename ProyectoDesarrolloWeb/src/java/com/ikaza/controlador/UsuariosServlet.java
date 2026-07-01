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
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "UsuariosServlet", urlPatterns = {"/UsuariosServlet"})
public class UsuariosServlet extends HttpServlet {

    // Método para LISTAR, FILTRAR, BUSCAR y ORDENAR usuarios
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Bloqueo de seguridad: Solo admin puede acceder
        HttpSession sesion = request.getSession();
        if (!"admin".equals(sesion.getAttribute("rol"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Capturar los parámetros de búsqueda y filtrado enviados desde el JSP
        String txtBuscar = request.getParameter("txtBuscar");
        String txtRol = request.getParameter("txtRol");

        List<Map<String, String>> listaUsuarios = new ArrayList<>();
        Conexion con = new Conexion();

        // Construcción dinámica de la consulta SQL
        // Excluimos la palabra 'admin' (ignorando mayúsculas/minúsculas con LOWER)
        StringBuilder sql = new StringBuilder("SELECT id, nombre, correo, rol FROM usuarios WHERE LOWER(rol) != 'admin'");

        if (txtBuscar != null && !txtBuscar.isEmpty()) {
            sql.append(" AND nombre ILIKE ?");
        }
        if (txtRol != null && !txtRol.isEmpty()) {
            sql.append(" AND rol = ?");
        }
        
        // REQUISITO: Ordenar por orden alfabético por nombre por defecto
        sql.append(" ORDER BY nombre ASC");

        try (Connection connection = con.conectar()) {
            PreparedStatement ps = connection.prepareStatement(sql.toString());
            
            int paramIndex = 1;
            if (txtBuscar != null && !txtBuscar.isEmpty()) {
                ps.setString(paramIndex++, "%" + txtBuscar + "%");
            }
            if (txtRol != null && !txtRol.isEmpty()) {
                ps.setString(paramIndex++, txtRol);
            }

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, String> usuario = new HashMap<>();
                usuario.put("id", rs.getString("id"));
                usuario.put("nombre", rs.getString("nombre"));
                usuario.put("correo", rs.getString("correo"));
                usuario.put("rol", rs.getString("rol"));
                listaUsuarios.add(usuario);
            }
            
            // Pasamos los parámetros de vuelta al JSP para que mantenga lo que el usuario escribió
            request.setAttribute("usuarios", listaUsuarios);
            request.setAttribute("paramBuscar", txtBuscar);
            request.setAttribute("paramRol", txtRol);
            
            request.getRequestDispatcher("admin/gestion_usuarios.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin/admin_panel.jsp");
        }
    }

    // Método para CAMBIAR EL ROL (Con protecciones de seguridad críticas)
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Doble verificación de sesión en la petición POST
        HttpSession sesion = request.getSession();
        if (!"admin".equals(sesion.getAttribute("rol"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        String idUsuario = request.getParameter("id");
        String nuevoRol = request.getParameter("nuevoRol");

        // BLOQUEO DE SEGURIDAD INTERNO:
        // Si un gracioso altera el HTML para enviar "admin" o "ADMIN", el servidor lo rechaza inmediatamente.
        if (nuevoRol == null || "admin".equalsIgnoreCase(nuevoRol)) {
            response.sendRedirect("UsuariosServlet?error=seguridad");
            return;
        }

        Conexion con = new Conexion();
        try (Connection connection = con.conectar()) {
            // Protección extra: El UPDATE no afectará a ningún admin aunque alteren el ID por consola
            String sql = "UPDATE usuarios SET rol = ? WHERE id = ? AND LOWER(rol) != 'admin'";
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, nuevoRol);
            ps.setInt(2, Integer.parseInt(idUsuario));
            ps.executeUpdate();
            
            response.sendRedirect("UsuariosServlet");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("UsuariosServlet?error=true");
        }
    }
}
