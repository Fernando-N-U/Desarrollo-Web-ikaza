<%-- 
    Document   : checkout
    Created on : 25 may. 2026, 22:25:29
    Author     : LISET
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List, com.ikaza.modelo.DetallePedido, com.ikaza.modelo.Mueble, com.ikaza.dao.ProductoDAO, com.ikaza.modelo.Usuario"%>
<%
    // 1. SEGURIDAD: Verificamos que el usuario esté logueado
    Usuario usuario = (Usuario) session.getAttribute("usuarioLogueado");
    if (usuario == null) {
        response.sendRedirect("login.jsp?error=login_required");
        return;
    }

    // 2. VALIDACIÓN: Verificamos que el carrito no esté vacío
    List<DetallePedido> carrito = (List<DetallePedido>) session.getAttribute("carrito");
    if (carrito == null || carrito.isEmpty()) {
        response.sendRedirect("carrito.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout - Ikaza</title>
    <link href="${pageContext.request.contextPath}/assets/css/estilos.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
</head>
<body class="bg-light">

    <nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-4">
        <div class="container">
            <a class="navbar-brand fw-bold" href="IndexServlet">IKAZA</a>
            <a href="carrito.jsp" class="btn btn-outline-light btn-sm"><i class="bi bi-arrow-left"></i> Volver al Carrito</a>
        </div>
    </nav>

    <div class="container my-5">
        <div class="text-center mb-5">
            <h2 class="fw-bold">Finalizar Compra</h2>
            <p class="text-muted">Confirma tu dirección de envío para procesar tu pedido</p>
        </div>

        <div class="row g-5">
            <div class="col-md-7 col-lg-8">
                <div class="card border-0 shadow-sm p-4">
                    <h4 class="mb-4 fw-bold"><i class="bi bi-person-lines-fill text-primary me-2"></i> Tus Datos</h4>
                    
                    <form action="${pageContext.request.contextPath}/ProcesarPedidoServlet" method="POST">
                        <div class="row g-3">
                            <div class="col-sm-6">
                                <label class="form-label text-muted">Nombres</label>
                                <input type="text" class="form-control bg-light" value="<%= usuario.getNombre() %>" readonly>
                            </div>
                            <div class="col-12">
                                <label class="form-label text-muted">Teléfono asociado</label>
                                <input type="tel" class="form-control bg-light" value="<%= usuario.getTelefono() %>" readonly>
                            </div>

                            <hr class="my-4">

                            <div class="col-12">
                                <h4 class="mb-3 fw-bold"><i class="bi bi-geo-alt-fill text-danger me-2"></i> Dirección de Envío</h4>
                                <label for="direccion" class="form-label fw-semibold">Ingresa la dirección exacta para la entrega *</label>
                                <input type="text" class="form-control border-primary" id="direccion" name="direccion" placeholder="Ej: Av. Principal 123, Urb. Las Flores" required autofocus>
                            </div>
                        </div>

                        <hr class="my-4">

                        <h4 class="mb-3 fw-bold"><i class="bi bi-wallet2 text-success me-2"></i> Método de Pago</h4>
                        <div class="row g-3 mb-4">
                            <div class="col-md-6">
                                <div class="card p-3 border shadow-sm h-100">
                                    <div class="form-check">
                                        <input id="yapeplin" name="metodoPago" type="radio" class="form-check-input" value="yape_plin" checked>
                                        <label class="form-check-label fw-bold text-dark" for="yapeplin">
                                            <i class="bi bi-qr-code text-info me-1"></i> Pago con Yape o Plin
                                        </label>
                                    </div>
                                    <p class="small mb-0 text-muted mt-2">
                                        Se generará un código QR y número celular para que puedas realizar tu transferencia directa desde tu app móvil.
                                    </p>
                                </div>
                            </div>

                            <div class="col-md-6">
                                <div class="card p-3 border shadow-sm h-100">
                                    <div class="form-check">
                                        <input id="cuentabancaria" name="metodoPago" type="radio" class="form-check-input" value="cuenta_bancaria">
                                        <label class="form-check-label fw-bold text-dark" for="cuentabancaria">
                                            <i class="bi bi-bank text-primary me-1"></i> Transferencia Bancaria
                                        </label>
                                    </div>
                                    <p class="small mb-0 text-muted mt-2">
                                        Te mostraremos las cuentas corrientes (BCP, Interbank, etc.) y códigos interbancarios (CCI) para tu depósito.
                                    </p>
                                </div>
                            </div>
                        </div>

                        <hr class="my-4">

                        <button class="w-100 btn btn-primary btn-lg fw-bold shadow" type="submit">
                            <i class="bi bi-check2-circle me-2"></i> Confirmar Pedido
                        </button>
                    </form>
                </div>
            </div>

            <div class="col-md-5 col-lg-4 order-md-last">
                <div class="card border-0 shadow-sm p-4 bg-white sticky-top" style="top: 20px;">
                    <h5 class="d-flex justify-content-between align-items-center mb-4">
                        <span class="text-primary fw-bold">Resumen de Orden</span>
                        <span class="badge bg-primary rounded-pill"><%= carrito.size() %></span>
                    </h5>
                    <ul class="list-group list-group-flush mb-3">
                        <%
                            ProductoDAO dao = new ProductoDAO();
                            double total = 0;
                            for (DetallePedido dp : carrito) {
                                Mueble m = dao.obtenerMueblePorId(dp.getMuebleId());
                                if (m != null) {
                                    double subtotal = dp.getCantidad() * dp.getPrecioUnitario();
                                    total += subtotal;
                        %>
                        <li class="list-group-item d-flex justify-content-between lh-sm px-0 py-3">
                            <div>
                                <h6 class="my-0 fw-semibold"><%= m.getNombre() %></h6>
                                <small class="text-muted">Cant: <%= dp.getCantidad() %></small>
                            </div>
                            <span class="text-muted">S/ <%= String.format("%.2f", subtotal) %></span>
                        </li>
                        <%
                                }
                            }
                        %>
                        <li class="list-group-item d-flex justify-content-between px-0 py-3 bg-light rounded mt-2 border-0">
                            <span class="fw-bold">Total a Pagar</span>
                            <strong class="text-primary fs-5">S/ <%= String.format("%.2f", total) %></strong>
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
