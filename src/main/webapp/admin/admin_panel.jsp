<%-- 
    Document   : admin_panel
    Created on : 11 abr. 2026, 23:16:07
    Author     : LISET
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // 1. BLOQUEO DE SEGURIDAD
    HttpSession sesion = request.getSession(false);
    String rol = (sesion != null) ? (String) sesion.getAttribute("rol") : null;

    if (rol == null || (!rol.equals("admin") && !rol.equals("empleado"))) {
        response.sendRedirect("login.jsp");
        return;
    }

    // 2. VERIFICACIÓN DE DATOS DESDE ATRIBUTOS DIRECTOS
    Integer dni = (Integer) sesion.getAttribute("dni");
    Integer telefono = (Integer) sesion.getAttribute("telefono");

    // Si son null o son 0, significa que no se han rellenado
    boolean datosIncompletos = (dni == null || dni == 0 || telefono == null || telefono == 0);
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Panel de Gestión - Ikaza</title>
    <link href="${pageContext.request.contextPath}/assets/css/estilos.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
</head>
<body class="bg-light m-0 p-0">

    <nav class="navbar navbar-expand-lg navbar-dark bg-dark shadow-sm">
        <div class="container">
            <span class="navbar-brand fw-bold"><i class="bi bi-shop me-2"></i>Ikaza | <%= rol.toUpperCase() %></span>
            <div class="ms-auto d-flex align-items-center">
                <span class="text-light me-3"><i class="bi bi-person-circle me-1"></i> Hola, <%= sesion.getAttribute("nombre") %></span>
                <a href="${pageContext.request.contextPath}/LogoutServlet" class="btn btn-outline-danger btn-sm"><i class="bi bi-box-arrow-right me-1"></i> Cerrar Sesión</a>
            </div>
        </div>
    </nav>

    <div class="container mt-5">
        <div class="row mb-4">
            <div class="col">
                <h1 class="fw-bold text-dark">Panel Administrativo</h1>
                <p class="lead text-muted">Gestión interna y monitoreo de la tienda de muebles.</p>
                <hr>
            </div>
        </div>

        <div class="row g-4">
            <div class="col-md-6 col-lg-4">
                <div class="card h-100 shadow-sm border-0">
                    <div class="card-body text-center p-4">
                        <div class="display-4 text-primary mb-3"><i class="bi bi-box-seam"></i></div>
                        <h5 class="card-title fw-bold">Gestión de Muebles</h5>
                        <p class="card-text text-muted">Añadir, editar o eliminar productos del catálogo de inventario.</p>
                        <a href="${pageContext.request.contextPath}/GestionProductosServlet" class="btn btn-primary w-100 mt-2">Ir a Productos</a>
                    </div>
                </div>
            </div>

            <% if (rol.equals("admin")) { %>
            <div class="col-md-6 col-lg-4">
                <div class="card h-100 border-0 shadow-sm">
                    <div class="card-body text-center p-4">
                        <div class="display-4 text-warning mb-3"><i class="bi bi-people"></i></div>
                        <h5 class="card-title fw-bold">Gestión de Usuarios</h5>
                        <p class="card-text text-muted">Controlar roles, permisos de clientes y accesos de empleados.</p>
                        <a href="${pageContext.request.contextPath}/UsuariosServlet" class="btn btn-outline-warning text-dark w-100 mt-2">Gestionar Roles</a>
                    </div>
                </div>
            </div>
            <% } %>

            <div class="col-md-6 col-lg-4">
                <div class="card h-100 shadow-sm border-0 bg-white">
                    <div class="card-body text-center p-4">
                        <div class="display-4 text-success mb-3"><i class="bi bi-cart-check"></i></div>
                        <h5 class="card-title fw-bold">Ventas y Pedidos</h5>
                        <p class="card-text text-muted">Gestionar despachos.</p>
                        <a href="${pageContext.request.contextPath}/GestionPedidosServlet" class="btn btn-success w-100 mt-2">Gestionar Pedidos</a>
                    </div>
                </div>
            </div>
        </div>

        <div class="mt-5 text-center">
            <a href="${pageContext.request.contextPath}/IndexServlet" class="text-decoration-none text-secondary">
                <i class="bi bi-arrow-left-circle me-1"></i> Volver a la web pública
            </a>
        </div>
    </div>


    <% if (datosIncompletos) { %>
        <div class="position-fixed top-0 start-0 w-100 h-100 bg-dark bg-opacity-75 d-flex align-items-center justify-content-center" style="z-index: 2000;">
            <div class="card shadow-lg border-0 rounded-4 mx-3" style="max-width: 420px; width: 100%;">
                <div class="card-body p-4 text-center">
                    <div class="text-danger mb-3 display-4"><i class="bi bi-shield-lock-fill"></i></div>
                    <h4 class="fw-bold text-dark">Acceso Restringido</h4>
                    <p class="text-muted small mb-4">Por motivos de seguridad, debes registrar tu DNI y número telefónico antes de continuar operando el panel.</p>
                    
                    <form action="PerfilServlet" method="POST">
                        <div class="mb-3 text-start">
                            <label class="form-label fw-bold text-secondary small">Documento Nacional de Identidad (DNI)</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light"><i class="bi bi-person-vcard"></i></span>
                                <input type="number" class="form-control" name="txtDni" placeholder="Ej. 74839201" required>
                            </div>
                        </div>
                        
                        <div class="mb-4 text-start">
                            <label class="form-label fw-bold text-secondary small">Teléfono Celular</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light"><i class="bi bi-phone"></i></span>
                                <input type="number" class="form-control" name="txtTelefono" placeholder="Ej. 987654321" required>
                            </div>
                        </div>
                        
                        <button type="submit" class="btn btn-primary w-100 fw-bold py-2 shadow-sm">
                            <i class="bi bi-check-circle me-1"></i> Guardar y Activar Acceso
                        </button>
                    </form>
                </div>
            </div>
        </div>
    <% } %>

</body>
</html>
