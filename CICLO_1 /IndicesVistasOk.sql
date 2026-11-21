-- IndicesVistasOK: consultas que requieren los índices y las vistas definidos
-- (se ejecuta después de poblarOK.sql)

-- idx_bienes_precio: videojuegos de un tipo
SELECT idVideojuego, nombre, tipoVideojuego
  FROM Videojuegos
 WHERE tipoVideojuego = 'MOBA';

-- idx_partidas_fecha: partidas jugadas en un rango de fechas
SELECT idPartida, torneo, resultado, puntaje, fecha
  FROM Partidas
 WHERE fecha BETWEEN '2026-10-01' AND '2026-10-31'
 ORDER BY fecha;

-- idx_jugador_correo: jugador por su correo
SELECT id_participante, correo, edad, equipo
  FROM Jugador
 WHERE correo = 'ana.torres@example.com';

-- VParticipantesDetalle: todos los jugadores con su información
SELECT *
  FROM VParticipantesDetalle
 ORDER BY id_participante;

-- VParticipantesDetalle: jugadores de un equipo
SELECT id_participante, nombre_participante, correo, edad
  FROM VParticipantesDetalle
 WHERE equipo = 1;

-- VParticipantesDetalle: jugadores sin equipo
SELECT id_participante, nombre_participante, correo
  FROM VParticipantesDetalle
 WHERE equipo IS NULL;

-- Verificación: con pocas filas PostgreSQL prefiere recorrer la tabla completa,
-- por eso se desactiva el recorrido secuencial para ver que se usa cada índice
SET enable_seqscan = off;
EXPLAIN SELECT * FROM Videojuegos WHERE tipoVideojuego = 'MOBA';
EXPLAIN SELECT * FROM Partidas WHERE fecha BETWEEN '2026-10-01' AND '2026-10-31';
EXPLAIN SELECT * FROM Jugador WHERE correo = 'ana.torres@example.com';
RESET enable_seqscan;
