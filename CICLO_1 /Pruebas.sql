-- Pruebas: Historias complementarias 

-- Historia 1: Registro completo de un torneo con sus respectivos participantes y partidas iniciales
INSERT INTO Videojuegos VALUES (50, 'Cyber Game', 'Estrategia');
INSERT INTO Torneos VALUES (501, 4, '2099-08-01', 'PorEquipos', 50);

-- Historia 2: Consulta gerencial de validación cruzada de puntajes
SELECT t.idTorneo, COUNT(p.idPartida) AS total_partidas, SUM(p.puntaje) AS puntaje_acumulado
FROM Torneos t
LEFT JOIN Partidas p ON t.idTorneo = p.torneo
GROUP BY t.idTorneo;
