package com.ikaza.dao;

import com.ikaza.config.Conexion;
import com.ikaza.modelo.Mueble;
import java.sql.*;
import java.util.*;

public class ProductoDAO {
    Conexion con = new Conexion();

    public List<Mueble> listar(String nombre, Double min, Double max, Integer catId) {
        List<Mueble> lista = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT p.*, c.nombre as cat_nombre FROM productos p LEFT JOIN categorias c ON p.categoria_id = c.id WHERE 1=1 ");
        
        if(nombre != null && !nombre.isEmpty()) sql.append(" AND p.nombre ILIKE ? ");
        if(min != null) sql.append(" AND p.precio >= ? ");
        if(max != null) sql.append(" AND p.precio <= ? ");
        if(catId != null && catId > 0) sql.append(" AND p.categoria_id = ? ");
        
        try (Connection cn = con.conectar(); PreparedStatement ps = cn.prepareStatement(sql.toString())) {
            int i = 1;
            if(nombre != null && !nombre.isEmpty()) ps.setString(i++, "%" + nombre + "%");
            if(min != null) ps.setDouble(i++, min);
            if(max != null) ps.setDouble(i++, max);
            if(catId != null && catId > 0) ps.setInt(i++, catId);

            ResultSet rs = ps.executeQuery();
            while(rs.next()) {
                Mueble m = new Mueble();
                m.setId(rs.getInt("id"));
                m.setNombre(rs.getString("nombre"));
                m.setPrecio(rs.getDouble("precio"));
                m.setStock(rs.getInt("stock"));
                m.setCategoriaNombre(rs.getString("cat_nombre"));
                m.setCategoriaId(rs.getInt("categoria_id"));
                m.setMaterial(rs.getString("material"));
                m.setAlto(rs.getDouble("alto"));
                m.setAncho(rs.getDouble("ancho"));
                m.setProfundidad(rs.getDouble("profundidad"));
                m.setImagenUrl(rs.getString("imagen_url"));
                lista.add(m);
            }
        } catch(Exception e) { e.printStackTrace(); }
        return lista;
    }

    public List<Map<String, String>> listarCategorias() {
        List<Map<String, String>> cats = new ArrayList<>();
        try (Connection cn = con.conectar(); Statement st = cn.createStatement(); 
             ResultSet rs = st.executeQuery("SELECT id, nombre FROM categorias ORDER BY nombre ASC")) {
            while(rs.next()) {
                Map<String, String> m = new HashMap<>();
                m.put("id", rs.getString("id"));
                m.put("nombre", rs.getString("nombre"));
                cats.add(m);
            }
        } catch(Exception e) { e.printStackTrace(); }
        return cats;
    }

    public void eliminar(int id) {
        try (Connection cn = con.conectar(); PreparedStatement ps = cn.prepareStatement("DELETE FROM productos WHERE id=?")) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch(Exception e) { e.printStackTrace(); }
    }

    public void guardar(Mueble m, boolean esEdicion) {
        // Se añade imagen_url en ambas sentencias
        String sql = esEdicion ? 
            "UPDATE productos SET nombre=?, precio=?, stock=?, categoria_id=?, material=?, alto=?, ancho=?, profundidad=?, imagen_url=? WHERE id=?" :
            "INSERT INTO productos (nombre, precio, stock, categoria_id, material, alto, ancho, profundidad, imagen_url) VALUES (?,?,?,?,?,?,?,?,?)";
        
        try (Connection cn = con.conectar(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, m.getNombre());
            ps.setDouble(2, m.getPrecio());
            ps.setInt(3, m.getStock());
            ps.setInt(4, m.getCategoriaId());
            ps.setString(5, m.getMaterial());
            ps.setDouble(6, m.getAlto());
            ps.setDouble(7, m.getAncho());
            ps.setDouble(8, m.getProfundidad());
            ps.setString(9, m.getImagenUrl()); // Asignación del nuevo campo
            
            if(esEdicion) {
                ps.setInt(10, m.getId()); // ID pasa al índice 10
            }
            ps.executeUpdate();
        } catch(Exception e) { e.printStackTrace(); }
    }

    public Mueble obtenerMueblePorId(int id) {
        Mueble m = null;
        String sql = "SELECT p.*, c.nombre as cat_nombre FROM productos p LEFT JOIN categorias c ON p.categoria_id = c.id WHERE p.id = ?";
        
        try (Connection cn = con.conectar(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                m = new Mueble();
                m.setId(rs.getInt("id"));
                m.setNombre(rs.getString("nombre"));
                m.setPrecio(rs.getDouble("precio"));
                m.setStock(rs.getInt("stock"));
                m.setCategoriaNombre(rs.getString("cat_nombre"));
                m.setCategoriaId(rs.getInt("categoria_id"));
                m.setMaterial(rs.getString("material"));
                m.setAlto(rs.getDouble("alto"));
                m.setAncho(rs.getDouble("ancho"));
                m.setProfundidad(rs.getDouble("profundidad"));
                m.setImagenUrl(rs.getString("imagen_url"));
            }
        } catch(Exception e) { e.printStackTrace(); }
        
        return m;
    }
}
