-- Package

-- PC_TORNEO
CREATE SCHEMA IF NOT EXISTS PC_TORNEO;

CREATE OR REPLACE PROCEDURE PC_TORNEO.AD_TORNEO(
    xIDTORNEO      Tid_,
    xPARTICIPANTES INTEGER,
    xFECHA_INICIO  DATE,
    xTIPO_TORNEO   Ttorneo,
    xVIDEOJUEGO    Tid_
) LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO Torneos (idTorneo, participantes, fecha_inicio, tipo_torneo, videojuego)
    VALUES (xIDTORNEO, xPARTICIPANTES, xFECHA_INICIO, xTIPO_TORNEO, xVIDEOJUEGO);
EXCEPTION
    WHEN unique_violation THEN
        RAISE EXCEPTION 'Ya existe el torneo %', xIDTORNEO;
    WHEN foreign_key_violation THEN
        RAISE EXCEPTION 'El videojuego % no existe', xVIDEOJUEGO;
END;
$$;

CREATE OR REPLACE PROCEDURE PC_TORNEO.MOD_TORNEO(
    xIDTORNEO      Tid_,
    xPARTICIPANTES INTEGER,
    xFECHA_INICIO  DATE,
    xTIPO_TORNEO   Ttorneo,
    xVIDEOJUEGO    Tid_
) LANGUAGE plpgsql AS $$
BEGIN
    UPDATE Torneos
       SET participantes = xPARTICIPANTES,
           fecha_inicio  = xFECHA_INICIO,
           tipo_torneo   = xTIPO_TORNEO,
           videojuego    = xVIDEOJUEGO
     WHERE idTorneo = xIDTORNEO;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'No existe el torneo %', xIDTORNEO;
    END IF;
EXCEPTION
    WHEN foreign_key_violation THEN
        RAISE EXCEPTION 'El videojuego % no existe', xVIDEOJUEGO;
END;
$$;

CREATE OR REPLACE PROCEDURE PC_TORNEO.ELI_TORNEO(xIDTORNEO Tid_)
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM Torneos WHERE idTorneo = xIDTORNEO;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'No existe el torneo %', xIDTORNEO;
    END IF;
EXCEPTION
    WHEN foreign_key_violation THEN
        RAISE EXCEPTION 'No se puede eliminar el torneo %: tiene participantes inscritos', xIDTORNEO;
END;
$$;

CREATE OR REPLACE FUNCTION PC_TORNEO.CO_TORNEO() RETURNS REFCURSOR
LANGUAGE plpgsql AS $$
DECLARE
    c REFCURSOR := 'co_torneo';
BEGIN
    OPEN c FOR
        SELECT t.idTorneo, t.participantes, t.fecha_inicio, t.tipo_torneo,
               t.videojuego, v.nombre AS nombre_videojuego
          FROM Torneos t
          JOIN Videojuegos v ON v.idVideojuego = t.videojuego
         ORDER BY t.idTorneo;
    RETURN c;
END;
$$;

CREATE OR REPLACE FUNCTION PC_TORNEO.CO_TORNEOS_DISPONIBLES() RETURNS REFCURSOR
LANGUAGE plpgsql AS $$
DECLARE
    c REFCURSOR := 'co_torneos_disponibles';
BEGIN
    OPEN c FOR
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
    RETURN c;
END;
$$;

-- PC_PREMIO
CREATE SCHEMA IF NOT EXISTS PC_PREMIO;

CREATE OR REPLACE PROCEDURE PC_PREMIO.AD_PREMIO(
    xIDPREMIO       Tid_,
    xTIPOPREMIO     Tpremio,
    xIDTORNEO       Tid_,
    xIDPARTICIPANTE Tid_
) LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO Premios (idPremio, tipoPremio, idTorneo, idParticipante)
    VALUES (xIDPREMIO, xTIPOPREMIO, xIDTORNEO, xIDPARTICIPANTE);
