/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.ikaza.modelo;

import java.sql.Timestamp;

public class Pedido {
    private int id;
    private int usuarioId;
    private Timestamp fecha;
    private String estado;
    private double total;
    private String nombre; // Descripción del pedido
    private String nombreCliente; // Campo extra para la vista
    private String direccion;    // Campo extra para la vista

    public Pedido() {
    }

    public Pedido(int id, int usuarioId, Timestamp fecha, String estado, double total, String nombre) {
        this.id = id;
        this.usuarioId = usuarioId;
        this.fecha = fecha;
        this.estado = estado;
        this.total = total;
        this.nombre = nombre;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUsuarioId() { return usuarioId; }
    public void setUsuarioId(int usuarioId) { this.usuarioId = usuarioId; }

    public Timestamp getFecha() { return fecha; }
    public void setFecha(Timestamp fecha) { this.fecha = fecha; }

    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }

    public double getTotal() { return total; }
    public void setTotal(double total) { this.total = total; }

    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }

    public String getNombreCliente() { return nombreCliente; }
    public void setNombreCliente(String nombreCliente) { this.nombreCliente = nombreCliente; }

    // Getter y Setter para la dirección
    public String getDireccion() { return direccion; }
    public void setDireccion(String direccion) { this.direccion = direccion; }
}
