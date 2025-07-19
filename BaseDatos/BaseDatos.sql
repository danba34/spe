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