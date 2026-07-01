<%-- 
    Document   : index
    Created on : 11 abr. 2026, 21:40:25
    Author     : LISET
--%>

<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ikaza - Tienda de Muebles</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link href="${pageContext.request.contextPath}/assets/css/estilos.css" rel="stylesheet">
    <style>
        .hero-section {
            background-color: #f8f9fa;
            padding: 60px 0;
            border-bottom: 1px solid #ddd;
        }
        .card-mueble {
            transition: transform 0.3s;
        }
        .card-mueble:hover {
            transform: scale(1.05);
        }
    </style>
</head>
<body class="d-flex flex-column min-vh-100">

    <nav class="navbar navbar-expand-lg navbar-dark bg-dark sticky-top shadow-sm">
        <div class="container">
            <%-- El logo se mantiene libre de cuadros --%>
            <a class="navbar-brand fw-bold fs-4" href="IndexServlet">IKAZA</a>
            
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            
            <div class="collapse navbar-collapse" id="navbarNav">
                <%-- Usamos 'gap-3' para dar una separación elegante entre los cuadros --%>
                <ul class="navbar-nav ms-auto align-items-center gap-3">
                    <c:choose>
                        <c:when test="${not empty sessionScope.nombre}">
                            <c:if test="${sessionScope.rol == 'admin' || sessionScope.rol == 'empleado'}">
                                <li class="nav-item">
                                    <a class="btn btn-outline-warning fw-bold" href="admin/admin_panel.jsp">
                                        <i class="bi bi-speedometer2"></i> CONSOLA
                                    </a>
                                </li>
                            </c:if>

                            <li class="nav-item">
                                <span class="nav-link text-primary fw-bold">¡Hola, ${sessionScope.nombre}!</span>
                            </li>
                            
                            <li class="nav-item">
                                <a class="btn btn-outline-light" href="PerfilServlet">
                                    <i class="bi bi-person-badge"></i> Mi Perfil
                                </a>
                            </li>

                            <li class="nav-item">
                                <a class="btn btn-outline-danger" href="LogoutServlet">Cerrar Sesión</a>
                            </li>
                        </c:when>
                        
                        <c:otherwise>
                            <li class="nav-item">
                                <a class="btn btn-outline-light" href="login.jsp">Iniciar Sesión</a>
                            </li>
                            <li class="nav-item">
                                <a class="btn btn-outline-info" href="registro.jsp">Registrarse</a>
                            </li>
                        </c:otherwise>
                    </c:choose>
                    
                    <%-- El carrito mantiene su cuadro y se alinea con el resto --%>
                    <li class="nav-item">
                        <a href="Pedidos/carrito.jsp" class="btn btn-outline-light position-relative">
                            <i class="bi bi-cart3"></i> Carrito
                            <c:if test="${not empty sessionScope.carrito}">
                                <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger" style="font-size: 0.70rem;">
                                    ${sessionScope.carrito.size()}
                                </span>
                            </c:if>
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <header class="hero-section text-center">
        <div class="container">
            <h1 class="display-4 fw-bold">Dale vida a tu hogar</h1>
            <p class="lead">Muebles modernos y minimalistas diseñados en Ica.</p>
            <a href="catalogo.jsp" class="btn btn-primary btn-lg">Ver Catálogo</a>
        </div>
    </header>

    <main class="container my-5 flex-grow-1" id="productos">
        <h2 class="text-center mb-4">Nuestros Productos Destacados</h2>
        <div class="row justify-content-center">
            <c:forEach var="p" items="${productos}">
                <div class="col-md-4 mb-4">
                    <a href="ProductoServlet?id=${p.id}" class="text-decoration-none text-dark">
                        <div class="card card-mueble h-100 border-0 shadow-sm text-center">
                            <img src="${p.imagenUrl}" class="card-img-top" alt="${p.nombre}" style="height: 300px; object-fit: cover; border-radius: 10px;">
                            <div class="card-body mt-2">
                                <h4 class="card-title fw-bold text-uppercase">${p.nombre}</h4>
                                <span class="text-primary">Ver detalles <i class="bi bi-arrow-right"></i></span>
                            </div>
                        </div>
                    </a>
                </div>
            </c:forEach>
        </div>
    </main>

    <footer class="bg-dark text-white text-center py-4 mt-auto">
        <p class="mb-0">&copy; 2026 Ikaza Muebles - Proyecto Web Tomcat 10</p>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
