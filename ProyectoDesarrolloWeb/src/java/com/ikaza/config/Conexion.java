/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.ikaza.config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Conexion {

    
    
    // Datos de tu base de datos en pgAdmin4
    private String url = "jdbc:postgresql://localhost:5432/ikaza-Base";
    private String user = "postgres"; // Usuario por defecto
    private String pass = "admin"; // ¡CAMBIA ESTO por tu contraseña de pgAdmin!
    
    protected Connection conexion;

    public Connection conectar() {
        try {
            // Registrar el driver de PostgreSQL
            Class.forName("org.postgresql.Driver");
            // Establecer la conexión
            conexion = DriverManager.getConnection(url, user, pass);
            System.out.println("Conexión exitosa a Ikaza DB");
        } catch (ClassNotFoundException | SQLException e) {
            System.out.println("Error al conectar: " + e.getMessage());
        }
        return conexion;
    }
    
    public void desconectar() {
        try {
            if (conexion != null && !conexion.isClosed()) {
                conexion.close();
            }
        } catch (SQLException e) {
            System.out.println("Error al cerrar: " + e.getMessage());
        }
    }
}
