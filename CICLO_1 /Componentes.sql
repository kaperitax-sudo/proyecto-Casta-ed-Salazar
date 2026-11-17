-- Componentes: Implementación de servicios de negocio 

-- Servicio: Consultar torneos activos o información general
CREATE OR REPLACE FUNCTION sv_torneos_consultar(p_cursor REFCURSOR)
RETURNS REFCURSOR AS $$
BEGIN
    OPEN p_cursor FOR 
        SELECT idTorneo, participantes, fecha_inicio, tipo_torneo, videojuego 
        FROM Torneos;
    RETURN p_cursor;
END;
$$ LANGUAGE plpgsql;

-- Servicio: Adicionar una nueva partida 
CREATE OR REPLACE PROCEDURE sv_partidas_adicionar(
    p_idPartida Tid_,
    p_resultado Tresultado,
    p_puntaje INTEGER,
    p_fecha DATE,
    p_torneo Tid_
)
AS $$
BEGIN
    INSERT INTO Partidas (idPartida, resultado, puntaje, fecha, torneo)
    VALUES (p_idPartida, p_resultado, p_puntaje, p_fecha, p_torneo);
END;
$$ LANGUAGE plpgsql;
