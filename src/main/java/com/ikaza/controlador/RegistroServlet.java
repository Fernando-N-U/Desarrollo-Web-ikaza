/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.ikaza.controlador;

import com.ikaza.dao.UsuarioDAO;
import com.ikaza.modelo.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "RegistroServlet", urlPatterns = {"/RegistroServlet"})
public class RegistroServlet extends HttpServlet {

    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Recibimos los datos básicos del formulario (sin DNI ni teléfono)
        String nombre = request.getParameter("txtNombre");
        String correo = request.getParameter("txtCorreo");
        String pass = request.getParameter("txtPassword");
        
        // Hasheamos la contraseña por seguridad antes de guardarla
        String passHasheada = com.ikaza.util.HashUtils.hashPassword(pass);

        // Construimos el objeto Usuario con los datos iniciales
        Usuario nuevoUsuario = new Usuario();
        nuevoUsuario.setNombre(nombre);
        nuevoUsuario.setCorreo(correo);
        nuevoUsuario.setPassword(passHasheada);
        nuevoUsuario.setRol("cliente");
        nuevoUsuario.setActivo(true);

        // Delegamos el registro al DAO
        boolean registrado = usuarioDAO.registrar(nuevoUsuario); 

        if (registrado) {
            request.setAttribute("mensaje", "¡Registro exitoso! Ya puedes iniciar sesión.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Error al registrar: El correo electrónico ya se encuentra registrado.");
            request.getRequestDispatcher("registro.jsp").forward(request, response);
        }
    }
}
