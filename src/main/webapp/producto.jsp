<%-- 
    Document   : producto
    Created on : 7 may. 2026, 00:02:26
    Author     : LISET
--%>

<%@page import="com.ikaza.modelo.Mueble"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Recuperamos el mapa del producto enviado por el ProductoServlet
    Map<String, String> p = (Map<String, String>) request.getAttribute("p");
    
    if (p == null) {
        response.sendRedirect("IndexServlet");
        return;
    }
    
    // --- LÓGICA: VERIFICAR SI YA ESTÁ EN EL CARRITO ---
    boolean yaEnCarrito = false;
    List<com.ikaza.modelo.DetallePedido> listaCarrito = (List<com.ikaza.modelo.DetallePedido>) session.getAttribute("carrito");
    if (listaCarrito != null) {
        int idActual = Integer.parseInt(p.get("id"));
        for (com.ikaza.modelo.DetallePedido item : listaCarrito) {
            if (item.getMuebleId() == idActual) {
                yaEnCarrito = true;
                break;
            }
        }
    }
    
    // --- LÓGICA: VERIFICAR SI YA ESTÁ EN FAVORITOS ---
    boolean esFavorito = false;
    List<Mueble> listaFavoritos = (List<Mueble>) session.getAttribute("favoritos");
    if (listaFavoritos != null) {
        int idActual = Integer.parseInt(p.get("id"));
        for (Mueble m : listaFavoritos) {
            if (m.getId() == idActual) {
                esFavorito = true;
                break;
            }
        }
    }
    
    int stock = Integer.parseInt(p.get("stock"));
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= p.get("nombre") %> - Ikaza</title>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <link href="${pageContext.request.contextPath}/assets/css/estilos.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
</head>
<body class="bg-light">

    <nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-4">
        <div class="container">
            <a class="navbar-brand fw-bold" href="IndexServlet">IKAZA</a>
        </div>
    </nav>

    <div class="container my-5">
        <div class="row g-5">
            
            <div class="col-lg-6">
                <div class="shadow-sm rounded-4 overflow-hidden bg-white">
                    <img src="<%= p.get("imagenUrl") %>" 
                         alt="<%= p.get("nombre") %>" 
                         class="img-fluid w-100" 
                         style="max-height: 500px; object-fit: cover;">
                </div>
            </div>

            <div class="col-lg-6">
                <nav aria-label="breadcrumb" style="font-size: 0.9rem;">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="IndexServlet" class="text-decoration-none">Inicio</a></li>
                        <li class="breadcrumb-item"><a href="catalogo.jsp" class="text-decoration-none">Muebles</a></li>
                        <li class="breadcrumb-item active" aria-current="page"><%= p.get("nombre") %></li>
                    </ol>
                </nav>

                <h1 class="display-5 fw-bold text-dark mb-2"><%= p.get("nombre") %></h1>

                <div class="mb-4">
                    <% 
                        if (stock > 0) { 
                    %>
                        <span class="badge bg-success-subtle text-success border border-success-subtle px-3 py-2 rounded-pill">
                            <i class="bi bi-check-circle-fill me-1"></i> Disponible (<%= stock %> unidades)
                        </span>
                    <% } else { %>
                        <span class="badge bg-danger-subtle text-danger border border-danger-subtle px-3 py-2 rounded-pill">
                            <i class="bi bi-x-circle-fill me-1"></i> Agotado temporalmente
                        </span>
                    <% } %>
                </div>

                <h2 class="text-primary display-6 fw-bold mb-4">S/ <%= p.get("precio") %></h2>

                <div class="card border-0 shadow-sm mb-3">
                    <div class="card-body p-4">
                        <h6 class="fw-bold text-dark mb-2">Descripción del producto</h6>
                        <p class="text-muted mb-0"><%= p.get("descripcion") %></p>
                    </div>
                </div>

                <div class="card border-0 shadow-sm mb-4">
                    <div class="card-body p-4">
                        <h5 class="fw-bold mb-3"><i class="bi bi-list-stars text-primary"></i> Especificaciones Técnicas</h5>
                        <table class="table table-sm table-striped-columns table-borderless mb-0" style="font-size: 0.95rem;">
                            <tbody>
                                <tr>
                                    <td class="text-muted" style="width: 35%;">Categoría</td>
                                    <td class="fw-bold text-end text-uppercase text-secondary" style="font-size: 0.85rem;"><%= p.get("categoria") %></td>
                                </tr>
                                <tr>
                                    <td class="text-muted">Material Base</td>
                                    <td class="fw-semibold text-end"><%= p.get("material") %></td>
                                </tr>
                                <tr>
                                    <td class="text-muted">Dimensiones</td>
                                    <td class="fw-semibold text-end">
                                        <%= p.get("alto") %> cm (Alto) x 
                                        <%= p.get("ancho") %> cm (Ancho) x 
                                        <%= p.get("profundidad") %> cm (Prof)
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div class="d-grid gap-2 mt-4">
                    <% if (yaEnCarrito) { %>
                        <button type="button" class="btn btn-secondary btn-lg py-3 fw-bold w-100" disabled>
                            <i class="bi bi-check-circle-fill me-2"></i> Ya en el carrito
                        </button>
                    <% } else { %>
                        <form action="CarritoServlet" method="POST">
                            <input type="hidden" name="accion" value="agregar">
                            <input type="hidden" name="id" value="<%= p.get("id") %>">
                            <input type="hidden" name="origen" value="producto">

                            <div class="mb-3">
                                <label class="form-label fw-bold">Cantidad:</label>
                                <input type="number" name="cantidad" value="1" min="1" max="<%= stock %>" class="form-control" style="width: 100px;">
                            </div>

                            <button type="submit" class="btn btn-primary btn-lg py-3 fw-bold shadow-sm w-100" 
                                    <%= stock == 0 ? "disabled" : "" %>>
                                <i class="bi bi-cart-fill me-2"></i> Añadir al carrito
                            </button>
                        </form>
                    <% } %>
                    
                    <form action="FavoritosServlet" method="POST">
                        <input type="hidden" name="accion" value="agregar">
                        <input type="hidden" name="id" value="<%= p.get("id") %>">
                        <button type="submit" class="btn <%= esFavorito ? "btn-danger" : "btn-outline-dark" %> btn-lg py-2 fw-semibold w-100" <%= esFavorito ? "disabled" : "" %>>
                            <i class="bi <%= esFavorito ? "bi-heart-fill" : "bi-heart" %> me-2"></i> 
                            <%= esFavorito ? "Ya es tu favorito" : "Guardar en favoritos" %>
                        </button>
                    </form>
                </div>

            </div>
        </div>
    </div>
    
    <script>
        const urlParams = new URLSearchParams(window.location.search);
        const success = urlParams.get('success');
        const error = urlParams.get('error');
        const info = urlParams.get('info'); // Capturamos el nuevo parámetro

        // 1. Manejo de error de acceso
        if (error === 'login_required') {
            Swal.fire({
                title: '¡Acceso Restringido!',
                text: 'Debes iniciar sesión para añadir productos a tu carrito.',
                icon: 'warning',
                confirmButtonColor: '#d33',
                confirmButtonText: 'Ir a Iniciar Sesión'
            }).then((result) => {
                if (result.isConfirmed) {
                    window.location.href = 'login.jsp';
                }
            });
        } 
        else if (error === 'out_of_stock') {
            Swal.fire({
                title: '¡Error de Stock!',
                text: 'No hay suficientes unidades disponibles para la cantidad solicitada.',
                icon: 'error',
                confirmButtonColor: '#d33'
            });
        }
        
        // 2. Manejo de éxitos
        else if (success === 'added') {
            Swal.fire({
                title: '¡Añadido!',
                text: 'El producto se agregó a tu carrito con éxito.',
                icon: 'success',
                confirmButtonColor: '#0d6efd'
            });
        }
        else if (success === 'favorito_added') {
            Swal.fire({
                title: '¡Guardado!',
                text: 'Producto añadido a favoritos.',
                icon: 'success',
                confirmButtonColor: '#212529'
            });
        }
        else if (info === 'ya_en_favoritos') {
            Swal.fire({
                title: 'Información',
                text: 'Ya tienes este producto en favoritos.',
                icon: 'info'
            });
        }
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
