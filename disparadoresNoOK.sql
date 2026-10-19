-- DisparadoresNoOK: intentos de ingreso erróneos protegidos por los disparadores

-- Partida anterior al inicio del torneo
INSERT INTO Partidas VALUES (210, 'Victoria', 5, '2099-05-31', 201);

-- Cambiar una partida existente a una fecha anterior al inicio del torneo
UPDATE Partidas SET fecha = '2099-05-01' WHERE idPartida = 211;

-- Inscripción posterior al inicio del torneo
INSERT INTO Inscripciones VALUES (206, '2099-06-02', 201);

-- Inscripción en un torneo que ya llenó sus cupos
INSERT INTO Inscripciones VALUES (205, '2099-05-02', 201);

-- Un segundo jugador en un equipo de 1 integrante
INSERT INTO Jugador VALUES (203, 'zeta@example.com', 24, 201);
