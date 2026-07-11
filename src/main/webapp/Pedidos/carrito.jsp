<%-- 
    Document   : carrito
    Created on : 24 may. 2026, 21:01:11
    Author     : LISET
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List, com.ikaza.modelo.DetallePedido, com.ikaza.modelo.Mueble, com.ikaza.dao.ProductoDAO"%>
<%
    // LÓGICA DE SEGURIDAD: Si no está logueado, borramos el carrito de la sesión
    Object usuario = session.getAttribute("usuarioLogueado");
    if (usuario == null) {
        session.removeAttribute("carrito");
    }

    // Recuperamos el carrito tras la limpieza
    List<DetallePedido> carrito = (List<DetallePedido>) session.getAttribute("carrito");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mi Carrito de Compras - Ikaza</title>
    <link href="${pageContext.request.contextPath}/assets/css/estilos.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
</head>
<body class="bg-light">

    <nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-4">
        <div class="container">
            <a class="navbar-brand fw-bold" href="IndexServlet">IKAZA</a>
            <a href="${pageContext.request.contextPath}/IndexServlet" class="btn btn-outline-light btn-sm"><i class="bi bi-arrow-left"></i> Seguir Comprando</a>
        </div>
    </nav>

    <div class="container my-5">
        <h2 class="mb-4 fw-bold"><i class="bi bi-cart3"></i> Tu Carrito de Compras</h2>
        
        <%
            if (carrito == null || carrito.isEmpty()) {
        %>
            <div class="text-center py-5 bg-white rounded shadow-sm">
                <i class="bi bi-cart-x text-muted" style="font-size: 4rem;"></i>
                <h4 class="mt-3 text-secondary">Tu carrito está vacío</h4>
                <p class="text-muted">¡Explora nuestro catálogo y añade tus muebles favoritos!</p>
                <a href="${pageContext.request.contextPath}/IndexServlet" class="btn btn-primary mt-2 px-4 fw-bold">Ver Productos</a>
            </div>
        <%
            } else {
                ProductoDAO dao = new ProductoDAO();
                double totalGeneral = 0;
        %>
            <div class="row g-4">
                <div class="col-lg-8">
                    <div class="card border-0 shadow-sm p-3">
                        <div class="table-responsive">
                            <table class="table align-middle">
                                <thead class="table-light">
                                    <tr>
                                        <th>Producto</th>
                                        <th style="width: 120px;">Precio</th>
                                        <th style="width: 160px;">Cantidad</th>
                                        <th style="width: 120px;">Subtotal</th>
                                        <th style="width: 80px;"></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        for (DetallePedido dp : carrito) {
                                            Mueble m = dao.obtenerMueblePorId(dp.getMuebleId());
                                            if (m != null) {
                                                double subtotal = dp.getCantidad() * dp.getPrecioUnitario();
                                                totalGeneral += subtotal;
                                    %>
                                    <tr>
                                        <td>
                                            <div class="d-flex align-items-center">
                                                <img src="<%= m.getImagenUrl() %>" class="rounded me-3" style="width: 60px; height: 60px; object-fit: cover;">
                                                <div>
                                                    <h6 class="mb-0 fw-bold"><%= m.getNombre() %></h6>
                                                </div>
                                            </div>
                                        </td>
                                        <td class="fw-semibold">S/ <%= String.format("%.2f", dp.getPrecioUnitario()) %></td>
                                        <td>
                                            <div class="w-100">
                                                <input type="number" class="form-control form-control-sm text-center" 
                                                       value="<%= dp.getCantidad() %>" min="1" max="<%= m.getStock() %>" 
                                                       onchange="actualizarCantidad(this, <%= m.getId() %>)" required>
                                                <small class="text-muted d-block text-center mt-1" style="font-size: 0.75rem;">
                                                    Máx: <%= m.getStock() %> u.
                                                </small>
                                            </div>
                                        </td>
                                        <td class="fw-bold text-primary">S/ <%= String.format("%.2f", subtotal) %></td>
                                        <td>
                                            <form action="CarritoServlet" method="POST">
                                                <input type="hidden" name="accion" value="eliminar">
                                                <input type="hidden" name="id" value="<%= m.getId() %>">
                                                <button type="submit" class="btn btn-sm btn-outline-danger border-0">
                                                    <i class="bi bi-trash-fill"></i>
                                                </button>
                                            </form>
                                        </td>
                                    </tr>
                                    <% 
                                            }
                                        }
                                    %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <div class="col-lg-4">
                    <div class="card border-0 shadow-sm p-4 bg-white">
                        <h5 class="fw-bold mb-4">Resumen de Orden</h5>
                        <div class="d-flex justify-content-between mb-3 border-bottom pb-2">
                            <span class="text-muted">Productos:</span>
                            <span class="fw-semibold"><%= carrito.size() %></span>
                        </div>
                        <div class="d-flex justify-content-between mb-4">
                            <span class="fs-5 fw-bold">Total General:</span>
                            <span class="fs-5 fw-bold text-primary">S/ <%= String.format("%.2f", totalGeneral) %></span>
                        </div>
                        <a href="checkout.jsp" class="btn btn-primary w-100 py-2.5 fw-bold shadow-sm">
                            Proceder al Pago <i class="bi bi-arrow-right ms-1"></i>
                        </a>
                    </div>
                </div>
            </div>
        <% } %>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Función para actualizar la cantidad sin recargar la página completa, solo refrescando el DOM
        async function actualizarCantidad(input, idMueble) {
            const cantidad = input.value;
            
            // Validar que la cantidad no sea menor a 1
            if (cantidad < 1) {
                input.value = 1;
                return;
            }

            const formData = new FormData();
            formData.append('accion', 'actualizar');
            formData.append('id', idMueble);
            formData.append('cantidad', cantidad);

            try {
                const response = await fetch('CarritoServlet', {
                    method: 'POST',
                    body: formData
                });
                
                if (response.ok) {
                    // Recargamos la página para que los subtotales y el total general se calculen de nuevo
                    window.location.reload();
                } else {
                    alert('Error al actualizar la cantidad.');
                }
            } catch (error) {
                console.error('Error al actualizar:', error);
                alert('No se pudo conectar con el servidor.');
            }
        }
    </script>
</body>
</html>