/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.ikaza.config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Conexion {

    // Datos de tu base de datos en la nube (Render)
    private String url = "jdbc:postgresql://dpg-d982t058nd3s73bjm0c0-a.oregon-postgres.render.com:5432/ikaza?sslmode=require";
    private String user = "fernando"; 
    private String pass = "6oOROOkXuOWQIbs02EhCREAJWJ6C0d8I"; 
    
    protected Connection conexion;

    public Connection conectar() {
        try {
            // Registrar el driver de PostgreSQL
            Class.forName("org.postgresql.Driver");
            // Establecer la conexión
            conexion = DriverManager.getConnection(url, user, pass);
            System.out.println("Conexión exitosa a Ikaza DB en la nube");
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
