/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.ikaza.modelo;

import java.sql.Date;

public class DetallePedido {
    private int id;
    private int pedidoId;
    private int muebleId; // Hace referencia a producto_id en la BD
    private int cantidad;
    private double precioUnitario;
    private String direccion;
    private Date fechaInicio;
    private Date fechaFin;

    public DetallePedido() {}

    public DetallePedido(int id, int pedidoId, int muebleId, int cantidad, double precioUnitario, String direccion, Date fechaInicio, Date fechaFin) {
        this.id = id;
        this.pedidoId = pedidoId;
        this.muebleId = muebleId;
        this.cantidad = cantidad;
        this.precioUnitario = precioUnitario;
        this.direccion = direccion;
        this.fechaInicio = fechaInicio;
        this.fechaFin = fechaFin;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getPedidoId() { return pedidoId; }
    public void setPedidoId(int pedidoId) { this.pedidoId = pedidoId; }

    public int getMuebleId() { return muebleId; }
    public void setMuebleId(int muebleId) { this.muebleId = muebleId; }

    public int getCantidad() { return cantidad; }
    public void setCantidad(int cantidad) { this.cantidad = cantidad; }

    public double getPrecioUnitario() { return precioUnitario; }
    public void setPrecioUnitario(double precioUnitario) { this.precioUnitario = precioUnitario; }

    public String getDireccion() { return direccion; }
    public void setDireccion(String direccion) { this.direccion = direccion; }

    public Date getFechaInicio() { return fechaInicio; }
    public void setFechaInicio(Date fechaInicio) { this.fechaInicio = fechaInicio; }

    public Date getFechaFin() { return fechaFin; }
    public void setFechaFin(Date fechaFin) { this.fechaFin = fechaFin; }
} 