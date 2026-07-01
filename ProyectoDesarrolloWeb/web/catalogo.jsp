<%-- 
    Document   : catalogo
    Created on : 6 may. 2026, 23:46:11
    Author     : LISET
--%>

<%@page contentType="text/html" pageEncoding="UTF-8" isELIgnored="true"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <title>Catálogo Completo - Ikaza</title>
    <link href="${pageContext.request.contextPath}/assets/css/estilos.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        .hover-shadow:hover {
            transform: translateY(-4px);
            box-shadow: 0 .5rem 1.5rem rgba(0,0,0,.1) !important;
        }
        .transition-card {
            transition: all 0.25s ease-in-out;
        }
    </style>
</head>
<body class="bg-light">

    <nav class="navbar navbar-dark bg-dark">
        <div class="container">
            <a class="navbar-brand" href="IndexServlet"><i class="bi bi-arrow-left"></i> Volver a Inicio</a>
        </div>
    </nav>

    <div class="container my-5">
        <h2 class="text-center mb-4 fw-bold">Catálogo Ikaza</h2>
        
        <div class="row g-2 mb-5 bg-white p-3 shadow-sm rounded align-items-end">
            <div class="col-md-3">
                <label class="form-label small text-muted fw-bold">Buscar Mueble</label>
                <input type="text" id="inputBuscador" class="form-control" placeholder="Ej. Mesa de centro...">
            </div>
            
            <div class="col-md-2">
                <label class="form-label small text-muted fw-bold">Categoría</label>
                <select id="selectCategoria" class="form-select">
                    <option value="">Todas las categorías</option>
                    <option value="1">Sofás y Sillones</option>
                    <option value="2">Mesas y Comedores</option>
                    <option value="3">Dormitorio</option>
                    <option value="4">Sillas y Bancos</option>
                    <option value="5">Oficina</option>
                </select>
            </div>

            <div class="col-md-2">
                <label class="form-label small text-muted fw-bold">Precio Mín.</label>
                <input type="number" id="inputMin" class="form-control" placeholder="S/ Mín">
            </div>

            <div class="col-md-2">
                <label class="form-label small text-muted fw-bold">Precio Máx.</label>
                <input type="number" id="inputMax" class="form-control" placeholder="S/ Máx">
            </div>

            <div class="col-md-1 text-center mb-2">
                <div class="form-check form-switch d-inline-block text-start">
                    <input class="form-check-input" type="checkbox" id="checkStock">
                    <label class="form-check-label small fw-bold" for="checkStock">Stock</label>
                </div>
            </div>

            <div class="col-md-2 d-flex gap-1">
                <button type="button" class="btn btn-primary w-100 fw-bold" onclick="buscarEnAPI()">
                    <i class="bi bi-search"></i> Filtrar
                </button>
                <button type="button" class="btn btn-outline-secondary" onclick="limpiarFiltros()" title="Limpiar Filtros">
                    <i class="bi bi-arrow-counterclockwise"></i>
                </button>
            </div>
        </div>

        <div class="row row-cols-1 row-cols-sm-2 row-cols-md-3 row-cols-lg-4 g-4" id="contenedorProductos">
            </div>
    </div>

    <script>
        function buscarEnAPI() {
            // Capturar el valor de todos los inputs del panel de filtros
            const termino = document.getElementById('inputBuscador').value;
            const categoria = document.getElementById('selectCategoria').value;
            const min = document.getElementById('inputMin').value;
            const max = document.getElementById('inputMax').value;
            const soloStock = document.getElementById('checkStock').checked ? 'true' : '';

            // URL Limpia usando la sintaxis nativa de JS gracias a isELIgnored="true"
            let url = `api/productos?q=${encodeURIComponent(termino)}&cat=${categoria}&min=${min}&max=${max}&stock=${soloStock}`;

            fetch(url)
                .then(response => response.json())
                .then(data => {
                    const contenedor = document.getElementById('contenedorProductos');
                    contenedor.innerHTML = '';

                    // Si la API devuelve un arreglo vacío
                    if (data.length === 0) {
                        contenedor.innerHTML = `
                            <div class="col-12 text-center my-5 py-5 text-muted">
                                <i class="bi bi-emoji-frown" style="font-size: 3rem;"></i>
                                <h5 class="mt-3">No encontramos muebles con esos filtros</h5>
                                <p class="small">Prueba cambiando los términos o limpiando los filtros establecidos.</p>
                            </div>
                        `;
                        return;
                    }

                    // Renderizar las tarjetas de los productos encontrados
                    data.forEach(p => {
                        let badgeStock = p.stock > 0 
                            ? `<span class="badge bg-success-subtle text-success border border-success-subtle px-2 py-1">Stock: ${p.stock}</span>`
                            : `<span class="badge bg-danger-subtle text-danger border border-danger-subtle px-2 py-1">Agotado</span>`;
                        
                        let tarjeta = `
                            <div class="col">
                                <a href="ProductoServlet?id=${p.id}" class="text-decoration-none text-dark">
                                    <div class="card h-100 shadow-sm hover-shadow transition-card border-0">
                                        <div class="position-relative bg-white text-center p-3 rounded-top" style="height: 200px; display: flex; align-items: center; justify-content: center;">
                                            <img src="${p.imagenUrl && p.imagenUrl.trim() !== '' ? p.imagenUrl : 'https://via.placeholder.com/260x180?text=Sin+Imagen'}" 
                                                 class="card-img-top" alt="${p.nombre}" style="max-height: 100%; max-width: 100%; object-fit: contain;">
                                        </div>
                                        <div class="card-body d-flex flex-column bg-white rounded-bottom">
                                            <div class="d-flex justify-content-between align-items-center mb-2">
                                                ${badgeStock}
                                                <small class="text-uppercase text-muted fw-bold" style="font-size: 0.72rem;">${p.categoria}</small>
                                            </div>
                                            <h6 class="card-title fw-bold text-truncate mb-1" title="${p.nombre}">${p.nombre}</h6>
                                            
                                            <div class="bg-light p-2 rounded my-2" style="font-size: 0.8rem;">
                                                <div class="text-muted text-truncate"><i class="bi bi-box-seam"></i> ${p.medidas}</div>
                                                <div class="text-muted text-truncate"><i class="bi bi-hammer"></i> ${p.material !== '' ? p.material : 'Estándar'}</div>
                                            </div>

                                            <h5 class="text-primary fw-bold mt-auto mb-3">S/ ${p.precio.toFixed(2)}</h5>
                                            <button class="btn btn-outline-dark btn-sm w-100 py-2">Ver Detalles</button>
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
