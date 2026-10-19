-- XDisparadores: eliminación de disparadores

DROP TRIGGER IF EXISTS trg_partidas_01_id            ON Partidas;
DROP TRIGGER IF EXISTS trg_partidas_02_fecha         ON Partidas;
DROP TRIGGER IF EXISTS trg_inscripciones_01_fecha_auto ON Inscripciones;
DROP TRIGGER IF EXISTS trg_inscripciones_02_fecha    ON Inscripciones;
DROP TRIGGER IF EXISTS trg_inscripciones_03_cupo     ON Inscripciones;
DROP TRIGGER IF EXISTS trg_jugador_cupo_equipo       ON Jugador;

DROP FUNCTION IF EXISTS fn_partidas_id();
DROP FUNCTION IF EXISTS fn_partidas_fecha();
DROP FUNCTION IF EXISTS fn_inscripciones_fecha_auto();
DROP FUNCTION IF EXISTS fn_inscripciones_fecha();
DROP FUNCTION IF EXISTS fn_inscripciones_cupo();
DROP FUNCTION IF EXISTS fn_jugador_cupo_equipo();
