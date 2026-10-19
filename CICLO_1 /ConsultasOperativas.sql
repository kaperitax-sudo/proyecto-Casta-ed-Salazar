-- Consultas operativas (usuario)

-- Consultar los torneos disponibles
SELECT t.idTorneo, v.nombre AS videojuego, t.tipo_torneo, t.fecha_inicio,
       t.participantes AS cupo_maximo,
       COUNT(i.id_inscripcion) AS inscritos,
       t.participantes - COUNT(i.id_inscripcion) AS cupos_disponibles
FROM Torneos t
JOIN Videojuegos v ON v.idVideojuego = t.videojuego
LEFT JOIN Inscripciones i ON i.torneo = t.idTorneo
WHERE t.fecha_inicio > CURRENT_DATE
GROUP BY t.idTorneo, v.nombre, t.tipo_torneo, t.fecha_inicio, t.participantes
HAVING COUNT(i.id_inscripcion) < t.participantes
ORDER BY t.fecha_inicio;

-- Consultar los videojuegos con mayor cantidad de torneos
SELECT v.idVideojuego, v.nombre, v.tipoVideojuego,
       COUNT(t.idTorneo) AS cantidad_torneos
FROM Videojuegos v
LEFT JOIN Torneos t ON t.videojuego = v.idVideojuego
GROUP BY v.idVideojuego, v.nombre, v.tipoVideojuego
ORDER BY cantidad_torneos DESC, v.nombre;

-- Consultar los participantes con mejor desempeño en un torneo
SELECT p.id_participante, p.nombre,
       SUM(pa.puntaje) AS puntaje_total,
       COUNT(*) FILTER (WHERE pa.resultado = 'Victoria') AS victorias,
       RANK() OVER (ORDER BY SUM(pa.puntaje) DESC) AS posicion
FROM Partidas pa
JOIN PartidasHechas ph ON ph.partida = pa.idPartida
JOIN Participantes p ON p.id_participante = ph.participante
WHERE pa.torneo = 1   -- idTorneo a consultar
GROUP BY p.id_participante, p.nombre
ORDER BY posicion
LIMIT 10;

-- Consultar los premios obtenidos por los participantes
SELECT p.id_participante, p.nombre AS participante,
       pr.idPremio, pr.tipoPremio,
       t.idTorneo, v.nombre AS videojuego
FROM Premios pr
JOIN Participantes p ON p.id_participante = pr.idParticipante
JOIN Torneos t ON t.idTorneo = pr.idTorneo
JOIN Videojuegos v ON v.idVideojuego = t.videojuego
ORDER BY p.nombre, t.idTorneo;

-- Consultar los resultados de las partidas de un torneo
SELECT pa.idPartida, pa.fecha, p.id_participante, p.nombre AS participante,
       pa.resultado, pa.puntaje
FROM Partidas pa
JOIN PartidasHechas ph ON ph.partida = pa.idPartida
JOIN Participantes p ON p.id_participante = ph.participante
WHERE pa.torneo = 1   -- idTorneo a consultar
ORDER BY pa.fecha, pa.idPartida;

-- Consultar los torneos en los que participa un jugador
-- (inscrito directamente o a través de su equipo)
SELECT t.idTorneo, v.nombre AS videojuego, t.tipo_torneo, t.fecha_inicio,
       'Individual' AS modalidad
FROM Jugador j
JOIN Participantes p ON p.id_participante = j.id_participante
JOIN Inscripciones i ON i.id_inscripcion = p.inscripcion
JOIN Torneos t ON t.idTorneo = i.torneo
JOIN Videojuegos v ON v.idVideojuego = t.videojuego
WHERE j.id_participante = 2   -- id del jugador a consultar
UNION
SELECT t.idTorneo, v.nombre, t.tipo_torneo, t.fecha_inicio,
       'Equipo: ' || pe.nombre
FROM Jugador j
JOIN Participantes pe ON pe.id_participante = j.equipo
JOIN Inscripciones i ON i.id_inscripcion = pe.inscripcion
JOIN Torneos t ON t.idTorneo = i.torneo
JOIN Videojuegos v ON v.idVideojuego = t.videojuego
WHERE j.id_participante = 2   -- id del jugador a consultar
ORDER BY fecha_inicio;

-- Consultar la clasificación de un torneo
SELECT RANK() OVER (ORDER BY COALESCE(SUM(pa.puntaje), 0) DESC) AS posicion,
       p.id_participante, p.nombre,
       COUNT(pa.idPartida) AS partidas_jugadas,
       COUNT(*) FILTER (WHERE pa.resultado = 'Victoria') AS victorias,
       COUNT(*) FILTER (WHERE pa.resultado = 'Empate') AS empates,
       COUNT(*) FILTER (WHERE pa.resultado = 'Derrota') AS derrotas,
       COALESCE(SUM(pa.puntaje), 0) AS puntaje_total
FROM Clasificacion c
JOIN Participantes p ON p.clasificacion = c.idClasificacion
LEFT JOIN PartidasHechas ph ON ph.participante = p.id_participante
LEFT JOIN Partidas pa ON pa.idPartida = ph.partida AND pa.torneo = c.torneo
WHERE c.torneo = 1   -- idTorneo a consultar
GROUP BY p.id_participante, p.nombre
ORDER BY posicion, p.nombre;
