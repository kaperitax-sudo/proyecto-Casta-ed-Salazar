-- AccionesOK

INSERT INTO Videojuegos VALUES (90, 'Test Game', 'FPS');
INSERT INTO Torneos VALUES (190, 8, '2099-05-01', 'Individual', 90);
UPDATE Videojuegos SET idVideojuego = 91 WHERE idVideojuego = 90;
SELECT idTorneo, videojuego FROM Torneos WHERE idTorneo = 190;

DELETE FROM Videojuegos WHERE idVideojuego = 91;

INSERT INTO Videojuegos VALUES (92, 'Test Arena', 'MOBA');
INSERT INTO Torneos VALUES (191, 8, '2099-06-01', 'PorEquipos', 92);
INSERT INTO Inscripciones VALUES (191, '2099-05-01', 191);
INSERT INTO Inscripciones VALUES (192, '2099-05-01', 191);
INSERT INTO Inscripciones VALUES (193, '2099-05-01', 191);
INSERT INTO Participantes VALUES (191, 'Equipo Omega',  191, NULL);
INSERT INTO Participantes VALUES (192, 'Jugador Rho',   192, NULL);
INSERT INTO Participantes VALUES (193, 'Jugador Sigma', 193, NULL);
INSERT INTO Equipo VALUES (191, 3);
INSERT INTO Jugador VALUES (192, 'rho@example.com',   20, 191);
INSERT INTO Jugador VALUES (193, 'sigma@example.com', 21, NULL);

INSERT INTO Premios VALUES (190, 'Trofeo', 190, 191);
INSERT INTO Partidas VALUES (190, 'Victoria', 7, '2099-05-02', 190);
INSERT INTO Clasificacion VALUES (190, 190);
DELETE FROM Torneos WHERE idTorneo = 190;
SELECT (SELECT COUNT(*) FROM Premios       WHERE idTorneo = 190) AS premios,
       (SELECT COUNT(*) FROM Partidas      WHERE torneo   = 190) AS partidas,
       (SELECT COUNT(*) FROM Clasificacion WHERE torneo   = 190) AS clasificacion;
DELETE FROM Videojuegos WHERE idVideojuego = 91;

INSERT INTO Clasificacion VALUES (191, 191);
UPDATE Participantes SET clasificacion = 191 WHERE id_participante = 192;
DELETE FROM Clasificacion WHERE idClasificacion = 191;
SELECT id_participante, clasificacion FROM Participantes WHERE id_participante = 192;

INSERT INTO Partidas VALUES (191, 'Victoria', 5, '2099-06-02', 191);
INSERT INTO PartidasHechas VALUES (193, 191);
DELETE FROM Participantes WHERE id_participante = 193;
SELECT (SELECT COUNT(*) FROM Jugador        WHERE id_participante = 193) AS jugador,
       (SELECT COUNT(*) FROM PartidasHechas WHERE participante    = 193) AS partidashechas;

DELETE FROM Equipo WHERE id_participante = 191;
SELECT id_participante, equipo FROM Jugador WHERE id_participante = 192;
