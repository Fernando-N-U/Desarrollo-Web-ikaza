package com.ikaza.controlador;

import com.ikaza.dao.UsuarioDAO;
import com.ikaza.modelo.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "LoginServlet", urlPatterns = {"/LoginServlet"})
public class LoginServlet extends HttpServlet {

    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String correo = request.getParameter("txtCorreo");
        String pass = request.getParameter("txtPassword");
        
        // Generamos el hash para comparar con la base de datos
        String passHasheada = com.ikaza.util.HashUtils.hashPassword(pass);
        
        // Validamos las credenciales mediante el DAO
        Usuario usuario = usuarioDAO.validar(correo, passHasheada);

        if (usuario != null) {
            HttpSession sesion = request.getSession();
            
            // 1. Guardamos el objeto completo para el flujo del carrito
            sesion.setAttribute("usuarioLogueado", usuario); 
            
            // 2. Atributos individuales para compatibilidad con tus JSPs actuales
            sesion.setAttribute("nombre", usuario.getNombre()); 
            String rol = usuario.getRol();
            sesion.setAttribute("role", rol); 
            sesion.setAttribute("rol", rol);

            // 3. ¡NUEVO! Guardamos ID, DNI y Teléfono directamente en la sesión
            // Esto es vital para que PerfilServlet pueda editarlos en caliente y refrescar el panel
            sesion.setAttribute("idUsuario", usuario.getId()); // Si tu getter se llama diferente (ej: getIdUsuario), cámbialo aquí
            sesion.setAttribute("dni", usuario.getDni());       
            sesion.setAttribute("telefono", usuario.getTelefono());

            // Redirección inteligente según el rol
            if ("admin".equals(rol) || "empleado".equals(rol)) {
                response.sendRedirect("admin/admin_panel.jsp");
            } else {
                // Al redirigir al Servlet, obligamos a que se carguen los productos de la BD
                response.sendRedirect("IndexServlet"); 
            }
        } else {
            request.setAttribute("error", "Correo o contraseña incorrectos.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}
