-- ============================================================
-- BASE DE DATOS: Biblioteca
-- MOTOR: PostgreSQL 16
-- ============================================================

-- Crear y conectar a la base de datos
\c biblioteca;

-- ============================================================
-- CREACIÓN DE TABLAS
-- ============================================================

CREATE TABLE IF NOT EXISTS categorias (
    id_categoria SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    activo BOOLEAN DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS autores (
    id_autor SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    nacionalidad VARCHAR(100),
    fecha_nacimiento DATE
);

CREATE TABLE IF NOT EXISTS libros (
    id_libro SERIAL PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
    isbn VARCHAR(20) UNIQUE,
    anio_publicacion INT,
    id_autor INT,
    id_categoria INT,
    stock INT DEFAULT 1,
    FOREIGN KEY (id_autor) REFERENCES autores(id_autor),
    FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria)
);

CREATE TABLE IF NOT EXISTS socios (
    id_socio SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    telefono VARCHAR(20),
    fecha_registro DATE DEFAULT CURRENT_DATE
);

CREATE TABLE IF NOT EXISTS prestamos (
    id_prestamo SERIAL PRIMARY KEY,
    id_socio INT NOT NULL,
    id_libro INT NOT NULL,
    fecha_prestamo DATE DEFAULT CURRENT_DATE,
    fecha_devolucion DATE,
    estado VARCHAR(50) DEFAULT 'activo',
    FOREIGN KEY (id_socio) REFERENCES socios(id_socio),
    FOREIGN KEY (id_libro) REFERENCES libros(id_libro)
);

-- ============================================================
-- INSERCIONES
-- ============================================================

-- Categorias (5 registros)
INSERT INTO categorias (nombre, descripcion) VALUES
('Novela', 'Obras de ficción narrativa extensa'),
('Ciencia', 'Libros de divulgación y texto científico'),
('Historia', 'Libros sobre hechos y personajes históricos'),
('Tecnología', 'Libros sobre informática y tecnología'),
('Filosofía', 'Obras de pensamiento y reflexión filosófica');

-- Autores (5 registros)
INSERT INTO autores (nombre, apellido, nacionalidad, fecha_nacimiento) VALUES
('Gabriel', 'García Márquez', 'Colombiana', '1927-03-06'),
('Isaac', 'Asimov', 'Estadounidense', '1920-01-02'),
('Yuval Noah', 'Harari', 'Israelí', '1976-02-24'),
('Robert C.', 'Martin', 'Estadounidense', '1952-12-05'),
('Friedrich', 'Nietzsche', 'Alemana', '1844-10-15');

-- Libros (5 registros)
INSERT INTO libros (titulo, isbn, anio_publicacion, id_autor, id_categoria, stock) VALUES
('Cien Años de Soledad', '978-0-06-088328-7', 1967, 1, 1, 3),
('Fundación', '978-0-553-29335-7', 1951, 2, 1, 2),
('Sapiens', '978-0-06-231609-7', 2011, 3, 3, 4),
('Código Limpio', '978-0-13-235088-4', 2008, 4, 4, 2),
('Así Habló Zaratustra', '978-0-14-044118-1', 1883, 5, 5, 1);

-- Socios (5 registros)
INSERT INTO socios (nombre, apellido, email, telefono) VALUES
('María', 'López', 'maria.lopez@email.com', '3101234567'),
('Juan', 'Martínez', 'juan.martinez@email.com', '3209876543'),
('Ana', 'Pérez', 'ana.perez@email.com', '3154567890'),
('Diego', 'Hernández', 'diego.hernandez@email.com', '3001112233'),
('Sofía', 'Castro', 'sofia.castro@email.com', '3184445566');

-- Prestamos (5 registros)
INSERT INTO prestamos (id_socio, id_libro, fecha_prestamo, fecha_devolucion, estado) VALUES
(1, 1, '2026-03-01', '2026-03-15', 'devuelto'),
(2, 3, '2026-03-10', '2026-03-24', 'devuelto'),
(3, 4, '2026-04-01', NULL, 'activo'),
(4, 2, '2026-04-05', NULL, 'activo'),
(5, 5, '2026-04-10', NULL, 'activo');

