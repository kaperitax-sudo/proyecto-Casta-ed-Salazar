-- AccionesOK: casos que prueban las acciones de referencia

-- ON UPDATE CASCADE: al cambiar el id del videojuego, el torneo lo sigue
INSERT INTO Videojuegos VALUES (90, 'Test Game', 'FPS');
INSERT INTO Torneos VALUES (190, 8, '2099-05-01', 'Individual', 90);
UPDATE Videojuegos SET idVideojuego = 91 WHERE idVideojuego = 90;
SELECT idTorneo, videojuego FROM Torneos WHERE idTorneo = 190;   -- videojuego = 91

-- ON DELETE RESTRICT: debe fallar, el videojuego 91 todavía tiene un torneo
DELETE FROM Videojuegos WHERE idVideojuego = 91;

-- ON DELETE CASCADE (torneo): se borran sus premios, partidas y clasificación
INSERT INTO Premios VALUES (190, 'Trofeo', 190);
INSERT INTO Partidas VALUES (190, 'Victoria', 7, '2099-05-02', 190);
INSERT INTO Clasificacion VALUES (190, 190);
DELETE FROM Torneos WHERE idTorneo = 190;
SELECT (SELECT COUNT(*) FROM Premios       WHERE idTorneo = 190) AS premios,
       (SELECT COUNT(*) FROM Partidas      WHERE torneo   = 190) AS partidas,
       (SELECT COUNT(*) FROM Clasificacion WHERE torneo   = 190) AS clasificacion;   -- 0, 0, 0
-- Con el torneo borrado, el videojuego 91 ya puede eliminarse
DELETE FROM Videojuegos WHERE idVideojuego = 91;

-- ON DELETE SET NULL (clasificación): el participante queda sin clasificación
INSERT INTO Clasificacion VALUES (101, 101);
UPDATE Participantes SET clasificacion = 101 WHERE id_participante = 102;
DELETE FROM Clasificacion WHERE idClasificacion = 101;
SELECT id_participante, clasificacion FROM Participantes WHERE id_participante = 102;   -- NULL

-- ON DELETE CASCADE (participante): se borran su fila de Jugador y sus PartidasHechas
INSERT INTO PartidasHechas VALUES (103, 101);
DELETE FROM Participantes WHERE id_participante = 103;
SELECT (SELECT COUNT(*) FROM Jugador         WHERE id_participante = 103) AS jugador,
       (SELECT COUNT(*) FROM PartidasHechas  WHERE participante    = 103) AS partidashechas;   -- 0, 0

-- ON DELETE SET NULL (equipo): los jugadores del equipo quedan sin equipo
DELETE FROM Equipo WHERE id_participante = 101;
SELECT id_participante, equipo FROM Jugador WHERE id_participante = 102;   -- NULL