EXCEPTION
    WHEN unique_violation THEN
        RAISE EXCEPTION 'Ya existe el premio %', xIDPREMIO;
    WHEN foreign_key_violation THEN
        RAISE EXCEPTION 'El torneo % o el participante % no existe', xIDTORNEO, xIDPARTICIPANTE;
END;
$$;

CREATE OR REPLACE PROCEDURE PC_PREMIO.MOD_PREMIO(
    xIDPREMIO       Tid_,
    xTIPOPREMIO     Tpremio,
    xIDTORNEO       Tid_,
    xIDPARTICIPANTE Tid_
) LANGUAGE plpgsql AS $$
BEGIN
    UPDATE Premios
       SET tipoPremio     = xTIPOPREMIO,
           idTorneo       = xIDTORNEO,
           idParticipante = xIDPARTICIPANTE
     WHERE idPremio = xIDPREMIO;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'No existe el premio %', xIDPREMIO;
    END IF;
EXCEPTION
    WHEN foreign_key_violation THEN
        RAISE EXCEPTION 'El torneo % o el participante % no existe', xIDTORNEO, xIDPARTICIPANTE;
END;
$$;

CREATE OR REPLACE PROCEDURE PC_PREMIO.ELI_PREMIO(xIDPREMIO Tid_)
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM Premios WHERE idPremio = xIDPREMIO;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'No existe el premio %', xIDPREMIO;
    END IF;
END;
$$;

CREATE OR REPLACE FUNCTION PC_PREMIO.CO_PREMIO() RETURNS REFCURSOR
LANGUAGE plpgsql AS $$
DECLARE
    c REFCURSOR := 'co_premio';
BEGIN
    OPEN c FOR
        SELECT idPremio, tipoPremio, idTorneo, idParticipante
          FROM Premios
         ORDER BY idPremio;
    RETURN c;
END;
$$;

CREATE OR REPLACE FUNCTION PC_PREMIO.CO_PREMIOS_PARTICIPANTES() RETURNS REFCURSOR
LANGUAGE plpgsql AS $$
DECLARE
    c REFCURSOR := 'co_premios_participantes';
BEGIN
    OPEN c FOR
        SELECT p.id_participante, p.nombre AS participante,
               pr.idPremio, pr.tipoPremio,
               t.idTorneo, v.nombre AS videojuego
          FROM Premios pr
          JOIN Participantes p ON p.id_participante = pr.idParticipante
          JOIN Torneos t       ON t.idTorneo = pr.idTorneo
          JOIN Videojuegos v   ON v.idVideojuego = t.videojuego
         ORDER BY p.nombre, t.idTorneo;
    RETURN c;
END;
$$;

-- PC_CLASIFICACION
CREATE SCHEMA IF NOT EXISTS PC_CLASIFICACION;

CREATE OR REPLACE PROCEDURE PC_CLASIFICACION.AD_CLASIFICACION(
    xIDCLASIFICACION Tid_,
    xTORNEO          Tid_
) LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO Clasificacion (idClasificacion, torneo)
    VALUES (xIDCLASIFICACION, xTORNEO);
EXCEPTION
    WHEN unique_violation THEN
        RAISE EXCEPTION 'Ya existe la clasificación %', xIDCLASIFICACION;
    WHEN foreign_key_violation THEN
        RAISE EXCEPTION 'El torneo % no existe', xTORNEO;
END;
$$;

CREATE OR REPLACE PROCEDURE PC_CLASIFICACION.MOD_CLASIFICACION(
    xIDCLASIFICACION Tid_,
    xTORNEO          Tid_
) LANGUAGE plpgsql AS $$
BEGIN
    UPDATE Clasificacion
       SET torneo = xTORNEO
     WHERE idClasificacion = xIDCLASIFICACION;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'No existe la clasificación %', xIDCLASIFICACION;
    END IF;
EXCEPTION
    WHEN foreign_key_violation THEN
        RAISE EXCEPTION 'El torneo % no existe', xTORNEO;
