-- PoblarOK: ingreso de datos correctos (sin automatización)

INSERT INTO Videojuegos VALUES (1, 'League of Aeons', 'MOBA');
INSERT INTO Videojuegos VALUES (2, 'Rift Strikers', 'FPS');

INSERT INTO Torneos VALUES (1, 32, '2026-10-01', 'PorEquipos', 1);
INSERT INTO Torneos VALUES (2, 16, '2026-11-05', 'Individual', 2);
INSERT INTO Torneos VALUES (3, 16, '2099-12-01', 'Individual', 2);

INSERT INTO Partidas VALUES (1, 'Victoria', 10, '2026-10-02', 1);
INSERT INTO Partidas VALUES (2, 'Derrota', 0, '2026-10-02', 1);
INSERT INTO Partidas VALUES (3, 'Empate', 5, '2026-11-06', 2);

INSERT INTO Inscripciones VALUES (1, '2026-09-20', 1);
INSERT INTO Inscripciones VALUES (2, '2026-09-21', 1);
INSERT INTO Inscripciones VALUES (3, '2026-09-21', 1);
INSERT INTO Inscripciones VALUES (4, '2026-10-25', 2);
INSERT INTO Inscripciones VALUES (5, '2026-10-26', 2);  

INSERT INTO Clasificacion VALUES (1, 1);
INSERT INTO Clasificacion VALUES (2, 1);
INSERT INTO Clasificacion VALUES (3, 2);

-- Participantes: 1 = equipo "Dragones FC", 2 y 3 = sus jugadores, 4 = jugador individual
INSERT INTO Participantes VALUES (1, 'Dragones FC', 1, 1);
INSERT INTO Participantes VALUES (2, 'Ana Torres', 2, 2);
INSERT INTO Participantes VALUES (3, 'Carlos Ruiz', 3, NULL);
INSERT INTO Participantes VALUES (4, 'Luis Gomez', 4, 3);
-- Participante extra
INSERT INTO Participantes VALUES (5, 'Pedro Gomez', 5, NULL);
INSERT INTO Equipo VALUES (1, 5);

INSERT INTO Jugador VALUES (2, 'ana.torres@example.com', 19, 1);
INSERT INTO Jugador VALUES (3, 'carlos.ruiz@example.com', 22, 1);
INSERT INTO Jugador VALUES (4, 'luis.gomez@example.com', 27, NULL);

-- Premios: van después de Participantes porque idParticipante es FK a Participantes
INSERT INTO Premios VALUES (1, 'Dinero', 1, 1);   -- Dragones FC, torneo 1
INSERT INTO Premios VALUES (2, 'Trofeo', 1, 1);   -- Dragones FC, torneo 1
INSERT INTO Premios VALUES (3, 'Puntos', 2, 4);   -- Luis Gomez, torneo 2

INSERT INTO PartidasHechas VALUES (1, 1);
INSERT INTO PartidasHechas VALUES (1, 2);
INSERT INTO PartidasHechas VALUES (4, 3);
