-- ============================================================
-- BASE DE DATOS: Sistema de Vuelos
-- MOTOR: SQL Server 2022
-- ============================================================

CREATE DATABASE sistema_vuelos;
GO

USE sistema_vuelos;
GO

-- ============================================================
-- CREACIÓN DE TABLAS
-- ============================================================

CREATE TABLE aeropuertos (
    id_aeropuerto INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    ciudad VARCHAR(100) NOT NULL,
    pais VARCHAR(100) NOT NULL,
    codigo_iata CHAR(3) UNIQUE NOT NULL
);
GO

CREATE TABLE aviones (
    id_avion INT IDENTITY(1,1) PRIMARY KEY,
    modelo VARCHAR(100) NOT NULL,
    capacidad INT NOT NULL,
    aerolinea VARCHAR(100) NOT NULL,
    activo BIT DEFAULT 1
);
GO

CREATE TABLE vuelos (
    id_vuelo INT IDENTITY(1,1) PRIMARY KEY,
    codigo_vuelo VARCHAR(10) NOT NULL,
    id_avion INT NOT NULL,
    id_origen INT NOT NULL,
    id_destino INT NOT NULL,
    fecha_salida DATETIME NOT NULL,
    fecha_llegada DATETIME NOT NULL,
    estado VARCHAR(50) DEFAULT 'programado',
    FOREIGN KEY (id_avion) REFERENCES aviones(id_avion),
    FOREIGN KEY (id_origen) REFERENCES aeropuertos(id_aeropuerto),
    FOREIGN KEY (id_destino) REFERENCES aeropuertos(id_aeropuerto)
);
GO

CREATE TABLE pasajeros (
    id_pasajero INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    documento VARCHAR(20) UNIQUE NOT NULL,
    email VARCHAR(150),
    nacionalidad VARCHAR(100)
);
GO

CREATE TABLE reservas (
    id_reserva INT IDENTITY(1,1) PRIMARY KEY,
    id_pasajero INT NOT NULL,
    id_vuelo INT NOT NULL,
    fecha_reserva DATETIME DEFAULT GETDATE(),
    asiento VARCHAR(10),
    clase VARCHAR(20) DEFAULT 'economica',
    estado VARCHAR(50) DEFAULT 'confirmada',
    FOREIGN KEY (id_pasajero) REFERENCES pasajeros(id_pasajero),
    FOREIGN KEY (id_vuelo) REFERENCES vuelos(id_vuelo)
);
GO

-- ============================================================
-- INSERCIONES
-- ============================================================

-- Aeropuertos (5 registros)
INSERT INTO aeropuertos (nombre, ciudad, pais, codigo_iata) VALUES
('El Dorado Internacional', 'Bogotá', 'Colombia', 'BOG'),
('José María Córdova', 'Medellín', 'Colombia', 'MDE'),
('Alfonso Bonilla Aragón', 'Cali', 'Colombia', 'CLO'),
('Gustavo Rojas Pinilla', 'San Andrés', 'Colombia', 'ADZ'),
('Benito Juárez Internacional', 'Ciudad de México', 'México', 'MEX');
GO

-- Aviones (5 registros)
INSERT INTO aviones (modelo, capacidad, aerolinea) VALUES
('Boeing 737', 180, 'Avianca'),
('Airbus A320', 165, 'LATAM'),
('Boeing 787', 250, 'Avianca'),
('Airbus A319', 140, 'Wingo'),
('Embraer E190', 100, 'EasyFly');
GO

-- Vuelos (5 registros)
INSERT INTO vuelos (codigo_vuelo, id_avion, id_origen, id_destino, fecha_salida, fecha_llegada, estado) VALUES
('AV101', 1, 1, 2, '2026-04-15 06:00:00', '2026-04-15 07:05:00', 'programado'),
('LA202', 2, 2, 3, '2026-04-15 09:30:00', '2026-04-15 10:35:00', 'programado'),
('AV303', 3, 1, 5, '2026-04-16 11:00:00', '2026-04-16 14:30:00', 'programado'),
('WG404', 4, 3, 4, '2026-04-17 07:00:00', '2026-04-17 08:10:00', 'cancelado'),
('EF505', 5, 1, 3, '2026-04-18 15:00:00', '2026-04-18 16:00:00', 'programado');
GO

-- Pasajeros (5 registros)
INSERT INTO pasajeros (nombre, apellido, documento, email, nacionalidad) VALUES
('Carlos', 'Ramírez', '1020304050', 'carlos.ramirez@email.com', 'Colombiana'),
('Laura', 'Gómez', '2030405060', 'laura.gomez@email.com', 'Colombiana'),
('Andrés', 'Torres', '3040506070', 'andres.torres@email.com', 'Colombiana'),
('Valentina', 'Ríos', '4050607080', 'valentina.rios@email.com', 'Colombiana'),
('Sebastián', 'Mora', '5060708090', 'sebastian.mora@email.com', 'Colombiana');
GO