-- ============================================================
-- ACTUALIZACIONES
-- ============================================================

-- Categorias
UPDATE categorias SET descripcion = 'Obras literarias de ficción de largo aliento' WHERE id_categoria = 1;
UPDATE categorias SET activo = FALSE WHERE id_categoria = 5;

-- Autores
UPDATE autores SET nacionalidad = 'Colombiano' WHERE id_autor = 1;
UPDATE autores SET fecha_nacimiento = '1920-01-02' WHERE id_autor = 2;

-- Libros
UPDATE libros SET stock = stock + 1 WHERE id_libro = 1;
UPDATE libros SET anio_publicacion = 2012 WHERE id_libro = 3;

-- Socios
UPDATE socios SET telefono = '3107654321' WHERE id_socio = 1;
UPDATE socios SET email = 'juan.martinez2025@email.com' WHERE id_socio = 2;

-- Prestamos
UPDATE prestamos SET estado = 'devuelto', fecha_devolucion = '2026-04-12' WHERE id_prestamo = 3;
UPDATE prestamos SET estado = 'vencido' WHERE id_prestamo = 4;

-- ============================================================
-- ELIMINACIONES
-- ============================================================

-- Categorias
ALTER TABLE libros DISABLE TRIGGER ALL;
DELETE FROM categorias WHERE activo = FALSE;
ALTER TABLE libros ENABLE TRIGGER ALL;

DELETE FROM categorias WHERE nombre = 'Filosofía';

-- Autores
DELETE FROM autores WHERE id_autor = 5;

DELETE FROM autores WHERE apellido = 'Nietzsche';

-- Libros
DELETE FROM libros WHERE stock = 0;
DELETE FROM libros WHERE id_libro = 5;

-- Socios
DELETE FROM socios WHERE id_socio = 5;
DELETE FROM socios WHERE email = 'sofia.castro@email.com';

-- Prestamos
DELETE FROM prestamos WHERE estado = 'vencido';
DELETE FROM prestamos WHERE id_prestamo = 4;

-- ============================================================
-- CONSULTAS SELECT CON WHERE
-- ============================================================

-- Categorias
SELECT * FROM categorias WHERE activo = TRUE;
SELECT nombre, descripcion FROM categorias WHERE id_categoria > 2;

-- Autores
SELECT nombre, apellido FROM autores WHERE nacionalidad = 'Colombiano';
SELECT * FROM autores WHERE fecha_nacimiento < '1960-01-01';

-- Libros
SELECT titulo, precio FROM libros WHERE stock > 1;
SELECT * FROM libros WHERE anio_publicacion > 2000;

-- Socios
SELECT nombre, apellido, email FROM socios WHERE id_socio <= 3;
SELECT * FROM socios WHERE telefono LIKE '310%';

-- Prestamos
SELECT * FROM prestamos WHERE estado = 'activo';
SELECT id_prestamo, id_socio FROM prestamos WHERE fecha_devolucion IS NULL;

-- ============================================================
-- INNER JOIN
-- ============================================================

-- JOIN 1: Préstamos con nombre del socio y título del libro
SELECT 
    p.id_prestamo,
    s.nombre AS socio,
    s.apellido,
    l.titulo AS libro,
    p.fecha_prestamo,
    p.estado
FROM prestamos p
INNER JOIN socios s ON p.id_socio = s.id_socio
INNER JOIN libros l ON p.id_libro = l.id_libro
WHERE p.estado = 'activo';

-- JOIN 2: Libros con su autor y categoría
SELECT 
    l.titulo,
    l.anio_publicacion,
    a.nombre AS autor,
    a.apellido AS apellido_autor,
    c.nombre AS categoria
FROM libros l
INNER JOIN autores a ON l.id_autor = a.id_autor
INNER JOIN categorias c ON l.id_categoria = c.id_categoria;
