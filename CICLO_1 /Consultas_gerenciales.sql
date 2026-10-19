-- Consultas gerenciales (administrador)

-- Consultar torneos con mayor número de inscritos
SELECT t.idTorneo, v.nombre AS videojuego, t.tipo_torneo, t.fecha_inicio,
       t.participantes AS cupo_maximo,
       COUNT(i.id_inscripcion) AS numero_inscritos
FROM Torneos t
JOIN Videojuegos v ON v.idVideojuego = t.videojuego
LEFT JOIN Inscripciones i ON i.torneo = t.idTorneo
GROUP BY t.idTorneo, v.nombre, t.tipo_torneo, t.fecha_inicio, t.participantes
ORDER BY numero_inscritos DESC;

-- Consultar participantes con mayor número de victorias
SELECT p.id_participante, p.nombre,
       COUNT(*) AS victorias
FROM Participantes p
JOIN PartidasHechas ph ON ph.participante = p.id_participante
JOIN Partidas pa ON pa.idPartida = ph.partida
WHERE pa.resultado = 'Victoria'
GROUP BY p.id_participante, p.nombre
ORDER BY victorias DESC, p.nombre;

-- Consultar participantes con mayor cantidad de premios
SELECT p.id_participante, p.nombre,
       COUNT(pr.idPremio) AS total_premios
FROM Participantes p
JOIN Premios pr ON pr.idParticipante = p.id_participante
GROUP BY p.id_participante, p.nombre
ORDER BY total_premios DESC, p.nombre;

-- Consultar videojuegos con mayor participación
SELECT v.idVideojuego, v.nombre, v.tipoVideojuego,
       COUNT(DISTINCT t.idTorneo) AS torneos,
       COUNT(i.id_inscripcion) AS total_inscripciones
FROM Videojuegos v
LEFT JOIN Torneos t ON t.videojuego = v.idVideojuego
LEFT JOIN Inscripciones i ON i.torneo = t.idTorneo
GROUP BY v.idVideojuego, v.nombre, v.tipoVideojuego
ORDER BY total_inscripciones DESC, v.nombre;
