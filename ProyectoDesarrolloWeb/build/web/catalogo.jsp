<%-- 
    Document   : catalogo
    Created on : 6 may. 2026, 23:46:11
    Author     : LISET
--%>

<%@page contentType="text/html" pageEncoding="UTF-8" isELIgnored="true"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Catálogo Completo - Ikaza</title>
    
    <!-- Bootstrap 5 & Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    
    <!-- Hoja de estilos personalizada -->
    <link href="<%= request.getContextPath() %>/assets/css/estilos.css" rel="stylesheet">
</head>
<body class="d-flex flex-column min-vh-100 bg-light">

    <!-- NAVBAR SIMPLIFICADO -->
    <nav class="navbar navbar-dark sticky-top shadow-sm" style="background-color: rgba(18, 18, 18, 0.95); backdrop-filter: blur(10px);">
        <div class="container d-flex justify-content-between align-items-center py-1">
            <a class="navbar-brand fw-bold fs-4" href="IndexServlet" style="letter-spacing: 2px;">IKAZA</a>
            <a href="IndexServlet" class="btn btn-outline-light rounded-pill px-4 btn-sm fw-medium">
                <i class="bi bi-arrow-left me-2"></i> Volver a Inicio
            </a>
        </div>
    </nav>

    <!-- CONTENIDO PRINCIPAL -->
    <main class="container py-5 flex-grow-1">
        <div class="text-center mb-5">
            <h2 class="fw-bold text-uppercase mb-2 text-dark" style="letter-spacing: 1px;">Catálogo de Productos</h2>
            <div style="height: 3px; width: 60px; background-color: var(--ikaza-primary); margin: 0 auto; border-radius: 2px;"></div>
        </div>
        
        <!-- PANEL DE FILTROS -->
        <div class="row g-3 mb-5 bg-white p-4 shadow-sm align-items-end" style="border-radius: var(--radius-md);">
            <div class="col-md-3">
                <label class="form-label small text-muted fw-bold text-uppercase" style="letter-spacing: 0.5px;">Buscar Mueble</label>
                <div class="input-group">
                    <span class="input-group-text bg-white border-end-0"><i class="bi bi-search text-muted"></i></span>
                    <input type="text" id="inputBuscador" class="form-control border-start-0 ps-0 shadow-none" placeholder="Ej. Mesa de centro...">
                </div>
            </div>
            
            <div class="col-md-2">
                <label class="form-label small text-muted fw-bold text-uppercase" style="letter-spacing: 0.5px;">Categoría</label>
                <select id="selectCategoria" class="form-select shadow-none">
                    <option value="">Todas</option>
                    <option value="1">Sofás y Sillones</option>
                    <option value="2">Mesas y Comedores</option>
                    <option value="3">Dormitorio</option>
                    <option value="4">Sillas y Bancos</option>
                    <option value="5">Oficina</option>
                </select>
            </div>

            <div class="col-md-2">
                <label class="form-label small text-muted fw-bold text-uppercase" style="letter-spacing: 0.5px;">Precio Mín.</label>
                <div class="input-group">
                    <span class="input-group-text bg-light border-0">S/</span>
                    <input type="number" id="inputMin" class="form-control shadow-none" placeholder="0">
                </div>
            </div>

            <div class="col-md-2">
                <label class="form-label small text-muted fw-bold text-uppercase" style="letter-spacing: 0.5px;">Precio Máx.</label>
                <div class="input-group">
                    <span class="input-group-text bg-light border-0">S/</span>
                    <input type="number" id="inputMax" class="form-control shadow-none" placeholder="10000">
                </div>
            </div>

            <div class="col-md-1 text-center pb-2">
                <div class="form-check form-switch d-inline-block">
                    <input class="form-check-input shadow-none" type="checkbox" id="checkStock">
                    <label class="form-check-label small fw-bold mt-1 d-block" for="checkStock">Stock</label>
                </div>
            </div>

            <div class="col-md-2 d-flex gap-2">
                <button type="button" class="btn btn-primary w-100 fw-bold rounded-pill shadow-sm" onclick="buscarEnAPI()">
                    Filtrar
                </button>
                <button type="button" class="btn btn-outline-secondary rounded-pill px-3" onclick="limpiarFiltros()" title="Limpiar Filtros">
                    <i class="bi bi-arrow-counterclockwise"></i>
                </button>
            </div>
        </div>

        <!-- CONTENEDOR DE PRODUCTOS DINÁMICOS -->
        <div class="row g-4" id="contenedorProductos">
            <!-- Los productos se cargarán aquí por JS -->
        </div>
    </main>

    <!-- FOOTER PREMIUM -->
    <footer class="text-white py-5 mt-auto" style="background-color: var(--ikaza-dark);">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-6 text-center text-md-start mb-4 mb-md-0">
                    <h4 class="fw-bold mb-2 text-white" style="letter-spacing: 2px;">IKAZA</h4>
                    <p class="mb-1 text-white-50 small">&copy; 2026 Ikaza Muebles - Proyecto Web Tomcat 10.</p>
                    <p class="mb-0 text-white-50 small">Diseñado con orgullo en Ica, Perú.</p>
                </div>
                <div class="col-md-6 text-center text-md-end">
                    <p class="mb-2 text-white-50 small text-uppercase fw-bold" style="letter-spacing: 1px;">Síguenos</p>
                    <div class="d-flex justify-content-center justify-content-md-end gap-3">
                        <a href="#!" class="text-white text-decoration-none fs-5"><i class="bi bi-instagram"></i></a>
                        <a href="#!" class="text-white text-decoration-none fs-5"><i class="bi bi-facebook"></i></a>
                        <a href="#!" class="text-white text-decoration-none fs-5"><i class="bi bi-pinterest"></i></a>
                        <a href="#!" class="text-white text-decoration-none fs-5"><i class="bi bi-tiktok"></i></a>
                    </div>
                </div>
            </div>
        </div>
    </footer>

    <!-- SCRIPTS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function buscarEnAPI() {
            const termino = document.getElementById('inputBuscador').value;
            const categoria = document.getElementById('selectCategoria').value;
            const min = document.getElementById('inputMin').value;
            const max = document.getElementById('inputMax').value;
            const soloStock = document.getElementById('checkStock').checked ? 'true' : '';

            let url = `api/productos?q=${encodeURIComponent(termino)}&cat=${categoria}&min=${min}&max=${max}&stock=${soloStock}`;

            fetch(url)
                .then(response => response.json())
                .then(data => {
                    const contenedor = document.getElementById('contenedorProductos');
                    contenedor.innerHTML = '';

                    if (data.length === 0) {
                        contenedor.innerHTML = `
                            <div class="col-12 text-center my-5 py-5 text-muted">
                                <i class="bi bi-search" style="font-size: 3rem; opacity: 0.5;"></i>
                                <h5 class="mt-4 fw-bold text-dark">No encontramos muebles con esos filtros</h5>
                                <p class="small">Prueba cambiando los términos o limpiando los filtros establecidos.</p>
                                <button class="btn btn-outline-primary rounded-pill mt-3 px-4" onclick="limpiarFiltros()">Limpiar Filtros</button>
                            </div>
                        `;
                        return;
                    }

                    data.forEach(p => {
                        let badgeStock = p.stock > 0 
                            ? `<span class="badge bg-success border border-success-subtle shadow-sm px-3 py-2 rounded-pill">Stock: ${p.stock}</span>`
                            : `<span class="badge bg-danger border border-danger-subtle shadow-sm px-3 py-2 rounded-pill">Agotado</span>`;
                        
                        // Generamos la tarjeta con el nuevo diseño
                        let tarjeta = `
                            <div class="col-12 col-md-6 col-lg-4 col-xl-3">
                                <a href="ProductoServlet?id=${p.id}" class="text-decoration-none">
                                    <div class="card card-mueble h-100 border-0 bg-white">
                                        <div class="position-relative overflow-hidden" style="border-radius: var(--radius-md) var(--radius-md) 0 0;">
                                            <img src="${p.imagenUrl && p.imagenUrl.trim() !== '' ? p.imagenUrl : 'https://via.placeholder.com/300x250?text=Sin+Imagen'}" 
                                                 class="card-img-top object-fit-cover w-100" alt="${p.nombre}" style="height: 250px;">
                                            <div class="position-absolute top-0 start-0 m-3">
                                                ${badgeStock}
                                            </div>
                                        </div>
                                        
                                        <div class="card-body p-4 text-center d-flex flex-column">
                                            <small class="text-uppercase fw-bold mb-2" style="color: var(--ikaza-muted); font-size: 0.75rem; letter-spacing: 1px;">${p.categoria}</small>
                                            <h5 class="card-title fw-bold text-dark mb-3 text-truncate" title="${p.nombre}">${p.nombre}</h5>
                                            
                                            <div class="d-flex justify-content-center gap-3 mb-3 small text-muted">
                                                <span title="Medidas"><i class="bi bi-arrows-move me-1"></i>${p.medidas}</span>
                                                <span title="Material"><i class="bi bi-layers me-1"></i>${p.material !== '' ? p.material : 'Estándar'}</span>
                                            </div>

                                            <h4 class="fw-bold mb-4 mt-auto" style="color: var(--ikaza-primary);">S/ ${parseFloat(p.precio).toFixed(2)}</h4>
                                            
                                            <button class="btn btn-outline-dark w-100 rounded-pill py-2 fw-medium transition-card">
                                                Ver Detalles
                                            </button>
                                        </div>
                                    </div>
                                </a>
                            </div>
                        `;
                        contenedor.innerHTML += tarjeta;
                    });
                })
                .catch(err => {
                    console.error("Error al procesar el catálogo: ", err);
                });
        }

        function limpiarFiltros() {
            document.getElementById('inputBuscador').value = '';
            document.getElementById('selectCategoria').value = '';
            document.getElementById('inputMin').value = '';
            document.getElementById('inputMax').value = '';
            document.getElementById('checkStock').checked = false;
            buscarEnAPI();
        }

        window.onload = buscarEnAPI;
    </script>
</body>
</html>
