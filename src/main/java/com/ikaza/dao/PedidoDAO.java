/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.ikaza.dao;

import com.ikaza.config.Conexion;
import com.ikaza.modelo.Pedido;
import com.ikaza.modelo.DetallePedido;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

public class PedidoDAO {

    private Conexion conexion = new Conexion();

    public boolean crearPedido(Pedido pedido, List<DetallePedido> detalles) {
        boolean exito = false;
        
        String sqlPedido = "INSERT INTO pedidos (usuario_id, fecha, estado, total, nombre) VALUES (?, ?, ?, ?, ?) RETURNING id";
        String sqlDetalle = "INSERT INTO detalles_pedidos (pedido_id, producto_id, cantidad, precio_unitario, fecha_inicio, fecha_fin, direccion) VALUES (?, ?, ?, ?, ?, ?, ?)";
        String sqlStock = "UPDATE productos SET stock = stock - ? WHERE id = ?";

        Connection con = null;

        try {
            con = conexion.conectar();
            con.setAutoCommit(false); 

            int pedidoIdGenerado = 0;
            
            try (PreparedStatement psPedido = con.prepareStatement(sqlPedido)) {
                psPedido.setInt(1, pedido.getUsuarioId());
                psPedido.setTimestamp(2, pedido.getFecha());
                psPedido.setString(3, pedido.getEstado());
                psPedido.setDouble(4, pedido.getTotal());
                psPedido.setString(5, pedido.getNombre());
                
                try (ResultSet rs = psPedido.executeQuery()) {
                    if (rs.next()) {
                        pedidoIdGenerado = rs.getInt(1);
                    }
                }
            }

            if (pedidoIdGenerado > 0) {
                try (PreparedStatement psDetalle = con.prepareStatement(sqlDetalle);
                     PreparedStatement psStock = con.prepareStatement(sqlStock)) {
                    
                    for (DetallePedido detalle : detalles) {
                        psDetalle.setInt(1, pedidoIdGenerado);
                        psDetalle.setInt(2, detalle.getMuebleId());
                        psDetalle.setInt(3, detalle.getCantidad());
                        psDetalle.setDouble(4, detalle.getPrecioUnitario());
                        psDetalle.setDate(5, detalle.getFechaInicio());
                        psDetalle.setDate(6, detalle.getFechaFin());
                        psDetalle.setString(7, detalle.getDireccion());
                        psDetalle.addBatch();

                        psStock.setInt(1, detalle.getCantidad());
                        psStock.setInt(2, detalle.getMuebleId());
                        psStock.executeUpdate();
                    }
                    psDetalle.executeBatch();
                }
                
                con.commit();
                exito = true;
            }
        } catch (SQLException e) {
            try { 
                if (con != null) con.rollback(); 
            } catch (SQLException ex) { 
                System.out.println("Error en rollback: " + ex.getMessage()); 
            }
            throw new RuntimeException("Error en la transacción: " + e.getMessage(), e);
        } finally {
            try { 
                if (con != null) { 
                    con.setAutoCommit(true); 
                    con.close(); 
                } 
            } catch (SQLException e) { 
                System.out.println("Error al cerrar conexión: " + e.getMessage()); 
            }
        }
        return exito;
    }
    
    public List<Pedido> listarPedidosPorUsuario(int usuarioId) {
        List<Pedido> lista = new java.util.ArrayList<>();
        String sql = "SELECT * FROM pedidos WHERE usuario_id = ? ORDER BY fecha DESC";
        try (Connection con = conexion.conectar(); 
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, usuarioId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Pedido p = new Pedido();
                    p.setId(rs.getInt("id"));
                    p.setUsuarioId(rs.getInt("usuario_id"));
                    p.setFecha(rs.getTimestamp("fecha"));
                    p.setEstado(rs.getString("estado"));
                    p.setTotal(rs.getDouble("total"));
                    p.setNombre(rs.getString("nombre"));
                    lista.add(p);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error al listar pedidos: " + e.getMessage());
        }
        return lista;
    }
    
    public List<Pedido> listarPedidosAdmin(String estado, String cliente, String fecha) {
        List<Pedido> lista = new java.util.ArrayList<>();
        
        // 🌟 AQUÍ ESTÁ LA INTEGRACIÓN: He añadido la subconsulta para extraer la dirección
        StringBuilder sql = new StringBuilder("SELECT p.*, u.nombre as nombre_cliente, " +
                                             "(SELECT direccion FROM detalles_pedidos WHERE pedido_id = p.id LIMIT 1) as direccion_envio " +
                                             "FROM pedidos p " +
                                             "JOIN usuarios u ON p.usuario_id = u.id WHERE 1=1 ");

        if(estado != null && !estado.isEmpty()) sql.append(" AND p.estado = ?");
        if(cliente != null && !cliente.isEmpty()) sql.append(" AND u.nombre ILIKE ?");
        if(fecha != null && !fecha.isEmpty()) sql.append(" AND CAST(p.fecha AS DATE) = ?");
        sql.append(" ORDER BY p.fecha DESC");

        try (Connection con = conexion.conectar(); PreparedStatement ps = con.prepareStatement(sql.toString())) {
            int i = 1;
            if(estado != null && !estado.isEmpty()) ps.setString(i++, estado);
            if(cliente != null && !cliente.isEmpty()) ps.setString(i++, "%" + cliente + "%");
            if(fecha != null && !fecha.isEmpty()) ps.setString(i++, fecha);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Pedido p = new Pedido();
                    p.setId(rs.getInt("id"));
                    p.setNombre(rs.getString("nombre"));
                    p.setTotal(rs.getDouble("total"));
                    p.setEstado(rs.getString("estado"));
                    p.setFecha(rs.getTimestamp("fecha"));
                    
                    p.setNombreCliente(rs.getString("nombre_cliente"));
                    
                    // 🌟 Asignamos la dirección recuperada por la subconsulta SQL
                    p.setDireccion(rs.getString("direccion_envio"));
                    
                    lista.add(p);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return lista;
    }

    public boolean actualizarEstado(int id, String nuevoEstado) {
        String sql = "UPDATE pedidos SET estado = ? WHERE id = ?";
        try (Connection con = conexion.conectar(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, nuevoEstado);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { return false; }
    }
}