END;
$$;

CREATE OR REPLACE PROCEDURE PC_CLASIFICACION.ELI_CLASIFICACION(xIDCLASIFICACION Tid_)
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM Clasificacion WHERE idClasificacion = xIDCLASIFICACION;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'No existe la clasificación %', xIDCLASIFICACION;
    END IF;
END;
$$;

CREATE OR REPLACE FUNCTION PC_CLASIFICACION.CO_CLASIFICACION() RETURNS REFCURSOR
LANGUAGE plpgsql AS $$
DECLARE
    c REFCURSOR := 'co_clasificacion';
BEGIN
    OPEN c FOR
        SELECT c2.idClasificacion, c2.torneo,
               p.id_participante, p.nombre AS participante
          FROM Clasificacion c2
          LEFT JOIN Participantes p ON p.clasificacion = c2.idClasificacion
         ORDER BY c2.torneo, c2.idClasificacion;
    RETURN c;
END;
$$;

CREATE OR REPLACE FUNCTION PC_CLASIFICACION.CO_CLASIFICACION_TORNEO(xIDTORNEO Tid_) RETURNS REFCURSOR
LANGUAGE plpgsql AS $$
DECLARE
    c REFCURSOR := 'co_clasificacion_torneo';
BEGIN
    OPEN c FOR
        SELECT RANK() OVER (ORDER BY COALESCE(SUM(pa.puntaje), 0) DESC) AS posicion,
               p.id_participante, p.nombre,
               COUNT(pa.idPartida) AS partidas_jugadas,
               COUNT(*) FILTER (WHERE pa.resultado = 'Victoria') AS victorias,
               COUNT(*) FILTER (WHERE pa.resultado = 'Empate')   AS empates,
               COUNT(*) FILTER (WHERE pa.resultado = 'Derrota')  AS derrotas,
               COALESCE(SUM(pa.puntaje), 0) AS puntaje_total
          FROM Clasificacion cl
          JOIN Participantes p        ON p.clasificacion = cl.idClasificacion
          LEFT JOIN PartidasHechas ph ON ph.participante = p.id_participante
          LEFT JOIN Partidas pa       ON pa.idPartida = ph.partida AND pa.torneo = cl.torneo
         WHERE cl.torneo = xIDTORNEO
         GROUP BY p.id_participante, p.nombre
         ORDER BY posicion, p.nombre;
    RETURN c;
END;
$$;

-- PC_PARTIDA
CREATE SCHEMA IF NOT EXISTS PC_PARTIDA;

CREATE OR REPLACE PROCEDURE PC_PARTIDA.AD_PARTIDA(
    xIDPARTIDA Tid_,
    xRESULTADO Tresultado,
    xPUNTAJE   INTEGER,
    xFECHA     DATE,
    xTORNEO    Tid_
) LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO Partidas (idPartida, resultado, puntaje, fecha, torneo)
    VALUES (xIDPARTIDA, xRESULTADO, xPUNTAJE, xFECHA, xTORNEO);
EXCEPTION
    WHEN unique_violation THEN
        RAISE EXCEPTION 'Ya existe la partida %', xIDPARTIDA;
    WHEN foreign_key_violation THEN
        RAISE EXCEPTION 'El torneo % no existe', xTORNEO;
END;
$$;

CREATE OR REPLACE PROCEDURE PC_PARTIDA.MOD_PARTIDA(
    xIDPARTIDA Tid_,
    xRESULTADO Tresultado,
    xPUNTAJE   INTEGER,
    xFECHA     DATE,
    xTORNEO    Tid_
) LANGUAGE plpgsql AS $$
BEGIN
    UPDATE Partidas
       SET resultado = xRESULTADO,
           puntaje   = xPUNTAJE,
           fecha     = xFECHA,
           torneo    = xTORNEO
     WHERE idPartida = xIDPARTIDA;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'No existe la partida %', xIDPARTIDA;
    END IF;
