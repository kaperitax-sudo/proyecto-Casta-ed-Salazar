-- TuplasNoOK: intentos de ingreso incorrectos protegidos por las restricciones de tupla

-- Torneo individual con 1 solo participante
INSERT INTO Torneos VALUES (103, 1, '2099-03-01', 'Individual', 1);

-- Torneo por equipos con menos de 4 participantes
INSERT INTO Torneos VALUES (104, 3, '2099-03-01', 'PorEquipos', 1);

-- Torneo mixto con menos de 4 participantes
INSERT INTO Torneos VALUES (105, 2, '2099-03-01', 'Mixto', 1);

-- Derrota con puntaje distinto de 0
INSERT INTO Partidas VALUES (104, 'Derrota', 5, '2099-01-12', 101);

-- Victoria con puntaje 0
INSERT INTO Partidas VALUES (105, 'Victoria', 0, '2099-01-12', 101);

-- Empate con puntaje 0
INSERT INTO Partidas VALUES (106, 'Empate', 0, '2099-01-12', 101);

-- Jugador que es su propio equipo (el participante 101 es un Equipo)
INSERT INTO Jugador VALUES (101, 'alfa@example.com', 25, 101);
