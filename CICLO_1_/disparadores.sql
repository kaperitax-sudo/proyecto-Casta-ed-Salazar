-- Disparadores: definición de disparadores 

-- Partidas: genera el id si llega NULL
CREATE OR REPLACE FUNCTION fn_partidas_id() RETURNS TRIGGER AS $$
BEGIN
    IF NEW.idPartida IS NULL THEN
        SELECT COALESCE(MAX(idPartida), 0) + 1 INTO NEW.idPartida FROM Partidas;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_partidas_01_id
    BEFORE INSERT ON Partidas
    FOR EACH ROW EXECUTE FUNCTION fn_partidas_id();

-- Partidas: la fecha no puede ser anterior al inicio del torneo
CREATE OR REPLACE FUNCTION fn_partidas_fecha() RETURNS TRIGGER AS $$
DECLARE
    v_inicio DATE;
BEGIN
    SELECT fecha_inicio INTO v_inicio FROM Torneos WHERE idTorneo = NEW.torneo;
    IF NEW.fecha < v_inicio THEN
        RAISE EXCEPTION 'La partida % (%) no puede ser anterior al inicio del torneo % (%)',
            NEW.idPartida, NEW.fecha, NEW.torneo, v_inicio;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_partidas_02_fecha
    BEFORE INSERT OR UPDATE OF fecha, torneo ON Partidas
    FOR EACH ROW EXECUTE FUNCTION fn_partidas_fecha();

-- Inscripciones: si no llega fecha, usa la fecha actual
CREATE OR REPLACE FUNCTION fn_inscripciones_fecha_auto() RETURNS TRIGGER AS $$
BEGIN
    IF NEW.fecha IS NULL THEN
        NEW.fecha := CURRENT_DATE;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_inscripciones_01_fecha_auto
    BEFORE INSERT ON Inscripciones
    FOR EACH ROW EXECUTE FUNCTION fn_inscripciones_fecha_auto();

-- Inscripciones: no se puede inscribir después del inicio del torneo
CREATE OR REPLACE FUNCTION fn_inscripciones_fecha() RETURNS TRIGGER AS $$
DECLARE
    v_inicio DATE;
BEGIN
    SELECT fecha_inicio INTO v_inicio FROM Torneos WHERE idTorneo = NEW.torneo;
    IF NEW.fecha > v_inicio THEN
        RAISE EXCEPTION 'La inscripción % (%) es posterior al inicio del torneo % (%)',
            NEW.id_inscripcion, NEW.fecha, NEW.torneo, v_inicio;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_inscripciones_02_fecha
    BEFORE INSERT OR UPDATE OF fecha, torneo ON Inscripciones
    FOR EACH ROW EXECUTE FUNCTION fn_inscripciones_fecha();

-- Inscripciones: no se superan los cupos del torneo
CREATE OR REPLACE FUNCTION fn_inscripciones_cupo() RETURNS TRIGGER AS $$
DECLARE
    v_cupo   INTEGER;
    v_actual INTEGER;
BEGIN
    SELECT participantes INTO v_cupo FROM Torneos WHERE idTorneo = NEW.torneo;
    SELECT COUNT(*) INTO v_actual FROM Inscripciones WHERE torneo = NEW.torneo;
    IF v_actual >= v_cupo THEN
        RAISE EXCEPTION 'El torneo % ya completó sus % cupos', NEW.torneo, v_cupo;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_inscripciones_03_cupo
    BEFORE INSERT ON Inscripciones
    FOR EACH ROW EXECUTE FUNCTION fn_inscripciones_cupo();

-- Jugador: un equipo no puede superar su número de integrantes
CREATE OR REPLACE FUNCTION fn_jugador_cupo_equipo() RETURNS TRIGGER AS $$
DECLARE
    v_max    SMALLINT;
    v_actual INTEGER;
BEGIN
    IF NEW.equipo IS NOT NULL THEN
        SELECT no_integrantes INTO v_max FROM Equipo WHERE id_participante = NEW.equipo;
        SELECT COUNT(*) INTO v_actual FROM Jugador
         WHERE equipo = NEW.equipo AND id_participante <> NEW.id_participante;
        IF v_max IS NOT NULL AND v_actual >= v_max THEN
            RAISE EXCEPTION 'El equipo % ya tiene sus % integrantes', NEW.equipo, v_max;
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_jugador_cupo_equipo
    BEFORE INSERT OR UPDATE OF equipo ON Jugador
    FOR EACH ROW EXECUTE FUNCTION fn_jugador_cupo_equipo();