EXCEPTION
    WHEN foreign_key_violation THEN
        RAISE EXCEPTION 'El torneo % no existe', xTORNEO;
END;
$$;

CREATE OR REPLACE PROCEDURE PC_PARTIDA.ELI_PARTIDA(xIDPARTIDA Tid_)
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM Partidas WHERE idPartida = xIDPARTIDA;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'No existe la partida %', xIDPARTIDA;
    END IF;
END;
$$;

CREATE OR REPLACE FUNCTION PC_PARTIDA.CO_PARTIDA() RETURNS REFCURSOR
LANGUAGE plpgsql AS $$
DECLARE
    c REFCURSOR := 'co_partida';
BEGIN
    OPEN c FOR
        SELECT idPartida, resultado, puntaje, fecha, torneo
          FROM Partidas
         ORDER BY torneo, fecha, idPartida;
    RETURN c;
END;
$$;

CREATE OR REPLACE FUNCTION PC_PARTIDA.CO_RESULTADOS_TORNEO(xIDTORNEO Tid_) RETURNS REFCURSOR
LANGUAGE plpgsql AS $$
DECLARE
    c REFCURSOR := 'co_resultados_torneo';
BEGIN
    OPEN c FOR
        SELECT pa.idPartida, pa.fecha, p.id_participante, p.nombre AS participante,
               pa.resultado, pa.puntaje
          FROM Partidas pa
          JOIN PartidasHechas ph ON ph.partida = pa.idPartida
          JOIN Participantes p   ON p.id_participante = ph.participante
         WHERE pa.torneo = xIDTORNEO
         ORDER BY pa.fecha, pa.idPartida;
    RETURN c;
END;
$$;

-- PC_VIDEOJUEGO
CREATE SCHEMA IF NOT EXISTS PC_VIDEOJUEGO;

CREATE OR REPLACE PROCEDURE PC_VIDEOJUEGO.AD_VIDEOJUEGO(
    xIDVIDEOJUEGO   Tid_,
    xNOMBRE         VARCHAR,
    xTIPOVIDEOJUEGO Tvideojuego
) LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO Videojuegos (idVideojuego, nombre, tipoVideojuego)
    VALUES (xIDVIDEOJUEGO, xNOMBRE, xTIPOVIDEOJUEGO);
EXCEPTION
    WHEN unique_violation THEN
        RAISE EXCEPTION 'Ya existe el videojuego %', xIDVIDEOJUEGO;
END;
$$;

CREATE OR REPLACE PROCEDURE PC_VIDEOJUEGO.MOD_VIDEOJUEGO(
    xIDVIDEOJUEGO   Tid_,
    xNOMBRE         VARCHAR,
    xTIPOVIDEOJUEGO Tvideojuego
) LANGUAGE plpgsql AS $$
BEGIN
    UPDATE Videojuegos
       SET nombre         = xNOMBRE,
           tipoVideojuego = xTIPOVIDEOJUEGO
     WHERE idVideojuego = xIDVIDEOJUEGO;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'No existe el videojuego %', xIDVIDEOJUEGO;
    END IF;
END;
$$;

CREATE OR REPLACE PROCEDURE PC_VIDEOJUEGO.ELI_VIDEOJUEGO(xIDVIDEOJUEGO Tid_)
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM Videojuegos WHERE idVideojuego = xIDVIDEOJUEGO;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'No existe el videojuego %', xIDVIDEOJUEGO;
    END IF;
EXCEPTION
    WHEN foreign_key_violation THEN
        RAISE EXCEPTION 'No se puede eliminar el videojuego %: tiene torneos asociados', xIDVIDEOJUEGO;
END;
$$;

CREATE OR REPLACE FUNCTION PC_VIDEOJUEGO.CO_VIDEOJUEGO() RETURNS REFCURSOR
LANGUAGE plpgsql AS $$
DECLARE
    c REFCURSOR := 'co_videojuego';
