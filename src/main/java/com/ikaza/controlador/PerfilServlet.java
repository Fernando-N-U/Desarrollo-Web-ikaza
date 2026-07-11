/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.ikaza.controlador;

import com.ikaza.config.Conexion;
import com.ikaza.dao.PedidoDAO; // Importamos el DAO de Pedidos
import com.ikaza.modelo.Pedido;
import com.ikaza.modelo.Usuario; 
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.List;

@WebServlet(name = "PerfilServlet", urlPatterns = {"/PerfilServlet"})
public class PerfilServlet extends HttpServlet {

    // Para cargar los datos al entrar a la página
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession sesion = request.getSession(false);
        if (sesion == null || sesion.getAttribute("usuarioLogueado") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        Usuario u = (Usuario) sesion.getAttribute("usuarioLogueado");
        
        // Buscamos los pedidos del usuario y los guardamos en el alcance del Request
        PedidoDAO pedidoDAO = new PedidoDAO();
        List<Pedido> misPedidos = pedidoDAO.listarPedidosPorUsuario(u.getId());
        request.setAttribute("misPedidos", misPedidos);

        request.getRequestDispatcher("perfil.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession sesion = request.getSession(false);
        if (sesion == null || sesion.getAttribute("usuarioLogueado") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        Usuario u = (Usuario) sesion.getAttribute("usuarioLogueado");

        try {
            int dni = Integer.parseInt(request.getParameter("txtDni"));
            int telefono = Integer.parseInt(request.getParameter("txtTelefono"));

            Conexion con = new Conexion();
            try (Connection connection = con.conectar()) {
                String sql = "UPDATE usuarios SET \"DNI\" = ?, telefono = ? WHERE id = ?";
                PreparedStatement ps = connection.prepareStatement(sql);
                ps.setInt(1, dni);
                ps.setInt(2, telefono);
                ps.setInt(3, u.getId()); 

                int filasAfectadas = ps.executeUpdate();

                if (filasAfectadas > 0) {
                    u.setDni(dni);
                    u.setTelefono(telefono);
                    sesion.setAttribute("usuarioLogueado", u);
                    request.setAttribute("mensaje", "¡Datos actualizados correctamente!");
                } else {
                    request.setAttribute("error", "No se pudieron actualizar los datos.");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error interno al actualizar.");
        }

        // CARGA DE SEGURIDAD EN POST: Cargamos los pedidos antes de recargar la vista
        PedidoDAO pedidoDAO = new PedidoDAO();
        List<Pedido> misPedidos = pedidoDAO.listarPedidosPorUsuario(u.getId());
        request.setAttribute("misPedidos", misPedidos);

        request.getRequestDispatcher("perfil.jsp").forward(request, response);
    }
}