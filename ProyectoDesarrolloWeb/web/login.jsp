<%-- 
    Document   : login
    Created on : 11 abr. 2026, 23:03:25
    Author     : LISET
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%-- IMPORTANTE: Añade esta línea para que funcione el <c:if> --%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Ikaza - Iniciar Sesión</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/estilos.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-4">
                <div class="card shadow">
                    <div class="card-body">
                        <h3 class="text-center mb-4">Acceso de Usuario</h3>
                        
                        <%-- Mensaje de éxito (ej. cuando viene de registrarse correctamente) --%>
                        <c:if test="${not empty mensaje}">
                            <div class="alert alert-success text-center">${mensaje}</div>
                        </c:if>

                        <form action="LoginServlet" method="POST">
                            <div class="mb-3">
                                <label class="form-label">Correo Electrónico</label>
                                <input type="email" name="txtCorreo" class="form-control" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Contraseña</label>
                                <input type="password" name="txtPassword" class="form-control" required>
                            </div>
                            <button type="submit" class="btn btn-primary w-100">Entrar</button>
                        </form>
                        
                        <%-- Esto muestra el error si el Servlet lo envía --%>
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger mt-3 text-center">${error}</div>
                        </c:if>

                        <hr class="my-4">

                        <%-- NUEVOS ENLACES: Registro y Volver al Inicio --%>
                        <div class="text-center">
                            <p class="mb-2">
                                ¿No tienes una cuenta? <a href="registro.jsp" class="text-decoration-none fw-bold">Regístrate aquí</a>
                            </p>
                            <a href="IndexServlet" class="text-secondary text-decoration-none">
                                <small>← Volver a la página principal</small>
                            </a>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
