<%-- 
    Document   : resgistro.jsp
    Created on : 12 abr. 2026, 23:00:21
    Author     : LISET
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Ikaza - Crear Cuenta</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/estilos.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
</head>
<body class="bg-light">
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-5">
                <div class="card shadow">
                    <div class="card-body">
                        <h3 class="text-center mb-4">Únete a Ikaza</h3>
                        <form action="RegistroServlet" method="POST">
                            <div class="mb-3">
                                <label class="form-label">Nombre Completo</label>
                                <input type="text" name="txtNombre" class="form-control" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Correo Electrónico</label>
                                <input type="email" name="txtCorreo" class="form-control" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Contraseña</label>
                                <input type="password" name="txtPassword" class="form-control" required>
                            </div>
                            
                            <%-- OPCIÓN 1: Agrupamos los botones en un contenedor vertical 'd-grid' --%>
                            <div class="d-grid gap-2">
                                <button type="submit" class="btn btn-success">Crear mi cuenta</button>
                                <a href="IndexServlet" class="btn btn-outline-secondary">
                                    <i class="bi bi-arrow-left-short"></i> Volver a la tienda
                                </a>
                            </div>
                        </form>
                        
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger mt-3">${error}</div>
                        </c:if>
                    </div>
                </div>
                
                <div class="d-flex justify-content-between mt-3 px-1 small">
                    <div>
                        ¿Ya tienes cuenta? <a href="login.jsp" class="text-decoration-none">Inicia sesión aquí</a>
                    </div>
                    <div>
                        <a href="IndexServlet" class="text-decoration-none text-muted">
                            <i class="bi bi-house-door"></i> Ir al inicio
                        </a>
                    </div>
                </div>

            </div>
        </div>
    </div>
</body>
</html>