BEGIN
    OPEN c FOR
        SELECT idVideojuego, nombre, tipoVideojuego
          FROM Videojuegos
         ORDER BY idVideojuego;
    RETURN c;
END;
$$;

CREATE OR REPLACE FUNCTION PC_VIDEOJUEGO.CO_VIDEOJUEGOS_MAS_TORNEOS() RETURNS REFCURSOR
LANGUAGE plpgsql AS $$
DECLARE
    c REFCURSOR := 'co_videojuegos_mas_torneos';
BEGIN
    OPEN c FOR
        SELECT v.idVideojuego, v.nombre, v.tipoVideojuego,
               COUNT(t.idTorneo) AS cantidad_torneos
          FROM Videojuegos v
          LEFT JOIN Torneos t ON t.videojuego = v.idVideojuego
         GROUP BY v.idVideojuego, v.nombre, v.tipoVideojuego
         ORDER BY cantidad_torneos DESC, v.nombre;
    RETURN c;
END;
$$;

-- PC_PARTICIPANTE
CREATE SCHEMA IF NOT EXISTS PC_PARTICIPANTE;

CREATE OR REPLACE PROCEDURE PC_PARTICIPANTE.AD_JUGADOR(
    xID_PARTICIPANTE Tid_,
    xNOMBRE          VARCHAR,
    xINSCRIPCION     Tid_,
    xCORREO          Tcorreo,
    xEDAD            INTEGER,
    xEQUIPO          Tid_
) LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO Participantes (id_participante, nombre, inscripcion)
    VALUES (xID_PARTICIPANTE, xNOMBRE, xINSCRIPCION);

    INSERT INTO Jugador (id_participante, correo, edad, equipo)
    VALUES (xID_PARTICIPANTE, xCORREO, xEDAD, xEQUIPO);
EXCEPTION
    WHEN unique_violation THEN
        RAISE EXCEPTION 'No se pudo registrar el jugador %: el id, la inscripción % o el correo % ya están en uso',
            xID_PARTICIPANTE, xINSCRIPCION, xCORREO;
    WHEN foreign_key_violation THEN
        RAISE EXCEPTION 'No se pudo registrar el jugador %: la inscripción % o el equipo indicado no existe',
            xID_PARTICIPANTE, xINSCRIPCION;
END;
$$;

CREATE OR REPLACE PROCEDURE PC_PARTICIPANTE.MOD_JUGADOR(
    xID_PARTICIPANTE Tid_,
    xNOMBRE          VARCHAR,
    xINSCRIPCION     Tid_,
    xCORREO          Tcorreo,
    xEDAD            INTEGER,
    xEQUIPO          Tid_
) LANGUAGE plpgsql AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Jugador WHERE id_participante = xID_PARTICIPANTE) THEN
        RAISE EXCEPTION 'No existe el jugador %', xID_PARTICIPANTE;
    END IF;

    UPDATE Participantes
       SET nombre      = xNOMBRE,
           inscripcion = xINSCRIPCION
     WHERE id_participante = xID_PARTICIPANTE;

    UPDATE Jugador
       SET correo = xCORREO,
           edad   = xEDAD,
           equipo = xEQUIPO
     WHERE id_participante = xID_PARTICIPANTE;
EXCEPTION
    WHEN unique_violation THEN
        RAISE EXCEPTION 'No se pudo modificar el jugador %: la inscripción % o el correo % ya están en uso',
            xID_PARTICIPANTE, xINSCRIPCION, xCORREO;
    WHEN foreign_key_violation THEN
        RAISE EXCEPTION 'No se pudo modificar el jugador %: la inscripción % o el equipo indicado no existe',
            xID_PARTICIPANTE, xINSCRIPCION;
END;
$$;

