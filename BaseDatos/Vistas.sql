-- Crear vistas
CREATE OR REPLACE VIEW VistaProductosBajoStock AS
SELECT Modelo, Color, Talla, Stock
FROM Producto
WHERE Stock < 10;

CREATE OR REPLACE VIEW VistaVentasResumen AS
SELECT 
    v.IdVenta,
    u.NombreUsuario AS Vendedor,
    v.FechaVenta,
    v.Total,
    COUNT(d.IdDetalle) AS ProductosVendidos
FROM Venta v
JOIN Usuario u ON v.IdUsuario = u.IdUsuario
JOIN DetalleVenta d ON v.IdVenta = d.IdVenta
GROUP BY v.IdVenta;

-- Consultar vistas
SELECT * FROM VistaProductosBajoStock;
SELECT * FROM VistaVentasResumen;