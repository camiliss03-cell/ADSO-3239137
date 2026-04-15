-- ============================================================
-- BASE DE DATOS: Carrito de Compras
-- MOTOR: MySQL 8.0
-- ============================================================

CREATE DATABASE IF NOT EXISTS carrito_compras;
USE carrito_compras;

-- ============================================================
-- CREACIÓN DE TABLAS
-- ============================================================

CREATE TABLE categorias (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    activo TINYINT(1) DEFAULT 1
);

CREATE TABLE productos (
    id_producto INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    id_categoria INT,
    FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria)
);

CREATE TABLE clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    telefono VARCHAR(20),
    fecha_registro DATE DEFAULT (CURRENT_DATE)
);

CREATE TABLE pedidos (
    id_pedido INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    fecha_pedido DATETIME DEFAULT CURRENT_TIMESTAMP,
    estado VARCHAR(50) DEFAULT 'pendiente',
    total DECIMAL(10,2) DEFAULT 0,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);

CREATE TABLE detalle_pedido (
    id_detalle INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) GENERATED ALWAYS AS (cantidad * precio_unitario) STORED,
    FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido),
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);

-- ============================================================
-- INSERCIONES
-- ============================================================

-- Categorias (5 registros)
INSERT INTO categorias (nombre, descripcion) VALUES
('Electrónica', 'Dispositivos electrónicos y accesorios'),
('Ropa', 'Prendas de vestir para hombre y mujer'),
('Hogar', 'Artículos para el hogar y decoración'),
('Deportes', 'Equipos y ropa deportiva'),
('Alimentos', 'Productos alimenticios y bebidas');

-- Productos (5 registros)
INSERT INTO productos (nombre, precio, stock, id_categoria) VALUES
('Audífonos Bluetooth', 89900.00, 30, 1),
('Camiseta Deportiva', 45000.00, 100, 2),
('Lámpara de Mesa', 65000.00, 20, 3),
('Balón de Fútbol', 75000.00, 50, 4),
('Aceite de Oliva 500ml', 28000.00, 80, 5);

-- Clientes (5 registros)
INSERT INTO clientes (nombre, apellido, email, telefono) VALUES
('Carlos', 'Ramírez', 'carlos.ramirez@email.com', '3101234567'),
('Laura', 'Gómez', 'laura.gomez@email.com', '3209876543'),
('Andrés', 'Torres', 'andres.torres@email.com', '3154567890'),
('Valentina', 'Ríos', 'valentina.rios@email.com', '3001112233'),
('Sebastián', 'Mora', 'sebastian.mora@email.com', '3184445566');

-- Pedidos (5 registros)
INSERT INTO pedidos (id_cliente, estado, total) VALUES
(1, 'completado', 179800.00),
(2, 'pendiente', 45000.00),
(3, 'completado', 103000.00),
(4, 'cancelado', 75000.00),
(5, 'pendiente', 56000.00);

-- Detalle_pedido (5 registros)
INSERT INTO detalle_pedido (id_pedido, id_producto, cantidad, precio_unitario) VALUES
(1, 1, 2, 89900.00),
(2, 2, 1, 45000.00),
(3, 3, 1, 65000.00),
(3, 5, 1, 28000.00),
(4, 4, 1, 75000.00);

-- ============================================================
-- ACTUALIZACIONES
-- ============================================================

-- Categorias
UPDATE categorias SET descripcion = 'Dispositivos electrónicos, gadgets y accesorios tecnológicos' WHERE id_categoria = 1;
UPDATE categorias SET activo = 0 WHERE id_categoria = 5;

-- Productos
UPDATE productos SET precio = 95000.00 WHERE id_producto = 1;
UPDATE productos SET stock = stock - 10 WHERE id_producto = 4;

-- Clientes
UPDATE clientes SET telefono = '3107654321' WHERE id_cliente = 1;
UPDATE clientes SET email = 'laura.gomez2025@email.com' WHERE id_cliente = 2;

-- Pedidos
UPDATE pedidos SET estado = 'completado' WHERE id_pedido = 2;
UPDATE pedidos SET total = 113000.00 WHERE id_pedido = 3;

-- Detalle_pedido
UPDATE detalle_pedido SET cantidad = 3 WHERE id_detalle = 1;
UPDATE detalle_pedido SET precio_unitario = 70000.00 WHERE id_detalle = 5;

-- ============================================================
-- ELIMINACIONES
-- ============================================================

SET FOREIGN_KEY_CHECKS=0;

-- Categorias
DELETE FROM categorias WHERE id_categoria = 5 AND activo = 0;
DELETE FROM categorias WHERE nombre = 'Alimentos';

-- Productos
DELETE FROM productos WHERE stock = 0;
DELETE FROM productos WHERE id_producto = 5;

-- Clientes
DELETE FROM clientes WHERE id_cliente = 5;
DELETE FROM clientes WHERE email = 'sebastian.mora@email.com';

-- Pedidos
DELETE FROM pedidos WHERE estado = 'cancelado';
DELETE FROM pedidos WHERE id_pedido = 4;

-- Detalle_pedido
DELETE FROM detalle_pedido WHERE id_detalle = 5;
DELETE FROM detalle_pedido WHERE id_pedido = 4;

SET FOREIGN_KEY_CHECKS=1;

-- ============================================================
-- CONSULTAS SELECT CON WHERE
-- ============================================================

-- Categorias
SELECT * FROM categorias WHERE activo = 1;
SELECT nombre, descripcion FROM categorias WHERE id_categoria > 2;

-- Productos
SELECT nombre, precio FROM productos WHERE precio > 50000;
SELECT * FROM productos WHERE stock < 50;

-- Clientes
SELECT nombre, apellido, email FROM clientes WHERE id_cliente <= 3;
SELECT * FROM clientes WHERE telefono LIKE '310%';

-- Pedidos
SELECT * FROM pedidos WHERE estado = 'completado';
SELECT id_pedido, total FROM pedidos WHERE total > 100000;

-- Detalle_pedido
SELECT * FROM detalle_pedido WHERE cantidad > 1;
SELECT id_pedido, id_producto, subtotal FROM detalle_pedido WHERE subtotal > 50000;

-- ============================================================
-- INNER JOIN
-- ============================================================

-- JOIN 1: Pedidos con información del cliente y estado
SELECT 
    p.id_pedido,
    c.nombre,
    c.apellido,
    c.email,
    p.fecha_pedido,
    p.estado,
    p.total
FROM pedidos p
INNER JOIN clientes c ON p.id_cliente = c.id_cliente
WHERE p.estado = 'completado';

-- JOIN 2: Detalle de pedidos con nombre del producto y categoría
SELECT 
    dp.id_pedido,
    pr.nombre AS producto,
    cat.nombre AS categoria,
    dp.cantidad,
    dp.precio_unitario,
    dp.subtotal
FROM detalle_pedido dp
INNER JOIN productos pr ON dp.id_producto = pr.id_producto
INNER JOIN categorias cat ON pr.id_categoria = cat.id_categoria;
