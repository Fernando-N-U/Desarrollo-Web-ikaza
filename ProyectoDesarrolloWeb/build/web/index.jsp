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
    <title>Ikaza - Muebles Minimalistas y Modernos</title>
    
    <!-- Bootstrap 5 & Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    
    <!-- Hoja de estilos personalizada -->
    <link href="${pageContext.request.contextPath}/assets/css/estilos.css" rel="stylesheet">
</head>
<body class="d-flex flex-column min-vh-100">

    <!-- NAVBAR PREMIUM -->
    <nav class="navbar navbar-expand-lg navbar-dark sticky-top shadow-sm">
        <div class="container">
            <%-- El logo se mantiene libre de cuadros --%>
            <a class="navbar-brand fw-bold fs-3" href="IndexServlet">IKAZA</a>
            
            <button class="navbar-toggler border-0" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            
            <div class="collapse navbar-collapse" id="navbarNav">
                <%-- Separación elegante entre los cuadros con gap-3 --%>
                <ul class="navbar-nav ms-auto align-items-center gap-3">
                    <c:choose>
                        <c:when test="${not empty sessionScope.nombre}">
                            <c:if test="${sessionScope.rol == 'admin' || sessionScope.rol == 'empleado'}">
                                <li class="nav-item">
                                    <a class="btn btn-outline-warning fw-bold rounded-pill px-3" href="admin/admin_panel.jsp">
                                        <i class="bi bi-speedometer2 me-1"></i> CONSOLA
                                    </a>
                                </li>
                            </c:if>

                            <li class="nav-item">
                                <span class="nav-link text-light opacity-75 fw-medium">¡Hola, ${sessionScope.nombre}!</span>
                            </li>
                            
                            <li class="nav-item">
                                <a class="btn btn-outline-light rounded-pill px-3" href="PerfilServlet">
                                    <i class="bi bi-person-badge me-1"></i> Mi Perfil
                                </a>
                            </li>

                            <li class="nav-item">
                                <a class="btn btn-outline-danger rounded-pill px-3" href="LogoutServlet">Cerrar Sesión</a>
                            </li>
                        </c:when>
                        
                        <c:otherwise>
                            <li class="nav-item">
                                <a class="btn btn-outline-light rounded-pill px-4" href="login.jsp">Iniciar Sesión</a>
                            </li>
                            <li class="nav-item">
                                <a class="btn btn-primary rounded-pill px-4 shadow-sm" href="registro.jsp">Registrarse</a>
                            </li>
                        </c:otherwise>
                    </c:choose>
                    
                    <%-- El carrito mantiene su cuadro y se alinea con el resto --%>
                    <li class="nav-item ms-lg-2">
                        <a href="Pedidos/carrito.jsp" class="btn btn-outline-light position-relative rounded-pill px-3">
                            <i class="bi bi-cart3 me-1"></i> Carrito
                            <c:if test="${not empty sessionScope.carrito}">
                                <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger border border-2 border-dark" style="font-size: 0.70rem;">
                                    ${sessionScope.carrito.size()}
                                </span>
                            </c:if>
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- HERO SECTION -->
    <header class="hero-section text-center d-flex align-items-center justify-content-center">
        <div class="container px-4">
            <h1 class="display-3 fw-bolder mb-3 text-dark">Dale vida a tu hogar</h1>
            <p class="lead mb-4 text-muted mx-auto" style="max-width: 600px;">
                Descubre nuestra colección de muebles modernos y minimalistas diseñados en Ica para transformar cada espacio.
            </p>
            <a href="catalogo.jsp" class="btn btn-primary btn-lg rounded-pill px-5 py-3 shadow">
                Explorar Colección <i class="bi bi-arrow-right ms-2"></i>
            </a>
        </div>
    </header>

    <!-- PRODUCTOS DESTACADOS -->
    <main class="container py-5 flex-grow-1" id="productos">
        <div class="text-center mb-5">
            <h2 class="fw-bold text-uppercase mb-2 text-dark" style="letter-spacing: 1px;">Colección Destacada</h2>
            <div style="height: 3px; width: 60px; background-color: var(--ikaza-primary); margin: 0 auto; border-radius: 2px;"></div>
        </div>
        
        <div class="row justify-content-center g-4">
            <c:forEach var="p" items="${productos}">
                <div class="col-12 col-md-6 col-lg-4">
                    <a href="ProductoServlet?id=${p.id}" class="text-decoration-none">
                        <div class="card card-mueble h-100 border-0 bg-white">
                            <div class="position-relative overflow-hidden" style="border-radius: var(--radius-md) var(--radius-md) 0 0;">
                                <!-- class object-fit-cover asegura que la imagen no se deforme -->
                                <img src="${p.imagenUrl}" class="card-img-top object-fit-cover w-100" alt="${p.nombre}" style="height: 320px;">
                            </div>
                            <div class="card-body p-4 text-center">
                                <h5 class="card-title fw-bold text-uppercase mb-3 text-dark">${p.nombre}</h5>
                                <span class="text-primary fw-medium" style="font-size: 0.85rem; letter-spacing: 1.5px;">
                                    VER DETALLES <i class="bi bi-chevron-right ms-1"></i>
                                </span>
                            </div>
                        </div>
                    </a>
                </div>
            </c:forEach>
        </div>
    </main>

    <!-- FOOTER -->
    <footer class="text-white py-5 mt-auto">
        <div class="container">
            <div class="row align-items-center">
                <!-- Información de la marca -->
                <div class="col-md-6 text-center text-md-start mb-4 mb-md-0">
                    <h4 class="fw-bold mb-2 text-white">IKAZA</h4>
                    <!-- Usamos text-white-50 para que el texto sea blanco pero un poco translúcido (elegante) -->
                    <p class="mb-1 text-white-50 small">&copy; 2026 Ikaza Muebles - Proyecto Web Tomcat 10.</p>
                    <p class="mb-0 text-white-50 small">Diseñado con orgullo en Ica, Perú.</p>
                </div>
                
                <!-- Redes Sociales Falsas -->
                <div class="col-md-6 text-center text-md-end">
                    <p class="mb-2 text-white-50 small text-uppercase fw-bold" style="letter-spacing: 1px;">Síguenos</p>
                    <div class="d-flex justify-content-center justify-content-md-end gap-3">
                        <a href="#!" class="text-white text-decoration-none fs-5">
                            <i class="bi bi-instagram"></i>
                        </a>
                        <a href="#!" class="text-white text-decoration-none fs-5">
                            <i class="bi bi-facebook"></i>
                        </a>
                        <a href="#!" class="text-white text-decoration-none fs-5">
                            <i class="bi bi-pinterest"></i>
                        </a>
                        <a href="#!" class="text-white text-decoration-none fs-5">
                            <i class="bi bi-tiktok"></i>
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </footer>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
