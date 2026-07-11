<%-- 
    Document   : perfil
    Created on : 23 may. 2026, 01:01:59
    Author     : LISET
--%>

<%@ page import="com.ikaza.modelo.Usuario" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %> <%-- Nueva taglib útil para formatear fechas y dinero --%>
<%
    Usuario u = (Usuario) session.getAttribute("usuarioLogueado");
    if (u == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mi Perfil - iKaza</title>
    <link href="${pageContext.request.contextPath}/assets/css/estilos.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
</head>
<body class="bg-light">

    <div class="container mt-5">
        <div class="row justify-content-center">
            
            <%-- SECCIÓN IZQUIERDA: Formulario de Datos Personales --%>
            <div class="col-lg-4 mb-4">
                <div class="card shadow-sm">
                    <div class="card-body p-4">
                        <h2 class="card-title text-center mb-4">Mi Cuenta</h2>
                        
                        <% if (request.getAttribute("mensaje") != null) { %>
                            <div class="alert alert-success"><%= request.getAttribute("mensaje") %></div>
                        <% } %>
                        <% if (request.getAttribute("error") != null) { %>
                            <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
                        <% } %>

                        <div class="bg-light border p-3 rounded mb-4">
                            <p class="mb-1"><strong>Nombre:</strong> <%= u.getNombre() %></p>
                            <p class="mb-1"><strong>Correo:</strong> <%= u.getCorreo() %></p>
                            <p class="mb-0"><strong>Rol:</strong> <span class="badge bg-secondary"><%= u.getRol().toUpperCase() %></span></p>
                        </div>

                        <form action="PerfilServlet" method="POST">
                            <h5 class="mb-3">Datos de contacto</h5>
                            
                            <div class="mb-3">
                                <label class="form-label">DNI (8 dígitos):</label>
                                <input type="number" name="txtDni" class="form-control" 
                                       value="<%= u.getDni() == 0 ? "" : u.getDni() %>" required 
                                       oninput="if(this.value.length > 8) this.value = this.value.slice(0,8);" 
                                       placeholder="Ingrese 8 dígitos">
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Teléfono (9 dígitos):</label>
                                <input type="number" name="txtTelefono" class="form-control" 
                                       value="<%= u.getTelefono() == 0 ? "" : u.getTelefono() %>" required 
                                       oninput="if(this.value.length > 9) this.value = this.value.slice(0,9);" 
                                       placeholder="Ingrese 9 dígitos">
                            </div>

                            <button type="submit" class="btn btn-success w-100">Guardar Cambios</button>
                        </form>
                        
                        <div class="text-center mt-3">
                            <a href="IndexServlet" class="text-decoration-none"><i class="bi bi-shop"></i> Volver a la Tienda</a>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-lg-8 mb-4">
                <div class="card shadow-sm h-100">
                    <div class="card-body p-4">
                        <h3 class="card-title mb-4"><i class="bi bi-box-seam text-primary"></i> Mi Historial de Pedidos</h3>
                        
                        <c:choose>
                            <c:when test="${empty requestScope.misPedidos}">
                                <div class="text-center py-5">
                                    <i class="bi bi-bag-x text-muted" style="font-size: 3rem;"></i>
                                    <p class="text-muted mt-2">Aún no has realizado ninguna compra en nuestra tienda.</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="table-responsive">
                                    <table class="table table-hover align-middle">
                                        <thead class="table-light">
                                            <tr>
                                                <th>Nº Pedido</th>
                                                <th>Descripción</th>
                                                <th>Fecha</th>
                                                <th>Total</th>
                                                <th class="text-center">Estado</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="p" items="${requestScope.misPedidos}">
                                                <tr>
                                                    <td><strong># ${p.id}</strong></td>
                                                    <%-- Cambiamos la celda de descripción --%>
                                                    <td style="white-space: normal; word-break: break-word; min-width: 250px;">
                                                        ${p.nombre}
                                                    </td>
                                                    <td><fmt:formatDate value="${p.fecha}" pattern="dd/MM/yyyy HH:mm"/></td>
                                                    <td class="fw-bold text-success">S/ ${p.total}</td>
                                                    <td class="text-center">
                                                        <%-- Evaluamos el estado usando c:choose para asignar colores dinámicos --%>
                                                        <c:choose>
                                                            <c:when test="${p.estado eq 'Espera'}">
                                                                <span class="badge bg-warning text-dark px-3 py-2"><i class="bi bi-clock-history"></i> Espera</span>
                                                            </c:when>
                                                            <c:when test="${p.estado eq 'Procesando'}">
                                                                <span class="badge bg-info text-dark px-3 py-2"><i class="bi bi-gear-fill"></i> Procesando</span>
                                                            </c:when>
                                                            <c:when test="${p.estado eq 'Entregado'}">
                                                                <span class="badge bg-success px-3 py-2"><i class="bi bi-check-circle-fill"></i> Entregado</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-secondary px-3 py-2">${p.estado}</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

        </div> <%-- Fin row --%>

        <%-- SECCIÓN INFERIOR: Favoritos --%>
        <div class="row mt-4">
            <div class="col-12">
                <div class="card shadow-sm mb-5">
                    <div class="card-body p-4">
                        <h3 class="card-title mb-4"><i class="bi bi-heart-fill text-danger"></i> Mis Productos Favoritos</h3>
                        
                        <c:if test="${empty sessionScope.favoritos}">
                            <p class="text-center text-muted my-4">Aún no tienes productos guardados en favoritos.</p>
                        </c:if>
                        
                        <div class="row">
                            <c:forEach var="fav" items="${sessionScope.favoritos}">
                                <div class="col-md-3 mb-4">
                                    <div class="card h-100 shadow-sm border-0 bg-light">
                                        <img src="${fav.imagenUrl}" class="card-img-top" style="height: 180px; object-fit: cover;">
                                        <div class="card-body text-center">
                                            <h5 class="card-title fw-bold">${fav.nombre}</h5>
                                            <p class="text-primary fw-bold mb-3">S/ ${fav.precio}</p>
                                            
                                            <form action="CarritoServlet" method="POST" class="mb-2">
                                                <input type="hidden" name="accion" value="agregar">
                                                <input type="hidden" name="id" value="${fav.id}">
                                                <input type="hidden" name="origen" value="perfil">
                                                <button type="submit" class="btn btn-primary w-100 btn-sm fw-bold">
                                                    <i class="bi bi-cart-plus"></i> Añadir al Carrito
                                                </button>
                                            </form>
                                            
                                            <form action="FavoritosServlet" method="POST">
                                                <input type="hidden" name="accion" value="eliminar">
                                                <input type="hidden" name="id" value="${fav.id}">
                                                <button type="submit" class="btn btn-outline-danger btn-sm w-100">
                                                    <i class="bi bi-trash"></i> Quitar
                                                </button>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </div> <%-- Fin container --%>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>