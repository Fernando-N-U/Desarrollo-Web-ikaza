/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.ikaza.controlador;

import com.ikaza.dao.ProductoDAO;
import com.ikaza.modelo.DetallePedido;
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

@WebServlet(name = "CarritoServlet", urlPatterns = {"/CarritoServlet"})
public class CarritoServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String accion = request.getParameter("accion");
        String origen = request.getParameter("origen");
        HttpSession sesion = request.getSession();
        
        List<DetallePedido> carrito = (List<DetallePedido>) sesion.getAttribute("carrito");
        if (carrito == null) {
            carrito = new ArrayList<>();
        }

        // 1. ACCIÓN: AGREGAR
        if ("agregar".equals(accion)) {
            if (sesion.getAttribute("usuarioLogueado") == null) {
                int idMueble = Integer.parseInt(request.getParameter("id"));
                response.sendRedirect("ProductoServlet?id=" + idMueble + "&error=login_required");
                return;
            }

            int idMueble = Integer.parseInt(request.getParameter("id"));
            String cantParam = request.getParameter("cantidad");
            int cantidadSolicitada = (cantParam != null && !cantParam.isEmpty()) ? Integer.parseInt(cantParam) : 1;

            ProductoDAO dao = new ProductoDAO();
            Mueble mueble = dao.obtenerMueblePorId(idMueble);

            if (mueble != null) {
                int cantidadEnCarrito = 0;
                DetallePedido detalleExistente = null;
                for (DetallePedido dp : carrito) {
                    if (dp.getMuebleId() == idMueble) {
                        cantidadEnCarrito = dp.getCantidad();
                        detalleExistente = dp;
                        break;
                    }
                }

                if ((cantidadEnCarrito + cantidadSolicitada) > mueble.getStock()) {
                    redireccionarSegunOrigen(response, origen, idMueble, "error_stock");
                    return;
                }

                if (detalleExistente != null) {
                    detalleExistente.setCantidad(detalleExistente.getCantidad() + cantidadSolicitada);
                } else {
                    DetallePedido nuevoDetalle = new DetallePedido();
                    nuevoDetalle.setMuebleId(mueble.getId());
                    nuevoDetalle.setPrecioUnitario(mueble.getPrecio());
                    nuevoDetalle.setCantidad(cantidadSolicitada);
                    carrito.add(nuevoDetalle);
                }
            }
            sesion.setAttribute("carrito", carrito);
            redireccionarSegunOrigen(response, origen, idMueble, "added");
        
        // 2. ACCIÓN: ACTUALIZAR (Desde el carrito.jsp)
        } else if ("actualizar".equals(accion)) {
            int idMueble = Integer.parseInt(request.getParameter("id"));
            int nuevaCantidad = Integer.parseInt(request.getParameter("cantidad"));
            
            ProductoDAO dao = new ProductoDAO();
            Mueble mueble = dao.obtenerMueblePorId(idMueble);

            // Validamos que no exceda el stock
            if (mueble != null && nuevaCantidad > 0 && nuevaCantidad <= mueble.getStock()) {
                for (DetallePedido dp : carrito) {
                    if (dp.getMuebleId() == idMueble) {
                        dp.setCantidad(nuevaCantidad);
                        break;
                    }
                }
                sesion.setAttribute("carrito", carrito);
            }
            response.sendRedirect("Pedidos/carrito.jsp");

        // 3. ACCIÓN: ELIMINAR
        } else if ("eliminar".equals(accion)) {
            int idMueble = Integer.parseInt(request.getParameter("id"));
            carrito.removeIf(dp -> dp.getMuebleId() == idMueble);
            sesion.setAttribute("carrito", carrito);
            redireccionarSegunOrigen(response, origen, idMueble, "removed");
        }
    }

    private void redireccionarSegunOrigen(HttpServletResponse response, String origen, int idMueble, String accion) throws IOException {
        String param = (accion.equals("error_stock")) ? "error=out_of_stock" : "success=" + accion;
        
        if ("producto".equals(origen)) {
            response.sendRedirect("ProductoServlet?id=" + idMueble + "&" + param);
        } else if ("catalogo".equals(origen)) {
            response.sendRedirect("catalogo.jsp?" + param);
        } else {
            response.sendRedirect("carrito.jsp");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException { processRequest(request, response); }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException { processRequest(request, response); }
}