-- Reservas (5 registros)
INSERT INTO reservas (id_pasajero, id_vuelo, asiento, clase) VALUES
(1, 1, '12A', 'economica'),
(2, 1, '12B', 'economica'),
(3, 2, '5C', 'business'),
(4, 3, '20D', 'economica'),
(5, 5, '8A', 'economica');
GO

-- ============================================================
-- ACTUALIZACIONES
-- ============================================================

-- Aeropuertos
UPDATE aeropuertos SET ciudad = 'Bogotá D.C.' WHERE id_aeropuerto = 1;
UPDATE aeropuertos SET pais = 'México' WHERE codigo_iata = 'MEX';

-- Aviones
UPDATE aviones SET capacidad = 190 WHERE id_avion = 1;
UPDATE aviones SET activo = 0 WHERE id_avion = 4;

-- Vuelos
UPDATE vuelos SET estado = 'en curso' WHERE codigo_vuelo = 'AV101';
UPDATE vuelos SET fecha_salida = '2026-04-16 12:00:00' WHERE codigo_vuelo = 'AV303';

-- Pasajeros
UPDATE pasajeros SET email = 'carlos.ramirez2025@email.com' WHERE id_pasajero = 1;
UPDATE pasajeros SET nacionalidad = 'Mexicana' WHERE id_pasajero = 5;

-- Reservas
UPDATE reservas SET estado = 'cancelada' WHERE id_reserva = 4;
UPDATE reservas SET clase = 'business' WHERE id_reserva = 1;
GO

-- ============================================================
-- ELIMINACIONES (orden correcto: hijos primero)
-- ============================================================

-- Reservas primero (depende de vuelos y pasajeros)
DELETE FROM reservas WHERE estado = 'cancelada';
DELETE FROM reservas WHERE id_reserva = 4;

-- Vuelos (depende de aeropuertos y aviones)
DELETE FROM vuelos WHERE estado = 'cancelado';
DELETE FROM vuelos WHERE codigo_vuelo = 'WG404';

-- Pasajeros
DELETE FROM pasajeros WHERE id_pasajero = 5;
DELETE FROM pasajeros WHERE documento = '5060708090';

-- Aviones
DELETE FROM aviones WHERE activo = 0;
DELETE FROM aviones WHERE id_avion = 4;

-- Aeropuertos (al final, ya no los referencia nadie)
DELETE FROM aeropuertos WHERE codigo_iata = 'MEX';
DELETE FROM aeropuertos WHERE ciudad = 'San Andrés';
GO

-- ============================================================
-- CONSULTAS SELECT CON WHERE
-- ============================================================

-- Aeropuertos
SELECT * FROM aeropuertos WHERE pais = 'Colombia';
SELECT nombre, ciudad FROM aeropuertos WHERE id_aeropuerto > 2;

-- Aviones
SELECT modelo, aerolinea FROM aviones WHERE capacidad > 150;
SELECT * FROM aviones WHERE activo = 1;

-- Vuelos
SELECT * FROM vuelos WHERE estado = 'programado';
SELECT codigo_vuelo, fecha_salida FROM vuelos WHERE id_origen = 1;

-- Pasajeros
SELECT nombre, apellido, documento FROM pasajeros WHERE nacionalidad = 'Colombiana';
SELECT * FROM pasajeros WHERE id_pasajero <= 3;

-- Reservas
SELECT * FROM reservas WHERE clase = 'business';
SELECT id_reserva, asiento, estado FROM reservas WHERE estado = 'confirmada';
GO

-- ============================================================
-- INNER JOIN
-- ============================================================

-- JOIN 1: Reservas con datos del pasajero y vuelo
SELECT 
    r.id_reserva,
    p.nombre AS pasajero,
    p.apellido,
    v.codigo_vuelo,
    r.asiento,
    r.clase,
    r.estado
FROM reservas r
INNER JOIN pasajeros p ON r.id_pasajero = p.id_pasajero
INNER JOIN vuelos v ON r.id_vuelo = v.id_vuelo
WHERE r.estado = 'confirmada';

-- JOIN 2: Vuelos con aeropuerto origen, destino y avión
SELECT 
    v.codigo_vuelo,
    a.modelo AS avion,
    a.aerolinea,
    orig.nombre AS origen,
    dest.nombre AS destino,
    v.fecha_salida,
    v.estado
FROM vuelos v
INNER JOIN aviones a ON v.id_avion = a.id_avion
INNER JOIN aeropuertos orig ON v.id_origen = orig.id_aeropuerto
INNER JOIN aeropuertos dest ON v.id_destino = dest.id_aeropuerto;
GO
