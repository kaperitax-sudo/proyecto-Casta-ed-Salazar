-- TuplasOK: ingreso de datos correctos respecto a las restricciones de tupla

INSERT INTO Torneos VALUES (101, 8,  '2099-01-10', 'Individual', 1);
INSERT INTO Torneos VALUES (102, 16, '2099-02-10', 'PorEquipos', 1);

INSERT INTO Partidas VALUES (101, 'Victoria', 15, '2099-01-11', 101);
INSERT INTO Partidas VALUES (102, 'Derrota',  0,  '2099-01-11', 101);
INSERT INTO Partidas VALUES (103, 'Empate',   3,  '2099-01-12', 101);

INSERT INTO Inscripciones VALUES (101, '2098-12-01', 101);
INSERT INTO Inscripciones VALUES (102, '2098-12-02', 101);
INSERT INTO Inscripciones VALUES (103, '2098-12-03', 101);

INSERT INTO Participantes VALUES (101, 'Equipo Alfa',  101, NULL);
INSERT INTO Participantes VALUES (102, 'Jugador Beta', 102, NULL);
INSERT INTO Participantes VALUES (103, 'Jugador Gamma',103, NULL);
INSERT INTO Equipo VALUES (101, 3);
INSERT INTO Jugador VALUES (102, 'beta@example.com',  20, 101);
INSERT INTO Jugador VALUES (103, 'gamma@example.com', 21, NULL);
