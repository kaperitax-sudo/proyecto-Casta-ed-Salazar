-- XPoblar: eliminación de datos

-- Elimina un jugador, y por CASCADE en la PK compartida también se borra su fila en Jugador y sus filas en PartidasHechas
DELETE FROM Participantes WHERE id_participante = 3;

-- Elimina una clasificación. Por ON DELETE SET NULL, Participantes(4) queda con clasificacion = NULL en vez de fallar
DELETE FROM Clasificacion WHERE idClasificacion = 3;

-- Elimina un equipo; por ON DELETE SET NULL, Jugador.equipo de sus jugadores restantes queda en NULL
DELETE FROM Equipo WHERE id_participante = 1;

-- Debe fallar (ON DELETE RESTRICT): el videojuego 1 todavía tiene un torneo asociado
DELETE FROM Videojuegos WHERE idVideojuego = 1;

-- Primero se eliminan los participantes inscritos en el torneo 2 (4 y 5), porque Participantes.inscripcion es ON DELETE RESTRICT
DELETE FROM Participantes
 WHERE inscripcion IN (SELECT id_inscripcion FROM Inscripciones WHERE torneo = 2);

-- Elimina un torneo completo; por CASCADE se propaga a Premios, Partidas, Inscripciones y Clasificacion de ese torneo
DELETE FROM Torneos WHERE idTorneo = 2;
