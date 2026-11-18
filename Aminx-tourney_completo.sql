--dominios

-- 1. Dominios 
CREATE DOMAIN Tid_ AS INTEGER
    CHECK (VALUE > 0);

-- Resultado de una partida
CREATE DOMAIN Tresultado AS VARCHAR(20)
    CHECK (VALUE IN ('Victoria', 'Derrota', 'Empate'));

-- Tipo de premio que ofrece un torneo
CREATE DOMAIN Tpremio AS VARCHAR(20)
    CHECK (VALUE IN ('Dinero', 'Trofeo', 'Puntos', 'Objeto_fisico'));

-- Tipo o género del videojuego
CREATE DOMAIN Tvideojuego AS VARCHAR(20)
    CHECK (VALUE IN ('FPS', 'MOBA', 'Deportivo', 'Estrategia', 'Lucha', 'BattleRoyale'));

-- Modalidad del torneo
CREATE DOMAIN Ttorneo AS VARCHAR(20)
    CHECK (VALUE IN ('Individual', 'PorEquipos', 'Mixto'));

-- Correo del jugador
CREATE DOMAIN Tcorreo AS VARCHAR(100)
    CHECK (VALUE ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$');

-- Edad del jugador 
CREATE DOMAIN Tedad AS SMALLINT
    CHECK (VALUE BETWEEN 10 AND 99);


--Tablas

CREATE TABLE Videojuegos (
    idVideojuego     Tid_         NOT NULL,
    nombre           VARCHAR(20)  NOT NULL,
    tipoVideojuego   Tvideojuego  NOT NULL
);

CREATE TABLE Torneos (
    idTorneo         Tid_      NOT NULL,
    participantes    INTEGER   NOT NULL,
    fecha_inicio     DATE      NOT NULL,
    tipo_torneo      Ttorneo   NOT NULL,
    videojuego       Tid_      NOT NULL
   
);

CREATE TABLE Premios (
    idPremio     Tid_      NOT NULL,
    tipoPremio   Tpremio  NOT NULL,
    idTorneo     Tid_      NOT NULL,
    idParticipante Tid_    NOT NULL -- agregado
);

CREATE TABLE Partidas (
    idPartida    Tid_          NOT NULL,
    resultado    Tresultado   NOT NULL,
    puntaje      INTEGER      NOT NULL ,
    fecha        DATE         NOT NULL,
    torneo       Tid_          NOT NULL
);

CREATE TABLE Inscripciones (
    id_inscripcion   Tid_    NOT NULL,
    fecha            DATE   NOT NULL,
    torneo           Tid_    NOT NULL
);

CREATE TABLE Clasificacion (
    idClasificacion   Tid_   NOT NULL,
    torneo            Tid_   NOT NULL
);
 
-- Inscripcion y clasificacion son UNIQUE porque cada inscripción/clasificación pertenece a un único participante.

CREATE TABLE Participantes (
    id_participante   Tid_          NOT NULL,
    nombre            VARCHAR(20)  NOT NULL,
    inscripcion       Tid_          NOT NULL,
    clasificacion     Tid_
  
);

CREATE TABLE Equipo (
    id_participante   Tid_       NOT NULL,
    no_integrantes    SMALLINT  NOT NULL
);

-- Un jugador puede no pertenecer a ningún equipo

CREATE TABLE Jugador (
    id_participante   Tid_      NOT NULL,
    correo            Tcorreo  NOT NULL,
    edad              Tedad    NOT NULL,
    equipo            Tid_
);

-- Tabla de asociación Participantes y Partidas
CREATE TABLE PartidasHechas (
    participante   Tid_   NOT NULL,
    partida        Tid_   NOT NULL
    
);


--claves

-- Claves primarias
ALTER TABLE Videojuegos ADD CONSTRAINT PK_Videojuegos PRIMARY KEY (idVideojuego);
ALTER TABLE Torneos ADD CONSTRAINT PK_Torneos PRIMARY KEY (idTorneo);
ALTER TABLE Premios ADD CONSTRAINT PK_Premios PRIMARY KEY (idPremio);
ALTER TABLE Partidas ADD CONSTRAINT PK_Partidas PRIMARY KEY (idPartida);
ALTER TABLE Inscripciones ADD CONSTRAINT PK_Inscripciones PRIMARY KEY(id_inscripcion);
ALTER TABLE Clasificacion ADD CONSTRAINT PK_Clasificacion PRIMARY KEY(idClasificacion);
ALTER TABLE Participantes ADD CONSTRAINT PK_Participantes PRIMARY KEY(id_participante);
ALTER TABLE Equipo ADD CONSTRAINT PK_Equipo PRIMARY KEY(id_participante);
ALTER TABLE Jugador ADD CONSTRAINT PK_jugador PRIMARY KEY (id_participante);
ALTER TABLE PartidasHechas ADD CONSTRAINT PK_partidasHechas PRIMARY KEY(Participante , partida);

-- Claves Unicas

ALTER TABLE Jugador ADD CONSTRAINT UK_correo_jugador UNIQUE(correo);
ALTER TABLE Participantes ADD CONSTRAINT UK_participantes_inscripcion UNIQUE(inscripcion);
ALTER TABLE Participantes ADD CONSTRAINT UK_participantes_clasificados UNIQUE(clasificacion);

-- calves foraneas 

ALTER TABLE Torneos ADD CONSTRAINT FK_torneos_videojuego FOREIGN KEY(videojuego) REFERENCES Videojuegos (idVideojuego) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE Premios ADD CONSTRAINT FK_Premios_Torneo FOREIGN KEY (idTorneo) REFERENCES Torneos (idTorneo)  ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE Partidas ADD CONSTRAINT FK_partidas_torneo FOREIGN KEY (torneo) REFERENCES Torneos (idTorneo)   ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE Inscripciones ADD CONSTRAINT FK_inscripciones_torneo FOREIGN KEY (torneo) REFERENCES Torneos (idTorneo) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE Clasificacion ADD CONSTRAINT FK_Clasificacion_torneo FOREIGN KEY (torneo) REFERENCES Torneos (idTorneo) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE Participantes ADD CONSTRAINT FK_participantes_inscripcion FOREIGN KEY (inscripcion) REFERENCES Inscripciones(id_inscripcion) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE Participantes ADD CONSTRAINT FK_participantes_clasificacion FOREIGN KEY (clasificacion) REFERENCES Clasificacion(idClasificacion) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE Equipo ADD CONSTRAINT FK_equipo_participante FOREIGN KEY (id_participante) REFERENCES Participantes (id_participante) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE Jugador ADD CONSTRAINT FK_jugador_participante FOREIGN KEY (id_participante) REFERENCES Participantes (id_participante) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE Jugador ADD CONSTRAINT FK_jugador_equipo FOREIGN KEY (equipo) REFERENCES Equipo (id_participante) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE PartidasHechas ADD CONSTRAINT FK_ph_participantes FOREIGN KEY (participante) REFERENCES Participantes (id_participante) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE PartidasHechas ADD CONSTRAINT FK_ph_partida FOREIGN KEY (partida) REFERENCES Partidas (idPartida) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE Premios ADD CONSTRAINT FK_Premios_Participante FOREIGN KEY (idParticipante) REFERENCES Participantes (id_participante)  ON DELETE CASCADE ON UPDATE CASCADE; -- Agregado


--restricciones

ALTER TABLE Torneos ADD CONSTRAINT chk_torenosParticipantes CHECK (participantes > 0);
ALTER TABLE Partidas ADD CONSTRAINT chk_partidasPuntajes CHECK (puntaje >= 0);
ALTER TABLE Equipo ADD CONSTRAINT chk_EquipoIntegrantes CHECK ( no_integrantes > 0);


--tuplas

-- Tuplas: definición de las restricciones que implican más de un atributo

-- Un torneo individual necesita al menos 2 participantes. Uno por equipos o mixto, al menos 4
ALTER TABLE Torneos ADD CONSTRAINT ck_torneos_tipo_participantes CHECK (
    (tipo_torneo = 'Individual' AND participantes >= 2)
    OR (tipo_torneo <> 'Individual' AND participantes >= 4)
);

-- Relación entre resultado y puntaje: la derrota no suma puntos, la victoria y el empate sí
ALTER TABLE Partidas ADD CONSTRAINT ck_partidas_resultado_puntaje CHECK (
    (resultado = 'Derrota' AND puntaje = 0)
    OR (resultado <> 'Derrota' AND puntaje > 0)
);

-- Un jugador no puede ser su propio equipo.
ALTER TABLE Jugador ADD CONSTRAINT ck_jugador_equipo_distinto CHECK (
    equipo IS NULL OR equipo <> id_participante
);


--acciones

-- Acciones: definición de las acciones de referencia.

-- Las acciones se definen en las claves foráneas de la sección 2:

--   Torneos.videojuego         -> Videojuegos   ON DELETE RESTRICT  ON UPDATE CASCADE
--   Premios.idTorneo           -> Torneos       ON DELETE CASCADE   ON UPDATE CASCADE
--   Partidas.torneo            -> Torneos       ON DELETE CASCADE   ON UPDATE CASCADE
--   Inscripciones.torneo       -> Torneos       ON DELETE CASCADE   ON UPDATE CASCADE
--   Clasificacion.torneo       -> Torneos       ON DELETE CASCADE   ON UPDATE CASCADE
--   Participantes.inscripcion  -> Inscripciones ON DELETE RESTRICT  ON UPDATE CASCADE
--   Participantes.clasificacion-> Clasificacion ON DELETE SET NULL  ON UPDATE CASCADE
--   Equipo.id_participante     -> Participantes ON DELETE CASCADE   ON UPDATE CASCADE
--   Jugador.id_participante    -> Participantes ON DELETE CASCADE   ON UPDATE CASCADE
--   Jugador.equipo             -> Equipo        ON DELETE SET NULL  ON UPDATE CASCADE
--   PartidasHechas.participante-> Participantes ON DELETE CASCADE   ON UPDATE CASCADE
--   PartidasHechas.partida     -> Partidas      ON DELETE CASCADE   ON UPDATE CASCADE


--poblarOK

-- PoblarOK: ingreso de datos correctos (sin automatización)

INSERT INTO Videojuegos VALUES (1, 'League of Aeons', 'MOBA');
INSERT INTO Videojuegos VALUES (2, 'Rift Strikers', 'FPS');

INSERT INTO Torneos VALUES (1, 32, '2026-10-01', 'PorEquipos', 1);
INSERT INTO Torneos VALUES (2, 16, '2026-11-05', 'Individual', 2);

INSERT INTO Partidas VALUES (1, 'Victoria', 10, '2026-10-02', 1);
INSERT INTO Partidas VALUES (2, 'Derrota', 0, '2026-10-02', 1);
INSERT INTO Partidas VALUES (3, 'Empate', 5, '2026-11-06', 2);

INSERT INTO Inscripciones VALUES (1, '2026-09-20', 1);
INSERT INTO Inscripciones VALUES (2, '2026-09-21', 1);
INSERT INTO Inscripciones VALUES (3, '2026-09-21', 1);
INSERT INTO Inscripciones VALUES (4, '2026-10-25', 2);
INSERT INTO Inscripciones VALUES (5, '2026-10-26', 2);  

INSERT INTO Clasificacion VALUES (1, 1);
INSERT INTO Clasificacion VALUES (2, 1);
INSERT INTO Clasificacion VALUES (3, 2);

-- Participantes: 1 = equipo "Dragones FC", 2 y 3 = sus jugadores, 4 = jugador individual
INSERT INTO Participantes VALUES (1, 'Dragones FC', 1, 1);
INSERT INTO Participantes VALUES (2, 'Ana Torres', 2, 2);
INSERT INTO Participantes VALUES (3, 'Carlos Ruiz', 3, NULL);
INSERT INTO Participantes VALUES (4, 'Luis Gomez', 4, 3);
-- Participante extra
INSERT INTO Participantes VALUES (5, 'Pedro Gomez', 5, NULL);
INSERT INTO Equipo VALUES (1, 5);

INSERT INTO Jugador VALUES (2, 'ana.torres@example.com', 19, 1);
INSERT INTO Jugador VALUES (3, 'carlos.ruiz@example.com', 22, 1);
INSERT INTO Jugador VALUES (4, 'luis.gomez@example.com', 27, NULL);

-- Premios: van después de Participantes porque idParticipante es FK a Participantes
INSERT INTO Premios VALUES (1, 'Dinero', 1, 1);   -- Dragones FC, torneo 1
INSERT INTO Premios VALUES (2, 'Trofeo', 1, 1);   -- Dragones FC, torneo 1
INSERT INTO Premios VALUES (3, 'Puntos', 2, 4);   -- Luis Gomez, torneo 2

INSERT INTO PartidasHechas VALUES (1, 1);
INSERT INTO PartidasHechas VALUES (1, 2);
INSERT INTO PartidasHechas VALUES (4, 3);


--poblarNOOK

-- PoblarNoOK: intentos de ingreso erróneos protegidos 

-- Dominio Tvideojuego no admite este valor
INSERT INTO Videojuegos VALUES (3, 'Puzzle Quest', 'Puzzle');

-- Dominio Tid_ exige valor positivo
INSERT INTO Torneos VALUES (-1, 10, '2026-01-01', 'Individual', 1);

-- Nulidad: tipo_torneo es NOT NULL y no se envía
INSERT INTO Torneos (idTorneo, participantes, fecha_inicio, videojuego)
VALUES (6, 10, '2026-01-01', 1);

-- Clave primaria duplicada 
INSERT INTO Videojuegos VALUES (1, 'Duplicado', 'FPS');

-- Clave foránea inválida: idTorneo 999 no existe
INSERT INTO Premios VALUES (10, 'Dinero', 999, 1);

-- Dominio Tedad fuera de rango (10-99)
INSERT INTO Jugador VALUES (5, 'pedro.gomez@example.com', 5, NULL);

-- Dominio Tcorreo con formato inválido
INSERT INTO Jugador VALUES (5, 'correo-invalido', 25, NULL);

-- Clave única duplicada: correo ya usado por Ana Torres
INSERT INTO Jugador VALUES (5, 'ana.torres@example.com', 30, NULL);

-- Clave primaria compuesta duplicada en PartidasHechas
INSERT INTO PartidasHechas VALUES (1, 1);


--disparadores

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


--tuplasOK

-- TuplasOK: ingreso de datos correctos respecto a las restricciones de tupla

INSERT INTO Torneos VALUES (101, 8,  '2099-01-10', 'Individual', 1);
INSERT INTO Torneos VALUES (102, 16, '2099-02-10', 'PorEquipos', 1);

INSERT INTO Partidas VALUES (101, 'Victoria', 15, '2099-01-11', 101);
INSERT INTO Partidas VALUES (102, 'Derrota',  0,  '2099-01-11', 101);
INSERT INTO Partidas VALUES (103, 'Empate',   3,  '2099-01-12', 101);

INSERT INTO Inscripciones VALUES (101, '2098-12-01', 101);
INSERT INTO Inscripciones VALUES (102, '2098-12-02', 101);
INSERT INTO Inscripciones VALUES (103, '2098-12-03', 101);

INSERT INTO Participantes VALUES (101, 'Equipo Alfa',  101, NULL);
INSERT INTO Participantes VALUES (102, 'Jugador Beta', 102, NULL);
INSERT INTO Participantes VALUES (103, 'Jugador Gamma',103, NULL);
INSERT INTO Equipo VALUES (101, 3);
INSERT INTO Jugador VALUES (102, 'beta@example.com',  20, 101);
INSERT INTO Jugador VALUES (103, 'gamma@example.com', 21, NULL);


--tuplasNoOK

-- TuplasNoOK: intentos de ingreso incorrectos protegidos por las restricciones de tupla

-- Torneo individual con 1 solo participante
INSERT INTO Torneos VALUES (103, 1, '2099-03-01', 'Individual', 1);

-- Torneo por equipos con menos de 4 participantes
INSERT INTO Torneos VALUES (104, 3, '2099-03-01', 'PorEquipos', 1);

-- Torneo mixto con menos de 4 participantes
INSERT INTO Torneos VALUES (105, 2, '2099-03-01', 'Mixto', 1);

-- Derrota con puntaje distinto de 0
INSERT INTO Partidas VALUES (104, 'Derrota', 5, '2099-01-12', 101);

-- Victoria con puntaje 0
INSERT INTO Partidas VALUES (105, 'Victoria', 0, '2099-01-12', 101);

-- Empate con puntaje 0
INSERT INTO Partidas VALUES (106, 'Empate', 0, '2099-01-12', 101);

-- Jugador que es su propio equipo (el participante 101 es un Equipo)
INSERT INTO Jugador VALUES (101, 'alfa@example.com', 25, 101);


--accionesOK

-- AccionesOK: casos que prueban las acciones de referencia

-- ON UPDATE CASCADE: al cambiar el id del videojuego, el torneo lo sigue
INSERT INTO Videojuegos VALUES (90, 'Test Game', 'FPS');
INSERT INTO Torneos VALUES (190, 8, '2099-05-01', 'Individual', 90);
UPDATE Videojuegos SET idVideojuego = 91 WHERE idVideojuego = 90;
SELECT idTorneo, videojuego FROM Torneos WHERE idTorneo = 190;   -- videojuego = 91

-- ON DELETE RESTRICT: debe fallar, el videojuego 91 todavía tiene un torneo
DELETE FROM Videojuegos WHERE idVideojuego = 91;

-- ON DELETE CASCADE (torneo): se borran sus premios, partidas y clasificación
INSERT INTO Premios VALUES (190, 'Trofeo', 190, 101);   -- premio del participante 101
INSERT INTO Partidas VALUES (190, 'Victoria', 7, '2099-05-02', 190);
INSERT INTO Clasificacion VALUES (190, 190);
DELETE FROM Torneos WHERE idTorneo = 190;
SELECT (SELECT COUNT(*) FROM Premios       WHERE idTorneo = 190) AS premios,
       (SELECT COUNT(*) FROM Partidas      WHERE torneo   = 190) AS partidas,
       (SELECT COUNT(*) FROM Clasificacion WHERE torneo   = 190) AS clasificacion;   
-- Con el torneo borrado, el videojuego 91 ya puede eliminarse
DELETE FROM Videojuegos WHERE idVideojuego = 91;

-- ON DELETE SET NULL (clasificación): el participante queda sin clasificación
INSERT INTO Clasificacion VALUES (101, 101);
UPDATE Participantes SET clasificacion = 101 WHERE id_participante = 102;
DELETE FROM Clasificacion WHERE idClasificacion = 101;
SELECT id_participante, clasificacion FROM Participantes WHERE id_participante = 102;   -- NULL

-- ON DELETE CASCADE (participante): se borran su fila de Jugador y sus PartidasHechas
INSERT INTO PartidasHechas VALUES (103, 101);
DELETE FROM Participantes WHERE id_participante = 103;
SELECT (SELECT COUNT(*) FROM Jugador         WHERE id_participante = 103) AS jugador,
       (SELECT COUNT(*) FROM PartidasHechas  WHERE participante    = 103) AS partidashechas;   

-- ON DELETE SET NULL (equipo): los jugadores del equipo quedan sin equipo
DELETE FROM Equipo WHERE id_participante = 101;
SELECT id_participante, equipo FROM Jugador WHERE id_participante = 102;   -- NULL


--disparadoresOK

-- DisparadoresOK: ingreso de datos usando la automatización de los disparadores

INSERT INTO Torneos VALUES (201, 4, '2099-06-01', 'Individual', 1);

-- Inscripción sin fecha: el disparador pone la fecha actual
INSERT INTO Inscripciones VALUES (201, NULL, 201);
SELECT id_inscripcion, fecha = CURRENT_DATE AS fecha_automatica
  FROM Inscripciones WHERE id_inscripcion = 201;   -- true

INSERT INTO Inscripciones VALUES (202, '2099-05-01', 201);
INSERT INTO Inscripciones VALUES (203, '2099-05-01', 201);
INSERT INTO Inscripciones VALUES (204, '2099-05-02', 201);   -- completa los 4 cupos

-- Partida sin id: el disparador lo genera
INSERT INTO Partidas (idPartida, resultado, puntaje, fecha, torneo)
VALUES (NULL, 'Victoria', 20, '2099-06-02', 201);
SELECT idPartida, torneo FROM Partidas WHERE torneo = 201;

-- Partida con fecha válida y equipo con cupo disponible
INSERT INTO Partidas VALUES (211, 'Empate', 2, '2099-06-03', 201);

INSERT INTO Participantes VALUES (201, 'Equipo Delta',  202, NULL);
INSERT INTO Participantes VALUES (202, 'Jugador Eps',   203, NULL);
INSERT INTO Participantes VALUES (203, 'Jugador Zeta',  204, NULL);
INSERT INTO Equipo VALUES (201, 1);                           -- equipo de 1 integrante
INSERT INTO Jugador VALUES (202, 'eps@example.com', 23, 201); -- ocupa el único cupo


--disparadoresNoOK

-- DisparadoresNoOK: intentos de ingreso erróneos protegidos por los disparadores

-- Partida anterior al inicio del torneo
INSERT INTO Partidas VALUES (210, 'Victoria', 5, '2099-05-31', 201);

-- Cambiar una partida existente a una fecha anterior al inicio del torneo
UPDATE Partidas SET fecha = '2099-05-01' WHERE idPartida = 211;

-- Inscripción posterior al inicio del torneo
INSERT INTO Inscripciones VALUES (206, '2099-06-02', 201);

-- Inscripción en un torneo que ya llenó sus cupos
INSERT INTO Inscripciones VALUES (205, '2099-05-02', 201);

-- Un segundo jugador en un equipo de 1 integrante
INSERT INTO Jugador VALUES (203, 'zeta@example.com', 24, 201);


--Indices y vistas

-- Índices y Vistas: Definición de índices de rendimiento y vistas de consulta

-- ÍNDICES

-- Índice para búsquedas frecuentes sobre bienes dado un rango de precios
CREATE INDEX idx_bienes_precio ON Videojuegos (tipoVideojuego); -- Ajustado a las tablas actuales de tu dominio

-- Índice para consultas sobre partidas/ventas en fechas específicas
CREATE INDEX idx_partidas_fecha ON Partidas (fecha);

-- Índice alternativo para mejorar búsquedas por correo de jugadores
CREATE INDEX idx_jugador_correo ON Jugador (correo);


-- VISTAS

-- Vista de solo lectura para consultar la información de jugadores/participantes
CREATE OR REPLACE VIEW VParticipantesDetalle AS
SELECT 
    p.id_participante,
    p.nombre AS nombre_participante,
    j.correo,
    j.edad,
    j.equipo
FROM Participantes p
JOIN Jugador j ON p.id_participante = j.id_participante;


--Componentes

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


--ComponentesOK

-- ComponentesOK: Casos correctos de uso de los servicios

-- Prueba de inserción correcta de partida mediante procedimiento
CALL sv_partidas_adicionar(901, 'Victoria', 10, '2099-06-01', 101);

-- Verificación de consulta mediante refcursor
BEGIN;
SELECT sv_torneos_consultar('cursor_torneos');
FETCH ALL FROM cursor_torneos;
COMMIT;


--ComponentesNoOK

-- ComponentesNoOK: Casos incorrectos protegidos por los servicios

-- Intento de insertar partida con datos inválidos o llave duplicada
CALL sv_partidas_adicionar(901, 'Derrota', 5, '2099-06-01', 9999);


--Seguridad

-- Seguridad: Definición de roles y permisos de acceso

-- Creación de roles de base de datos según los actores 
CREATE ROLE rol_gerente;
CREATE ROLE rol_jugador;

-- Otorgar permisos específicos al rol de Gerente sobre las tablas principales
GRANT SELECT, INSERT, UPDATE, DELETE ON Torneos, Videojuegos, Premios TO rol_gerente;

-- Otorgar permisos de consulta controlada al rol de Jugador
GRANT SELECT ON Torneos, Partidas TO rol_jugador;


--Pruebas

-- Pruebas: Historias complementarias 

-- Historia 1: Registro completo de un torneo con sus respectivos participantes y partidas iniciales
INSERT INTO Videojuegos VALUES (50, 'Cyber Game', 'Estrategia');
INSERT INTO Torneos VALUES (501, 4, '2099-08-01', 'PorEquipos', 50);

-- Historia 2: Consulta gerencial de validación cruzada de puntajes
SELECT t.idTorneo, COUNT(p.idPartida) AS total_partidas, SUM(p.puntaje) AS puntaje_acumulado
FROM Torneos t
LEFT JOIN Partidas p ON t.idTorneo = p.torneo
GROUP BY t.idTorneo;


--Consultas_gerenciales

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


--ConsultasOperativas

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


--Xpoblar

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


--Xdisparadores

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


-- Tablas
SELECT table_name FROM information_schema.tables WHERE table_schema = 'public';

-- Dominios
SELECT domain_name FROM information_schema.domains WHERE domain_schema = 'public';

-- Roles
SELECT rolname FROM pg_roles WHERE rolname IN ('rol_gerente', 'rol_jugador');
