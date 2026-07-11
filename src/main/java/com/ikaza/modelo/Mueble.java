package com.ikaza.modelo;

public class Mueble {
    private int id;
    private String nombre;
    private String descripcion;
    private double precio;
    private int stock;
    private String imagenUrl;
    private int categoriaId;
    private String categoriaNombre;
    private String material;
    private double alto;
    private double ancho;
    private double profundidad;

    public Mueble() {}

    // Getters y Setters completos
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }
    
    public String getDescripcion() { return descripcion; }
    public void setDescripcion(String descripcion) { this.descripcion = descripcion; }
    
    public double getPrecio() { return precio; }
    public void setPrecio(double precio) { this.precio = precio; }
    
    public int getStock() { return stock; }
    public void setStock(int stock) { this.stock = stock; }
    
    public String getImagenUrl() { return imagenUrl; }
    public void setImagenUrl(String imagenUrl) { this.imagenUrl = imagenUrl; }
    
    public int getCategoriaId() { return categoriaId; }
    public void setCategoriaId(int categoriaId) { this.categoriaId = categoriaId; }
    
    public String getCategoriaNombre() { return categoriaNombre; }
    public void setCategoriaNombre(String categoriaNombre) { this.categoriaNombre = categoriaNombre; }
    
    public String getMaterial() { return material; }
    public void setMaterial(String material) { this.material = material; }
    
    public double getAlto() { return alto; }
    public void setAlto(double alto) { this.alto = alto; }
    
    public double getAncho() { return ancho; }
    public void setAncho(double ancho) { this.ancho = ancho; }
    
    public double getProfundidad() { return profundidad; }
    public void setProfundidad(double profundidad) { this.profundidad = profundidad; }
}
