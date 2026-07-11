<%-- 
    Document   : gestion_productos.jsp
    Created on : 19 abr. 2026, 11:48:38
    Author     : LISET
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, com.ikaza.modelo.Mueble"%>
<%
    List<Mueble> productos = (List<Mueble>) request.getAttribute("productos");
    List<Map<String, String>> listaCategorias = (List<Map<String, String>>) request.getAttribute("listaCategorias");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Gestión de Productos</title>
    <link href="${pageContext.request.contextPath}/assets/css/estilos.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
</head>
<body class="bg-light">
<div class="container mt-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2>Gestión de Muebles</h2>
        <a href="admin/admin_panel.jsp" class="btn btn-secondary"><i class="bi bi-arrow-left"></i> Volver al Panel</a>
    </div>
    
    <form action="GestionProductosServlet" method="GET" class="row mb-4 p-3 bg-white shadow-sm rounded">
        <div class="col-md-3"><input type="text" name="nombre" class="form-control" placeholder="Nombre..."></div>
    
        <div class="col-md-2"><input type="number" name="minPrecio" class="form-control" placeholder="Min"></div>
        <div class="col-md-2"><input type="number" name="maxPrecio" class="form-control" placeholder="Max"></div>
        <div class="col-md-3">
            <select name="categoriaIdFiltro" class="form-select">
                <option value="">Todas las categorías</option>
                <% for(Map<String, String> c : listaCategorias) { %>
             
                <option value="<%= c.get("id") %>"><%= c.get("nombre") %></option>
                <% } %>
            </select>
        </div>
        <div class="col-md-2"><button type="submit" class="btn btn-primary w-100">Filtrar</button></div>
    </form>

    <div class="card mb-4">
        <div class="card-header bg-primary text-white" id="formHeader">Añadir Mueble</div>
        <div class="card-body">
     
        <form action="GestionProductosServlet" method="POST" id="formProducto">
                <input type="hidden" name="accion" id="accion" value="agregar">
                <input type="hidden" name="id" id="productoId">
                <div class="row g-2">
                    <div class="col-md-3"><input type="text" name="nombre" id="nombre" class="form-control" placeholder="Nombre" required></div>
      
                    <div class="col-md-2"><input type="number" step="0.01" name="precio" id="precio" class="form-control" placeholder="Precio" required></div>
                    <div class="col-md-2"><input type="number" name="stock" id="stock" class="form-control" placeholder="Stock" required></div>
                    <div class="col-md-3">
                        <select name="categoriaId" id="categoriaId" class="form-select" required>
  
                            <option value="">Seleccione Categoría</option>
                            <% for(Map<String, String> c : listaCategorias) { %>
                                <option value="<%= c.get("id") %>"><%= c.get("nombre") %></option>
                            <% } %>
                        </select>
                    </div>
                    <div class="col-md-2"><button type="submit" class="btn btn-success w-100" id="btnGuardar">Guardar</button></div>
                    <div class="col-md-12"><input type="text" name="material" id="material" class="form-control mt-2" placeholder="Material"></div>
                    <div class="col-md-4"><input type="number" name="alto" id="alto" class="form-control mt-2" placeholder="Alto (cm)"></div>
                    <div class="col-md-4"><input type="number" name="ancho" id="ancho" class="form-control mt-2" placeholder="Ancho (cm)"></div>
                 
                    <div class="col-md-4"><input type="number" name="profundidad" id="profundidad" class="form-control mt-2" placeholder="Prof (cm)"></div>
                    
                    <div class="col-md-9">
                        <input type="text" name="imagenUrl" id="imagenUrl" class="form-control mt-2" placeholder="URL de la Imagen del Mueble" oninput="actualizarPrevia()">
                    </div>
                    <div class="col-md-3 text-center">
                        <img id="imgPreview" src="https://via.placeholder.com/150x100?text=Sin+Imagen" class="img-thumbnail mt-2" style="max-height: 100px; object-fit: contain;" onerror="this.src='https://via.placeholder.com/150x100?text=Error+Imagen'">
                    </div>
                </div>
            </form>
        </div>
    </div>

    <table class="table bg-white shadow-sm">
        <thead class="table-dark">
            <tr><th>Nombre</th><th>Categoría</th><th>Precio</th><th>Stock</th><th>Acciones</th></tr>
        </thead>
        <tbody>
     
        <% for(Mueble p : productos) { %>
            <tr>
                <td><%= p.getNombre() %></td>
                <td><%= p.getCategoriaNombre() %></td>
                <td>S/ <%= p.getPrecio() %></td>
                <td><%= p.getStock() %></td>
  
                <td>
                    <button class="btn btn-warning btn-sm" onclick="editar(<%= p.getId() %>, '<%= p.getNombre() %>', <%= p.getPrecio() %>, <%= p.getStock() %>, <%= p.getCategoriaId() %>, '<%= p.getMaterial() != null ? p.getMaterial() : "" %>', <%= p.getAlto() %>, <%= p.getAncho() %>, <%= p.getProfundidad() %>, '<%= p.getImagenUrl() != null ? p.getImagenUrl() : "" %>')">Editar</button>
                    <form action="GestionProductosServlet" method="POST" class="d-inline">
             
                        <input type="hidden" name="accion" value="eliminar">
                        <input type="hidden" name="id" value="<%= p.getId() %>">
                        <button type="submit" class="btn btn-danger btn-sm">Eliminar</button>
                    </form>
         
                </td>
            </tr>
            <% } %>
        </tbody>
    </table>
</div>

<script>
    function editar(id, nombre, precio, stock, catId, mat, alto, ancho, prof, imgUrl) {
        document.getElementById('accion').value = 'editar';
        document.getElementById('productoId').value = id;
        document.getElementById('nombre').value = nombre;
        document.getElementById('precio').value = precio;
        document.getElementById('stock').value = stock;
        document.getElementById('categoriaId').value = catId;
        document.getElementById('material').value = mat;
        document.getElementById('alto').value = alto;
        document.getElementById('ancho').value = ancho;
        document.getElementById('profundidad').value = prof;
        
        // Asignamos la URL al campo y actualizamos la vista previa
        document.getElementById('imagenUrl').value = imgUrl;
        actualizarPrevia();
        
        document.getElementById('formHeader').textContent = 'Editando Mueble ID: ' + id;
        document.getElementById('btnGuardar').textContent = 'Actualizar';
    }

    function actualizarPrevia() {
        var url = document.getElementById('imagenUrl').value;
        var preview = document.getElementById('imgPreview');
        if (url && url.trim() !== '') {
            preview.src = url;
        } else {
            preview.src = 'https://via.placeholder.com/150x100?text=Sin+Imagen';
        }
    }
</script>
</body>
</html>