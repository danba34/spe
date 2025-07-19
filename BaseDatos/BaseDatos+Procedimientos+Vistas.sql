CREATE DATABASE IF NOT EXISTS Speedan;
USE Speedan;

-- Tabla de Usuarios
CREATE TABLE IF NOT EXISTS Usuario (
    IdUsuario INT AUTO_INCREMENT PRIMARY KEY,
    NombreUsuario VARCHAR(50) UNIQUE NOT NULL,
    Contrasena CHAR(64) NOT NULL,
    Rol ENUM('Administrador','Vendedor') NOT NULL
);

-- Tabla de Productos (CON UNIQUE PARA EVITAR DUPLICADOS)
CREATE TABLE IF NOT EXISTS Producto (
    IdProducto INT AUTO_INCREMENT PRIMARY KEY,
    Modelo VARCHAR(50) NOT NULL,
    Talla DECIMAL(3,1) NOT NULL,
    Color VARCHAR(20) NOT NULL,
    Precio DECIMAL(10,2) NOT NULL,
    Stock INT NOT NULL DEFAULT 0,
    UNIQUE KEY (Modelo, Talla, Color),  -- Evita productos duplicados
    CHECK (Talla BETWEEN 20 AND 50),
    CHECK (Precio > 0),
    CHECK (Stock >= 0)
);

-- Tabla de Ventas
CREATE TABLE IF NOT EXISTS Venta (
    IdVenta INT AUTO_INCREMENT PRIMARY KEY,
    IdUsuario INT NOT NULL,
    FechaVenta TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Total DECIMAL(12,2) NOT NULL,
    FOREIGN KEY (IdUsuario) REFERENCES Usuario(IdUsuario)
);

-- Tabla de Detalles de Venta
CREATE TABLE IF NOT EXISTS DetalleVenta (
    IdDetalle INT AUTO_INCREMENT PRIMARY KEY,
    IdVenta INT NOT NULL,
    IdProducto INT NOT NULL, 
    Cantidad INT NOT NULL,
    PrecioUnitario DECIMAL(10,2) NOT NULL,
    Subtotal DECIMAL(12,2) NOT NULL,
    FOREIGN KEY (IdVenta) REFERENCES Venta(IdVenta),
    FOREIGN KEY (IdProducto) REFERENCES Producto(IdProducto),
    CHECK (Cantidad > 0)
);

-- DESACTIVAR SAFE UPDATE MODE TEMPORALMENTE
SET SQL_SAFE_UPDATES = 0;

-- LIMPIAR DATOS EXISTENTES PARA EVITAR DUPLICADOS
DELETE FROM DetalleVenta;
DELETE FROM Venta;
DELETE FROM Producto;
DELETE FROM Usuario;

-- Reiniciar AUTO_INCREMENT
ALTER TABLE Usuario AUTO_INCREMENT = 1;
ALTER TABLE Producto AUTO_INCREMENT = 1;
ALTER TABLE Venta AUTO_INCREMENT = 1;
ALTER TABLE DetalleVenta AUTO_INCREMENT = 1;

-- REACTIVAR SAFE UPDATE MODE
SET SQL_SAFE_UPDATES = 1;

-- Insertar usuarios SOLO SI NO EXISTEN
INSERT IGNORE INTO Usuario (NombreUsuario, Contrasena, Rol) VALUES
('admin', SHA2('Admin123', 256), 'Administrador'),
('vendedor1', SHA2('Vendedor123', 256), 'Vendedor'),
('vendedor2', SHA2('Venta456', 256), 'Vendedor');

-- Insertar productos SOLO SI NO EXISTEN
INSERT IGNORE INTO Producto (Modelo, Talla, Color, Precio, Stock) VALUES
('Runner', 42.0, 'Negro', 359000.00, 50),
('Urban', 38.5, 'Blanco', 302000.00, 30),
('Sport', 40.0, 'Azul', 480000.00, 20),
('Classic', 41.0, 'Café', 380000.00, 15),
('Light', 39.0, 'Rojo', 442000.00, 5);

-- Insertar ventas SOLO SI NO EXISTEN (verificando que existan los usuarios)
INSERT INTO Venta (IdUsuario, Total) 
SELECT 2, 661000.00 WHERE NOT EXISTS (SELECT 1 FROM Venta WHERE IdUsuario = 2 AND Total = 661000.00)
UNION ALL
SELECT 3, 960000.00 WHERE NOT EXISTS (SELECT 1 FROM Venta WHERE IdUsuario = 3 AND Total = 960000.00)
UNION ALL
SELECT 2, 442000.00 WHERE NOT EXISTS (SELECT 1 FROM Venta WHERE IdUsuario = 2 AND Total = 442000.00);

-- Insertar detalles de venta SOLO SI NO EXISTEN
INSERT INTO DetalleVenta (IdVenta, IdProducto, Cantidad, PrecioUnitario, Subtotal) 
SELECT 1, 1, 1, 359000.00, 359000.00 WHERE NOT EXISTS (SELECT 1 FROM DetalleVenta WHERE IdVenta = 1 AND IdProducto = 1)
UNION ALL
SELECT 1, 2, 1, 302000.00, 302000.00 WHERE NOT EXISTS (SELECT 1 FROM DetalleVenta WHERE IdVenta = 1 AND IdProducto = 2)
UNION ALL
SELECT 2, 3, 2, 480000.00, 960000.00 WHERE NOT EXISTS (SELECT 1 FROM DetalleVenta WHERE IdVenta = 2 AND IdProducto = 3)
UNION ALL
SELECT 3, 5, 1, 442000.00, 442000.00 WHERE NOT EXISTS (SELECT 1 FROM DetalleVenta WHERE IdVenta = 3 AND IdProducto = 5);

