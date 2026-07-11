/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.ikaza.controlador;

import com.ikaza.dao.PedidoDAO;
import com.ikaza.dao.ProductoDAO;
import com.ikaza.modelo.DetallePedido;
import com.ikaza.modelo.Mueble;
import com.ikaza.modelo.Pedido;
import com.ikaza.modelo.Usuario;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Timestamp;
import java.sql.Date;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "ProcesarPedidoServlet", urlPatterns = {"/ProcesarPedidoServlet"})
public class ProcesarPedidoServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        
        // 1. Validar seguridad y carrito
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogueado");
        List<DetallePedido> carrito = (List<DetallePedido>) session.getAttribute("carrito");
        
        if (usuario == null || carrito == null || carrito.isEmpty()) {
            response.sendRedirect("IndexServlet");
            return;
        }

        // 2. Obtener los datos ingresados en el checkout
        String direccionEnvio = request.getParameter("direccion");
        String metodoPago = request.getParameter("metodoPago"); // 🌟 NUEVO: Captura el método de pago seleccionado
        
        // 3. Calcular el total del pedido y CONSTRUIR DESCRIPCIÓN DINÁMICA
        double totalPedido = 0;
        StringBuilder sb = new StringBuilder();
        ProductoDAO prodDAO = new ProductoDAO();
        
        for (DetallePedido dp : carrito) {
            // Calcular total
            totalPedido += (dp.getCantidad() * dp.getPrecioUnitario());
            
            // Obtener nombre del producto
            Mueble m = prodDAO.obtenerMueblePorId(dp.getMuebleId());
            String nombreMueble = (m != null) ? m.getNombre() : "Producto ID: " + dp.getMuebleId();
            
            // Construir cadena: "2x Silla, 1x Mesa, "
            sb.append(dp.getCantidad()).append("x ").append(nombreMueble).append(", ");
        }

        // Limpiar la última coma y espacio sobrante
        String descripcionFinal = sb.toString();
        if (descripcionFinal.length() > 2) {
            descripcionFinal = descripcionFinal.substring(0, descripcionFinal.length() - 2);
        }

        // 4. Preparar el objeto Pedido principal con el estado "Espera"
        Pedido nuevoPedido = new Pedido();
        nuevoPedido.setUsuarioId(usuario.getId());
        nuevoPedido.setFecha(new Timestamp(System.currentTimeMillis()));
        nuevoPedido.setEstado("Espera"); 
        nuevoPedido.setTotal(totalPedido);
        nuevoPedido.setNombre(descripcionFinal); // Ahora tiene la lista de productos

        // 5. Preparar variables de fecha actual para detalle_pedidos
        Date fechaActual = new Date(System.currentTimeMillis());
        
        for (DetallePedido dp : carrito) {
            dp.setDireccion(direccionEnvio);
            dp.setFechaInicio(fechaActual); 
            dp.setFechaFin(fechaActual); 
        }

        // 6. Ejecutar la transacción
        try {
            PedidoDAO pedidoDAO = new PedidoDAO();
            boolean exito = pedidoDAO.crearPedido(nuevoPedido, carrito);

            if (exito) {
                session.removeAttribute("carrito");
                
                // 🌟 NUEVO: Lógica de redirección condicional según el método de pago
                if ("cuenta_bancaria".equals(metodoPago)) {
                    response.sendRedirect("Pedidos/exito_bancaria.jsp");
                } else {
                    response.sendRedirect("Pedidos/exito_yape.jsp");
                }
                
            } else {
                response.setContentType("text/html;charset=UTF-8");
                try (PrintWriter out = response.getWriter()) {
                    out.println("<h2>❌ Error: No se pudo procesar el pedido.</h2>");
                }
            }
        } catch (Exception e) {
            response.setContentType("text/plain;charset=UTF-8");
            try (PrintWriter out = response.getWriter()) {
                out.println("=======================================================");
                out.println("        ⚠️ DETECTOR DE ERRORES CRÍTICOS EN VIVO ⚠️       ");
                out.println("=======================================================");
                out.println("Mensaje del error: " + e.getMessage());
                e.printStackTrace(out);
            }
        }
    }
}
