/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.ikaza.controlador;

import com.ikaza.dao.PedidoDAO;
import com.ikaza.modelo.Pedido;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "GestionPedidosServlet", urlPatterns = {"/GestionPedidosServlet"})
public class GestionPedidosServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Validar Seguridad (Solo Admin o Empleado)
        HttpSession sesion = request.getSession(false);
        String rol = (sesion != null) ? (String) sesion.getAttribute("rol") : null;
        if (rol == null || (!rol.equals("admin") && !rol.equals("empleado"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        // 2. Capturar parámetros de los filtros de búsqueda
        String estado = request.getParameter("estadoFiltro");
        String cliente = request.getParameter("clienteFiltro");
        String fecha = request.getParameter("fechaFiltro");

        // 3. Consultar a la base de datos
        PedidoDAO dao = new PedidoDAO();
        List<Pedido> listaPedidos = dao.listarPedidosAdmin(estado, cliente, fecha);
        // 4. Enviar a la vista
        request.setAttribute("pedidos", listaPedidos);
        request.getRequestDispatcher("admin/gestion_pedidos.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Validación de seguridad para acciones POST
        HttpSession sesion = request.getSession(false);
        String rol = (sesion != null) ? (String) sesion.getAttribute("rol") : null;
        if (rol == null || (!rol.equals("admin") && !rol.equals("empleado"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        String accion = request.getParameter("accion");
        
        if ("actualizar".equals(accion)) {
            int id = Integer.parseInt(request.getParameter("id"));
            String estadoActual = request.getParameter("estadoActual");
            String nuevoEstado = request.getParameter("nuevoEstado");

            boolean transicionValida = false;

            // REGLAS ESTRICTAS DE TRANSICIÓN DE ESTADOS
            if (nuevoEstado.equals("Cancelado") && !estadoActual.equals("Finalizado")) {
                transicionValida = true; // Se puede cancelar si no está finalizado
            } else if (nuevoEstado.equals("En camino") && estadoActual.equals("Espera")) {
                transicionValida = true; 
            } else if (nuevoEstado.equals("Enviado") && estadoActual.equals("En camino")) {
                transicionValida = true;
            } else if (nuevoEstado.equals("Finalizado") && estadoActual.equals("Enviado")) {
                transicionValida = true;
            }

            // Si se cumplen las reglas, actualizamos la base de datos
            if (transicionValida) {
                PedidoDAO dao = new PedidoDAO();
                dao.actualizarEstado(id, nuevoEstado);
            }
        }
        
        // Recargamos la página limpiando el formulario POST
        response.sendRedirect("GestionPedidosServlet");
    }
}
