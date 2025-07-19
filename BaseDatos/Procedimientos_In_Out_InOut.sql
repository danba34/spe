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