-- Permisos DCL
CREATE ROLE IF NOT EXISTS 'Administrador';
CREATE ROLE IF NOT EXISTS 'Vendedor';

GRANT ALL PRIVILEGES ON Speedan.* TO 'Administrador';

GRANT SELECT, INSERT, UPDATE ON Speedan.Venta TO 'Vendedor';
GRANT SELECT, INSERT, UPDATE ON Speedan.DetalleVenta TO 'Vendedor';
GRANT SELECT, INSERT, UPDATE ON Speedan.Producto TO 'Vendedor';
GRANT SELECT ON Speedan.Usuario TO 'Vendedor';  

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

-- Procedimientos almacenados

-- 1. Procedimiento IN (Registrar nueva venta)
DROP PROCEDURE IF EXISTS RegistrarVenta;
DELIMITER //
CREATE PROCEDURE RegistrarVenta(
    IN usuario_id INT,
    IN producto_id INT,
    IN cantidad INT
)
BEGIN
    DECLARE precio_actual DECIMAL(10,2);
    DECLARE stock_actual INT;
    
    -- Obtener precio y stock actual
    SELECT Precio, Stock INTO precio_actual, stock_actual 
    FROM Producto 
    WHERE IdProducto = producto_id;
    
    -- Validar stock
    IF cantidad > stock_actual THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error: Stock insuficiente';
    END IF;
    
    -- Registrar venta principal
    INSERT INTO Venta (IdUsuario, Total) 
    VALUES (usuario_id, precio_actual * cantidad);
    
    -- Obtener ID de venta recién insertada
    SET @venta_id = LAST_INSERT_ID();
    
    -- Registrar detalle de venta
    INSERT INTO DetalleVenta (IdVenta, IdProducto, Cantidad, PrecioUnitario, Subtotal)
    VALUES (@venta_id, producto_id, cantidad, precio_actual, precio_actual * cantidad);
    
    -- Actualizar stock
    UPDATE Producto SET Stock = Stock - cantidad 
    WHERE IdProducto = producto_id;
    
    -- Confirmación exitosa
    SELECT 'Venta registrada con éxito' AS Resultado;
END //
DELIMITER ;

-- 2. Procedimiento OUT (Obtener información de producto)
DROP PROCEDURE IF EXISTS ObtenerInfoProducto;
DELIMITER //
CREATE PROCEDURE ObtenerInfoProducto(
    IN pIdProducto INT,
    OUT pModelo VARCHAR(50),
    OUT pPrecio DECIMAL(10,2),
    OUT pStock INT
)
BEGIN
    SELECT Modelo, Precio, Stock INTO pModelo, pPrecio, pStock
    FROM Producto
    WHERE IdProducto = pIdProducto;
END //
DELIMITER ;

-- 3. Procedimiento INOUT (Ajustar precio producto)
DROP PROCEDURE IF EXISTS AjustarPrecioProducto;
DELIMITER //
CREATE PROCEDURE AjustarPrecioProducto(
    INOUT pIdProducto INT,
    IN pPorcentaje DECIMAL(5,2)
)
BEGIN
    UPDATE Producto 
    SET Precio = Precio * (1 + pPorcentaje/100)
    WHERE IdProducto = pIdProducto;
    
    -- Obtener nuevo precio y asignar a la variable INOUT
    SELECT Precio INTO pIdProducto
    FROM Producto
    WHERE IdProducto = pIdProducto;
END //
DELIMITER ;

-- VERIFICAR QUE NO HAY DUPLICADOS
SELECT 'USUARIOS:' AS Tabla;
SELECT * FROM Usuario;

SELECT 'PRODUCTOS:' AS Tabla;
SELECT * FROM Producto;

SELECT 'VENTAS:' AS Tabla;
SELECT * FROM Venta;

SELECT 'DETALLES DE VENTA:' AS Tabla;
SELECT * FROM DetalleVenta;

-- 1. Usar procedimiento IN (Registrar venta)
-- Verificar stock disponible
SELECT * FROM Producto WHERE IdProducto = 3;

-- Registrar venta (ejemplo)
CALL RegistrarVenta(2, 3, 1);

-- 2. Usar procedimiento OUT (Obtener detalles de producto)
SET @modelo = '';
SET @precio = 0;
SET @stock = 0;
CALL ObtenerInfoProducto(3, @modelo, @precio, @stock);
SELECT @modelo AS Modelo, @precio AS Precio, @stock AS Stock;

-- 3. Usar procedimiento INOUT (Ajustar precio)
SET @idProducto = 3;  -- ID de producto
SET @porcentaje = 10; -- Aumento del 10%
CALL AjustarPrecioProducto(@idProducto, @porcentaje);
SELECT @idProducto AS NuevoPrecio;  -- Muestra el nuevo precio