-- IndicesVistasOK

SELECT idVideojuego, nombre, tipoVideojuego
  FROM Videojuegos
 WHERE tipoVideojuego = 'MOBA';

SELECT idPartida, torneo, resultado, puntaje, fecha
  FROM Partidas
 WHERE fecha BETWEEN '2026-10-01' AND '2026-10-31'
 ORDER BY fecha;

SELECT id_participante, correo, edad, equipo
  FROM Jugador
 WHERE correo = 'ana.torres@example.com';

SELECT *
  FROM VParticipantesDetalle
 ORDER BY id_participante;

SELECT id_participante, nombre_participante, correo, edad
  FROM VParticipantesDetalle
 WHERE equipo = 1;

SELECT id_participante, nombre_participante, correo
  FROM VParticipantesDetalle
 WHERE equipo IS NULL;

SET enable_seqscan = off;
EXPLAIN SELECT * FROM Videojuegos WHERE tipoVideojuego = 'MOBA';
EXPLAIN SELECT * FROM Partidas WHERE fecha BETWEEN '2026-10-01' AND '2026-10-31';
EXPLAIN SELECT * FROM Jugador WHERE correo = 'ana.torres@example.com';
RESET enable_seqscan;
