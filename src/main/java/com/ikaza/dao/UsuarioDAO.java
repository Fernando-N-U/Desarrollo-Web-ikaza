/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.ikaza.dao;

import com.ikaza.config.Conexion;
import com.ikaza.modelo.Usuario;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UsuarioDAO {

    // Instanciamos tu clase de conexión
    private Conexion conexion = new Conexion();

    public Usuario validar(String correo, String password) {
        Usuario usuario = null;
        String sql = "SELECT * FROM usuarios WHERE correo = ? AND password = ? AND activo = true";

        // Usamos conexion.conectar() en lugar de Conexion.getConnection()
        try (Connection con = conexion.conectar();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, correo);
            ps.setString(2, password);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    usuario = new Usuario();
                    usuario.setId(rs.getInt("id"));
                    usuario.setNombre(rs.getString("nombre"));
                    usuario.setCorreo(rs.getString("correo"));
                    usuario.setPassword(rs.getString("password"));
                    usuario.setRol(rs.getString("rol"));
                    usuario.setActivo(rs.getBoolean("activo"));
                    usuario.setDni(rs.getInt("dni")); // Asegurado en minúsculas
                    usuario.setTelefono(rs.getInt("telefono"));
                }
            }
        } catch (SQLException e) {
            System.out.println("Error al validar usuario: " + e.getMessage());
        }
        return usuario;
    }

    public boolean registrar(Usuario usuario) {
        String sql = "INSERT INTO usuarios (nombre, correo, password, rol, activo) VALUES (?, ?, ?, ?, ?)";
        boolean registrado = false;

        try (Connection con = conexion.conectar();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, usuario.getNombre());
            ps.setString(2, usuario.getCorreo());
            ps.setString(3, usuario.getPassword());
            ps.setString(4, "cliente");
            ps.setBoolean(5, true);

            int filasAfectadas = ps.executeUpdate();
            if (filasAfectadas > 0) {
                registrado = true;
            }
        } catch (SQLException e) {
            System.out.println("Error al registrar usuario: " + e.getMessage());
        }
        return registrado;
    }

    public boolean completarDatos(int usuarioId, int dni, int telefono) {
        String sql = "UPDATE usuarios SET dni = ?, telefono = ? WHERE id = ?";
        boolean actualizado = false;

        try (Connection con = conexion.conectar();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, dni);
            ps.setInt(2, telefono);
            ps.setInt(3, usuarioId);

            int filasAfectadas = ps.executeUpdate();
            if (filasAfectadas > 0) {
                actualizado = true;
            }
        } catch (SQLException e) {
            System.out.println("Error al actualizar datos del usuario: " + e.getMessage());
        }
        return actualizado;
    }
}