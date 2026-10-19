-- DisparadoresOK: ingreso de datos usando la automatización de los disparadores

INSERT INTO Torneos VALUES (201, 4, '2099-06-01', 'Individual', 1);

-- Inscripción sin fecha: el disparador pone la fecha actual
INSERT INTO Inscripciones VALUES (201, NULL, 201);
SELECT id_inscripcion, fecha = CURRENT_DATE AS fecha_automatica
  FROM Inscripciones WHERE id_inscripcion = 201;   -- true

INSERT INTO Inscripciones VALUES (202, '2099-05-01', 201);
INSERT INTO Inscripciones VALUES (203, '2099-05-01', 201);
INSERT INTO Inscripciones VALUES (204, '2099-05-02', 201);   -- completa los 4 cupos

-- Partida sin id: el disparador lo genera
INSERT INTO Partidas (idPartida, resultado, puntaje, fecha, torneo)
VALUES (NULL, 'Victoria', 20, '2099-06-02', 201);
SELECT idPartida, torneo FROM Partidas WHERE torneo = 201;

-- Partida con fecha válida y equipo con cupo disponible
INSERT INTO Partidas VALUES (211, 'Empate', 2, '2099-06-03', 201);

INSERT INTO Participantes VALUES (201, 'Equipo Delta',  202, NULL);
INSERT INTO Participantes VALUES (202, 'Jugador Eps',   203, NULL);
INSERT INTO Participantes VALUES (203, 'Jugador Zeta',  204, NULL);
INSERT INTO Equipo VALUES (201, 1);                           -- equipo de 1 integrante
INSERT INTO Jugador VALUES (202, 'eps@example.com', 23, 201); -- ocupa el único cupo
