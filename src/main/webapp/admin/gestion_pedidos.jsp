<%-- 
    Document   : gestion_pedidos.jsp
    Created on : 26 may. 2026, 17:57:44
    Author     : LISET
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%
    HttpSession sesion = request.getSession(false);
    String rol = (sesion != null) ? (String) sesion.getAttribute("rol") : null;
    if (rol == null || (!rol.equals("admin") && !rol.equals("empleado"))) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Gestión de Pedidos - Ikaza</title>
    <link href="${pageContext.request.contextPath}/assets/css/estilos.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
</head>
<body class="bg-light">

    <div class="container mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="fw-bold"><i class="bi bi-cart-check text-success me-2"></i>Gestión de Pedidos</h2>
            <a href="admin/admin_panel.jsp" class="btn btn-outline-secondary"><i class="bi bi-arrow-left"></i> Volver al Panel</a>
        </div>

        <div class="card shadow-sm border-0 mb-4">
            <div class="card-body">
                <form action="GestionPedidosServlet" method="GET" class="row g-3 align-items-end">
                    <div class="col-md-3">
                        <label class="form-label fw-bold">Nombre del Cliente</label>
                        <input type="text" class="form-control" name="clienteFiltro" placeholder="Ej. Juan Pérez" value="${param.clienteFiltro}">
                    </div>
                    <div class="col-md-3">
                        <label class="form-label fw-bold">Estado</label>
                        <select class="form-select" name="estadoFiltro">
                            <option value="">Todos</option>
                            <option value="Espera" ${param.estadoFiltro == 'Espera' ? 'selected' : ''}>Espera</option>
                            <option value="En camino" ${param.estadoFiltro == 'En camino' ? 'selected' : ''}>En camino</option>
                            <option value="Enviado" ${param.estadoFiltro == 'Enviado' ? 'selected' : ''}>Enviado</option>
                            <option value="Finalizado" ${param.estadoFiltro == 'Finalizado' ? 'selected' : ''}>Finalizado</option>
                            <option value="Cancelado" ${param.estadoFiltro == 'Cancelado' ? 'selected' : ''}>Cancelado</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label fw-bold">Fecha</label>
                        <input type="date" class="form-control" name="fechaFiltro" value="${param.fechaFiltro}">
                    </div>
                    <div class="col-md-3">
                        <button type="submit" class="btn btn-primary w-100"><i class="bi bi-search me-1"></i> Filtrar</button>
                    </div>
                </form>
            </div>
        </div>

        <div class="card shadow-sm border-0">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-dark">
                            <tr>
                                <th>Nº</th>
                                <th>Cliente</th>
                                <th>Dirección</th> <th style="width: 25%;">Descripción</th>
                                <th>Fecha</th>
                                <th>Total</th>
                                <th class="text-center">Estado</th>
                                <th class="text-center">Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="p" items="${pedidos}">
                                <tr>
                                    <td><strong># ${p.id}</strong></td>
                                    <td>${p.nombreCliente}</td>
                                    <td>${p.direccion}</td> <td style="white-space: normal; word-break: break-word;">${p.nombre}</td>
                                    <td><fmt:formatDate value="${p.fecha}" pattern="dd/MM/yyyy HH:mm"/></td>
                                    <td class="fw-bold text-success">S/ ${p.total}</td>
                                    <td class="text-center">
                                        <span class="badge 
                                            ${p.estado == 'Espera' ? 'bg-warning text-dark' : ''}
                                            ${p.estado == 'En camino' ? 'bg-info text-dark' : ''}
                                            ${p.estado == 'Enviado' ? 'bg-primary' : ''}
                                            ${p.estado == 'Finalizado' ? 'bg-success' : ''}
                                            ${p.estado == 'Cancelado' ? 'bg-danger' : ''} px-3 py-2">
                                            ${p.estado}
                                        </span>
                                    </td>
                                    <td class="text-center">
                                        <form action="GestionPedidosServlet" method="POST" class="d-inline">
                                            <input type="hidden" name="accion" value="actualizar">
                                            <input type="hidden" name="id" value="${p.id}">
                                            <input type="hidden" name="estadoActual" value="${p.estado}">
                                            
                                            <c:choose>
                                                <c:when test="${p.estado == 'Espera'}">
                                                    <button type="submit" name="nuevoEstado" value="En camino" class="btn btn-sm btn-info"><i class="bi bi-truck"></i> En camino</button>
                                                </c:when>
                                                <c:when test="${p.estado == 'En camino'}">
                                                    <button type="submit" name="nuevoEstado" value="Enviado" class="btn btn-sm btn-primary"><i class="bi bi-box-seam"></i> Enviado</button>
                                                </c:when>
                                                <c:when test="${p.estado == 'Enviado'}">
                                                    <button type="submit" name="nuevoEstado" value="Finalizado" class="btn btn-sm btn-success"><i class="bi bi-check-circle"></i> Finalizar</button>
                                                </c:when>
                                                <c:when test="${p.estado == 'Finalizado'}">
                                                    <a href="comprobante_pedido.jsp?id=${p.id}&cliente=${p.nombreCliente}&total=${p.total}&fecha=${p.fecha}" target="_blank" class="btn btn-sm btn-outline-secondary">
                                                        <i class="bi bi-printer"></i> Imprimir
                                                    </a>
                                                </c:when>
                                            </c:choose>

                                            <c:if test="${p.estado != 'Finalizado' && p.estado != 'Cancelado'}">
                                                <button type="submit" name="nuevoEstado" value="Cancelado" class="btn btn-sm btn-outline-danger ms-1" onclick="return confirm('¿Seguro que deseas cancelar este pedido?');">
                                                    <i class="bi bi-x-circle"></i>
                                                </button>
                                            </c:if>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty pedidos}">
                                <tr>
                                    <td colspan="7" class="text-center py-4 text-muted">No se encontraron pedidos con esos filtros.</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