CREATE OR REPLACE PROCEDURE PC_PARTICIPANTE.ELI_JUGADOR(xID_PARTICIPANTE Tid_)
LANGUAGE plpgsql AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Jugador WHERE id_participante = xID_PARTICIPANTE) THEN
        RAISE EXCEPTION 'No existe el jugador %', xID_PARTICIPANTE;
    END IF;
    DELETE FROM Participantes WHERE id_participante = xID_PARTICIPANTE;
END;
$$;

CREATE OR REPLACE FUNCTION PC_PARTICIPANTE.CO_JUGADOR() RETURNS REFCURSOR
LANGUAGE plpgsql AS $$
DECLARE
    c REFCURSOR := 'co_jugador';
BEGIN
    OPEN c FOR
        SELECT p.id_participante, p.nombre, j.correo, j.edad,
               p.inscripcion, j.equipo, pe.nombre AS nombre_equipo
          FROM Jugador j
          JOIN Participantes p       ON p.id_participante = j.id_participante
          LEFT JOIN Participantes pe ON pe.id_participante = j.equipo
         ORDER BY p.id_participante;
    RETURN c;
END;
$$;

CREATE OR REPLACE PROCEDURE PC_PARTICIPANTE.AD_EQUIPO(
    xID_PARTICIPANTE Tid_,
    xNOMBRE          VARCHAR,
    xINSCRIPCION     Tid_,
    xNO_INTEGRANTES  INTEGER
) LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO Participantes (id_participante, nombre, inscripcion)
    VALUES (xID_PARTICIPANTE, xNOMBRE, xINSCRIPCION);

    INSERT INTO Equipo (id_participante, no_integrantes)
    VALUES (xID_PARTICIPANTE, xNO_INTEGRANTES);
EXCEPTION
    WHEN unique_violation THEN
        RAISE EXCEPTION 'No se pudo registrar el equipo %: el id o la inscripción % ya están en uso',
            xID_PARTICIPANTE, xINSCRIPCION;
    WHEN foreign_key_violation THEN
        RAISE EXCEPTION 'No se pudo registrar el equipo %: la inscripción % no existe',
            xID_PARTICIPANTE, xINSCRIPCION;
END;
$$;

CREATE OR REPLACE PROCEDURE PC_PARTICIPANTE.MOD_EQUIPO(
    xID_PARTICIPANTE Tid_,
    xNOMBRE          VARCHAR,
    xINSCRIPCION     Tid_,
    xNO_INTEGRANTES  INTEGER
) LANGUAGE plpgsql AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Equipo WHERE id_participante = xID_PARTICIPANTE) THEN
        RAISE EXCEPTION 'No existe el equipo %', xID_PARTICIPANTE;
    END IF;

    UPDATE Participantes
       SET nombre      = xNOMBRE,
           inscripcion = xINSCRIPCION
     WHERE id_participante = xID_PARTICIPANTE;

    UPDATE Equipo
       SET no_integrantes = xNO_INTEGRANTES
     WHERE id_participante = xID_PARTICIPANTE;
EXCEPTION
    WHEN unique_violation THEN
        RAISE EXCEPTION 'No se pudo modificar el equipo %: la inscripción % ya está en uso',
            xID_PARTICIPANTE, xINSCRIPCION;
    WHEN foreign_key_violation THEN
        RAISE EXCEPTION 'No se pudo modificar el equipo %: la inscripción % no existe',
            xID_PARTICIPANTE, xINSCRIPCION;
END;
$$;

CREATE OR REPLACE PROCEDURE PC_PARTICIPANTE.ELI_EQUIPO(xID_PARTICIPANTE Tid_)
LANGUAGE plpgsql AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Equipo WHERE id_participante = xID_PARTICIPANTE) THEN
        RAISE EXCEPTION 'No existe el equipo %', xID_PARTICIPANTE;
    END IF;
    DELETE FROM Participantes WHERE id_participante = xID_PARTICIPANTE;
END;
$$;

CREATE OR REPLACE FUNCTION PC_PARTICIPANTE.CO_EQUIPO() RETURNS REFCURSOR
LANGUAGE plpgsql AS $$
DECLARE
    c REFCURSOR := 'co_equipo';
