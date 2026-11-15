-- Índices y Vistas: Definición de índices de rendimiento y vistas de consulta

-- ==========================================
-- ÍNDICES
-- ==========================================

-- Índice para búsquedas frecuentes sobre bienes dado un rango de precios
CREATE INDEX idx_bienes_precio ON Videojuegos (tipoVideojuego); -- Ajustado a las tablas actuales de tu dominio

-- Índice para consultas sobre partidas/ventas en fechas específicas
CREATE INDEX idx_partidas_fecha ON Partidas (fecha);

-- Índice alternativo para mejorar búsquedas por correo de jugadores
CREATE INDEX idx_jugador_correo ON Jugador (correo);


-- ==========================================
-- VISTAS
-- ==========================================

-- Vista de solo lectura para consultar información consolidada de jugadores/participantes
CREATE OR REPLACE VIEW VParticipantesDetalle AS
SELECT 
    p.id_participante,
    p.nombre AS nombre_participante,
    j.correo,
    j.edad,
    j.equipo
FROM Participantes p
JOIN Jugador j ON p.id_participante = j.id_participante;