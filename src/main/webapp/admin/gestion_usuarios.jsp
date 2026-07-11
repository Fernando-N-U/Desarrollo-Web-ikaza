<%-- 
    Document   : gestion_usuarios
    Created on : 19 abr. 2026, 11:12:47
    Author     : LISET
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%
    HttpSession sesion = request.getSession();
    if (!"admin".equals(sesion.getAttribute("rol"))) {
        response.sendRedirect("login.jsp");
        return;
    }
    List<Map<String, String>> usuarios = (List<Map<String, String>>) request.getAttribute("usuarios");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Gestión de Usuarios - Ikaza</title>
    <link href="${pageContext.request.contextPath}/assets/css/estilos.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container mt-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1>Gestión de Roles</h1>
            <a href="admin/admin_panel.jsp" class="btn btn-secondary">Volver al Panel</a>
        </div>
        
                <div class="container mb-3">
            <form action="UsuariosServlet" method="GET" class="row g-2 align-items-center bg-white p-3 shadow-sm rounded">
                <div class="col-md-5">
                    <input type="text" name="txtBuscar" class="form-control" placeholder="Buscar por nombre..." value="${paramBuscar != null ? paramBuscar : ''}">
                </div>
                <div class="col-md-4">
                    <select name="txtRol" class="form-select">
                        <option value="">Todos los rangos (Clientes y Empleados)</option>
                        <option value="Cliente" ${paramRol == 'Cliente' ? 'selected' : ''}>Solo Clientes</option>
                        <option value="Empleado" ${paramRol == 'Empleado' ? 'selected' : ''}>Solo Empleados</option>
                    </select>
                </div>
                <div class="col-md-3 d-flex gap-2">
                    <button type="submit" class="btn btn-primary w-100"><i class="bi bi-search"></i> Filtrar</button>
                    <a href="UsuariosServlet" class="btn btn-outline-secondary w-100">Limpiar</a>
                </div>
            </form>
        </div>

        <div class="card shadow">
            <div class="card-body">
                <table class="table table-hover">
                    <thead class="table-dark">
                        <tr>
                            <th>ID</th>
                            <th>Nombre</th>
                            <th>Correo</th>
                            <th>Rol Actual</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (usuarios != null) { 
                            for (Map<String, String> u : usuarios) { %>
                            <tr>
                                <td><%= u.get("id") %></td>
                                <td><%= u.get("nombre") %></td>
                                <td><%= u.get("correo") %></td>
                                <td>
                                    <span class="badge <%= u.get("rol").equals("admin") ? "bg-danger" : (u.get("rol").equals("empleado") ? "bg-warning text-dark" : "bg-info text-dark") %>">
                                        <%= u.get("rol").toUpperCase() %>
                                    </span>
                                </td>
                                <td>
                                    <form action="UsuariosServlet" method="POST" class="d-inline">
                                        <input type="hidden" name="id" value="<%= u.get("id") %>">
                                        <select name="nuevoRol" class="form-select form-select-sm d-inline w-auto" onchange="this.form.submit()">
                                            <option value="cliente" <%= u.get("rol").equals("cliente") ? "selected" : "" %>>Cliente</option>
                                            <option value="empleado" <%= u.get("rol").equals("empleado") ? "selected" : "" %>>Empleado</option>
                                            <option value="admin" <%= u.get("rol").equals("admin") ? "selected" : "" %>>Admin</option>
                                        </select>
                                    </form>
                                </td>
                            </tr>
                        <%  } 
                        } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</body>
</html>