BEGIN
    OPEN c FOR
        SELECT p.id_participante, p.nombre, p.inscripcion, e.no_integrantes,
               COUNT(j.id_participante) AS jugadores_actuales
          FROM Equipo e
          JOIN Participantes p ON p.id_participante = e.id_participante
          LEFT JOIN Jugador j  ON j.equipo = e.id_participante
         GROUP BY p.id_participante, p.nombre, p.inscripcion, e.no_integrantes
         ORDER BY p.id_participante;
    RETURN c;
END;
$$;

CREATE OR REPLACE FUNCTION PC_PARTICIPANTE.CO_TORNEOS_JUGADOR(xID_PARTICIPANTE Tid_) RETURNS REFCURSOR
LANGUAGE plpgsql AS $$
DECLARE
    c REFCURSOR := 'co_torneos_jugador';
BEGIN
    OPEN c FOR
        SELECT t.idTorneo, v.nombre AS videojuego, t.tipo_torneo, t.fecha_inicio,
               'Individual' AS modalidad
          FROM Jugador j
          JOIN Participantes p ON p.id_participante = j.id_participante
          JOIN Inscripciones i ON i.id_inscripcion = p.inscripcion
          JOIN Torneos t       ON t.idTorneo = i.torneo
          JOIN Videojuegos v   ON v.idVideojuego = t.videojuego
         WHERE j.id_participante = xID_PARTICIPANTE
        UNION
        SELECT t.idTorneo, v.nombre, t.tipo_torneo, t.fecha_inicio,
               'Equipo: ' || pe.nombre
          FROM Jugador j
          JOIN Participantes pe ON pe.id_participante = j.equipo
          JOIN Inscripciones i  ON i.id_inscripcion = pe.inscripcion
          JOIN Torneos t        ON t.idTorneo = i.torneo
          JOIN Videojuegos v    ON v.idVideojuego = t.videojuego
         WHERE j.id_participante = xID_PARTICIPANTE
         ORDER BY fecha_inicio;
    RETURN c;
END;
$$;

CREATE OR REPLACE FUNCTION PC_PARTICIPANTE.CO_MEJOR_DESEMPENO(xIDTORNEO Tid_) RETURNS REFCURSOR
LANGUAGE plpgsql AS $$
DECLARE
    c REFCURSOR := 'co_mejor_desempeno';
BEGIN
    OPEN c FOR
        SELECT p.id_participante, p.nombre,
               SUM(pa.puntaje) AS puntaje_total,
               COUNT(*) FILTER (WHERE pa.resultado = 'Victoria') AS victorias,
               RANK() OVER (ORDER BY SUM(pa.puntaje) DESC) AS posicion
          FROM Partidas pa
          JOIN PartidasHechas ph ON ph.partida = pa.idPartida
          JOIN Participantes p   ON p.id_participante = ph.participante
         WHERE pa.torneo = xIDTORNEO
         GROUP BY p.id_participante, p.nombre
         ORDER BY posicion
         LIMIT 10;
    RETURN c;
END;
$$;

-- PC_INSCRIPCION
CREATE SCHEMA IF NOT EXISTS PC_INSCRIPCION;

CREATE OR REPLACE PROCEDURE PC_INSCRIPCION.AD_INSCRIPCION(
    xID_INSCRIPCION Tid_,
    xFECHA          DATE,
    xTORNEO         Tid_
) LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO Inscripciones (id_inscripcion, fecha, torneo)
    VALUES (xID_INSCRIPCION, xFECHA, xTORNEO);
EXCEPTION
    WHEN unique_violation THEN
        RAISE EXCEPTION 'Ya existe la inscripción %', xID_INSCRIPCION;
    WHEN foreign_key_violation THEN
        RAISE EXCEPTION 'El torneo % no existe', xTORNEO;
END;
$$;
