-- PoblarNoOK: intentos de ingreso erróneos protegidos 

-- Dominio Tvideojuego no admite este valor
INSERT INTO Videojuegos VALUES (3, 'Puzzle Quest', 'Puzzle');

-- Dominio Tid_ exige valor positivo
INSERT INTO Torneos VALUES (-1, 10, '2026-01-01', 'Individual', 1);

-- Nulidad: tipo_torneo es NOT NULL y no se envía
INSERT INTO Torneos (idTorneo, participantes, fecha_inicio, videojuego)
VALUES (6, 10, '2026-01-01', 1);

-- Clave primaria duplicada 
INSERT INTO Videojuegos VALUES (1, 'Duplicado', 'FPS');

-- Clave foránea inválida: idTorneo 999 no existe
INSERT INTO Premios VALUES (10, 'Dinero', 999, 1);

-- Dominio Tedad fuera de rango (10-99)
INSERT INTO Jugador VALUES (5, 'pedro.gomez@example.com', 5, NULL);

-- Dominio Tcorreo con formato inválido
INSERT INTO Jugador VALUES (5, 'correo-invalido', 25, NULL);

-- Clave única duplicada: correo ya usado por Ana Torres
INSERT INTO Jugador VALUES (5, 'ana.torres@example.com', 30, NULL);

-- Clave primaria compuesta duplicada en PartidasHechas
INSERT INTO PartidasHechas VALUES (1, 1);
