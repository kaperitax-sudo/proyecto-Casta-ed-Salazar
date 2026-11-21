-- dominios

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

-- Tablas

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

-- restricciones

ALTER TABLE Torneos ADD CONSTRAINT chk_torenosParticipantes CHECK (participantes > 0);
ALTER TABLE Partidas ADD CONSTRAINT chk_partidasPuntajes CHECK (puntaje >= 0);
ALTER TABLE Equipo ADD CONSTRAINT chk_EquipoIntegrantes CHECK ( no_integrantes > 0);

-- Primarias

-- Primarias: definición de claves primarias

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

-- Unicas

-- Unicas: definición de claves únicas

ALTER TABLE Jugador ADD CONSTRAINT UK_correo_jugador UNIQUE(correo);
ALTER TABLE Participantes ADD CONSTRAINT UK_participantes_inscripcion UNIQUE(inscripcion);
ALTER TABLE Participantes ADD CONSTRAINT UK_participantes_clasificados UNIQUE(clasificacion);

-- Foraneas

-- Foraneas: definición de claves foráneas
-- (las acciones de referencia se agregan en acciones.sql)

ALTER TABLE Torneos ADD CONSTRAINT FK_torneos_videojuego FOREIGN KEY (videojuego) REFERENCES Videojuegos (idVideojuego);
ALTER TABLE Premios ADD CONSTRAINT FK_Premios_Torneo FOREIGN KEY (idTorneo) REFERENCES Torneos (idTorneo);
ALTER TABLE Partidas ADD CONSTRAINT FK_partidas_torneo FOREIGN KEY (torneo) REFERENCES Torneos (idTorneo);
ALTER TABLE Inscripciones ADD CONSTRAINT FK_inscripciones_torneo FOREIGN KEY (torneo) REFERENCES Torneos (idTorneo);
ALTER TABLE Clasificacion ADD CONSTRAINT FK_Clasificacion_torneo FOREIGN KEY (torneo) REFERENCES Torneos (idTorneo);
ALTER TABLE Participantes ADD CONSTRAINT FK_participantes_inscripcion FOREIGN KEY (inscripcion) REFERENCES Inscripciones (id_inscripcion);
ALTER TABLE Participantes ADD CONSTRAINT FK_participantes_clasificacion FOREIGN KEY (clasificacion) REFERENCES Clasificacion (idClasificacion);
ALTER TABLE Equipo ADD CONSTRAINT FK_equipo_participante FOREIGN KEY (id_participante) REFERENCES Participantes (id_participante);
ALTER TABLE Jugador ADD CONSTRAINT FK_jugador_participante FOREIGN KEY (id_participante) REFERENCES Participantes (id_participante);
ALTER TABLE Jugador ADD CONSTRAINT FK_jugador_equipo FOREIGN KEY (equipo) REFERENCES Equipo (id_participante);
ALTER TABLE PartidasHechas ADD CONSTRAINT FK_ph_participantes FOREIGN KEY (participante) REFERENCES Participantes (id_participante);
ALTER TABLE PartidasHechas ADD CONSTRAINT FK_ph_partida FOREIGN KEY (partida) REFERENCES Partidas (idPartida);
ALTER TABLE Premios ADD CONSTRAINT FK_Premios_Participante FOREIGN KEY (idParticipante) REFERENCES Participantes (id_participante);

-- poblarOK

-- PoblarOK: ingreso de datos correctos (sin automatización)

INSERT INTO Videojuegos VALUES (1, 'League of Aeons', 'MOBA');
INSERT INTO Videojuegos VALUES (2, 'Rift Strikers', 'FPS');

INSERT INTO Torneos VALUES (1, 32, '2026-10-01', 'PorEquipos', 1);
INSERT INTO Torneos VALUES (2, 16, '2026-11-05', 'Individual', 2);
INSERT INTO Torneos VALUES (3, 16, '2099-12-01', 'Individual', 2);   -- torneo futuro, con cupos disponibles

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

-- ConsultasOperativas

-- Consultas operativas (usuario)

-- CO1: Consultar los torneos disponibles
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

-- CO2: Consultar los videojuegos con mayor cantidad de torneos
SELECT v.idVideojuego, v.nombre, v.tipoVideojuego,
       COUNT(t.idTorneo) AS cantidad_torneos
FROM Videojuegos v
LEFT JOIN Torneos t ON t.videojuego = v.idVideojuego
GROUP BY v.idVideojuego, v.nombre, v.tipoVideojuego
ORDER BY cantidad_torneos DESC, v.nombre;

-- CO3: Consultar los participantes con mejor desempeño en un torneo
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

-- CO4: Consultar los premios obtenidos por los participantes
SELECT p.id_participante, p.nombre AS participante,
       pr.idPremio, pr.tipoPremio,
       t.idTorneo, v.nombre AS videojuego
FROM Premios pr
JOIN Participantes p ON p.id_participante = pr.idParticipante
JOIN Torneos t ON t.idTorneo = pr.idTorneo
JOIN Videojuegos v ON v.idVideojuego = t.videojuego
ORDER BY p.nombre, t.idTorneo;

-- CO5: Consultar los resultados de las partidas de un torneo
SELECT pa.idPartida, pa.fecha, p.id_participante, p.nombre AS participante,
       pa.resultado, pa.puntaje
FROM Partidas pa
JOIN PartidasHechas ph ON ph.partida = pa.idPartida
JOIN Participantes p ON p.id_participante = ph.participante
WHERE pa.torneo = 1   -- idTorneo a consultar
ORDER BY pa.fecha, pa.idPartida;

-- CO6: Consultar los torneos en los que participa un jugador
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

-- CO7: Consultar la clasificación de un torneo
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

-- Consultas_gerenciales

-- Consultas gerenciales (administrador)

-- CG1: Consultar torneos con mayor número de inscritos
SELECT t.idTorneo, v.nombre AS videojuego, t.tipo_torneo, t.fecha_inicio,
       t.participantes AS cupo_maximo,
       COUNT(i.id_inscripcion) AS numero_inscritos
FROM Torneos t
JOIN Videojuegos v ON v.idVideojuego = t.videojuego
LEFT JOIN Inscripciones i ON i.torneo = t.idTorneo
GROUP BY t.idTorneo, v.nombre, t.tipo_torneo, t.fecha_inicio, t.participantes
ORDER BY numero_inscritos DESC;

-- CG2: Consultar participantes con mayor número de victorias
SELECT p.id_participante, p.nombre,
       COUNT(*) AS victorias
FROM Participantes p
JOIN PartidasHechas ph ON ph.participante = p.id_participante
JOIN Partidas pa ON pa.idPartida = ph.partida
WHERE pa.resultado = 'Victoria'
GROUP BY p.id_participante, p.nombre
ORDER BY victorias DESC, p.nombre;

-- CG3: Consultar participantes con mayor cantidad de premios
SELECT p.id_participante, p.nombre,
       COUNT(pr.idPremio) AS total_premios
FROM Participantes p
JOIN Premios pr ON pr.idParticipante = p.id_participante
GROUP BY p.id_participante, p.nombre
ORDER BY total_premios DESC, p.nombre;

-- CG4: Consultar videojuegos con mayor participación
SELECT v.idVideojuego, v.nombre, v.tipoVideojuego,
       COUNT(DISTINCT t.idTorneo) AS torneos,
       COUNT(i.id_inscripcion) AS total_inscripciones
FROM Videojuegos v
LEFT JOIN Torneos t ON t.videojuego = v.idVideojuego
LEFT JOIN Inscripciones i ON i.torneo = t.idTorneo
GROUP BY v.idVideojuego, v.nombre, v.tipoVideojuego
ORDER BY total_inscripciones DESC, v.nombre;

-- tuplas

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

-- acciones

-- Acciones: definición de las acciones de referencia
-- Se redefine cada clave foránea con su ON DELETE / ON UPDATE

ALTER TABLE Torneos
    DROP CONSTRAINT FK_torneos_videojuego,
    ADD CONSTRAINT FK_torneos_videojuego FOREIGN KEY (videojuego) REFERENCES Videojuegos (idVideojuego)
        ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE Premios
    DROP CONSTRAINT FK_Premios_Torneo,
    ADD CONSTRAINT FK_Premios_Torneo FOREIGN KEY (idTorneo) REFERENCES Torneos (idTorneo)
        ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Partidas
    DROP CONSTRAINT FK_partidas_torneo,
    ADD CONSTRAINT FK_partidas_torneo FOREIGN KEY (torneo) REFERENCES Torneos (idTorneo)
        ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Inscripciones
    DROP CONSTRAINT FK_inscripciones_torneo,
    ADD CONSTRAINT FK_inscripciones_torneo FOREIGN KEY (torneo) REFERENCES Torneos (idTorneo)
        ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Clasificacion
    DROP CONSTRAINT FK_Clasificacion_torneo,
    ADD CONSTRAINT FK_Clasificacion_torneo FOREIGN KEY (torneo) REFERENCES Torneos (idTorneo)
        ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Participantes
    DROP CONSTRAINT FK_participantes_inscripcion,
    ADD CONSTRAINT FK_participantes_inscripcion FOREIGN KEY (inscripcion) REFERENCES Inscripciones (id_inscripcion)
        ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE Participantes
    DROP CONSTRAINT FK_participantes_clasificacion,
    ADD CONSTRAINT FK_participantes_clasificacion FOREIGN KEY (clasificacion) REFERENCES Clasificacion (idClasificacion)
        ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE Equipo
    DROP CONSTRAINT FK_equipo_participante,
    ADD CONSTRAINT FK_equipo_participante FOREIGN KEY (id_participante) REFERENCES Participantes (id_participante)
        ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Jugador
    DROP CONSTRAINT FK_jugador_participante,
    ADD CONSTRAINT FK_jugador_participante FOREIGN KEY (id_participante) REFERENCES Participantes (id_participante)
        ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Jugador
    DROP CONSTRAINT FK_jugador_equipo,
    ADD CONSTRAINT FK_jugador_equipo FOREIGN KEY (equipo) REFERENCES Equipo (id_participante)
        ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE PartidasHechas
    DROP CONSTRAINT FK_ph_participantes,
    ADD CONSTRAINT FK_ph_participantes FOREIGN KEY (participante) REFERENCES Participantes (id_participante)
        ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE PartidasHechas
    DROP CONSTRAINT FK_ph_partida,
    ADD CONSTRAINT FK_ph_partida FOREIGN KEY (partida) REFERENCES Partidas (idPartida)
        ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Premios
    DROP CONSTRAINT FK_Premios_Participante,
    ADD CONSTRAINT FK_Premios_Participante FOREIGN KEY (idParticipante) REFERENCES Participantes (id_participante)
        ON DELETE CASCADE ON UPDATE CASCADE;

-- disparadores

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

-- tuplasOK

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

-- accionesOK

-- AccionesOK: casos que prueban las acciones de referencia
-- (usa sus propios datos, no depende de otros archivos de prueba)

-- ON UPDATE CASCADE: al cambiar el id del videojuego, el torneo lo sigue
INSERT INTO Videojuegos VALUES (90, 'Test Game', 'FPS');
INSERT INTO Torneos VALUES (190, 8, '2099-05-01', 'Individual', 90);
UPDATE Videojuegos SET idVideojuego = 91 WHERE idVideojuego = 90;
SELECT idTorneo, videojuego FROM Torneos WHERE idTorneo = 190;   -- videojuego = 91

-- ON DELETE RESTRICT: el borrado debe ser rechazado (se captura el error para que el script siga)
DO $$
BEGIN
    DELETE FROM Videojuegos WHERE idVideojuego = 91;
    RAISE NOTICE 'FALLO: el RESTRICT dejó borrar el videojuego 91';
EXCEPTION
    WHEN foreign_key_violation THEN
        RAISE NOTICE 'OK: el RESTRICT impidió borrar el videojuego 91';
END;
$$;

-- Datos para las pruebas con participantes: un equipo (191) y dos jugadores (192, 193)
INSERT INTO Videojuegos VALUES (92, 'Test Arena', 'MOBA');
INSERT INTO Torneos VALUES (191, 8, '2099-06-01', 'PorEquipos', 92);
INSERT INTO Inscripciones VALUES (191, '2099-05-01', 191);
INSERT INTO Inscripciones VALUES (192, '2099-05-01', 191);
INSERT INTO Inscripciones VALUES (193, '2099-05-01', 191);
INSERT INTO Participantes VALUES (191, 'Equipo Omega',  191, NULL);
INSERT INTO Participantes VALUES (192, 'Jugador Rho',   192, NULL);
INSERT INTO Participantes VALUES (193, 'Jugador Sigma', 193, NULL);
INSERT INTO Equipo VALUES (191, 3);
INSERT INTO Jugador VALUES (192, 'rho@example.com',   20, 191);
INSERT INTO Jugador VALUES (193, 'sigma@example.com', 21, NULL);

-- ON DELETE CASCADE (torneo): se borran sus premios, partidas y clasificación
INSERT INTO Premios VALUES (190, 'Trofeo', 190, 191);
INSERT INTO Partidas VALUES (190, 'Victoria', 7, '2099-05-02', 190);
INSERT INTO Clasificacion VALUES (190, 190);
DELETE FROM Torneos WHERE idTorneo = 190;
SELECT (SELECT COUNT(*) FROM Premios       WHERE idTorneo = 190) AS premios,
       (SELECT COUNT(*) FROM Partidas      WHERE torneo   = 190) AS partidas,
       (SELECT COUNT(*) FROM Clasificacion WHERE torneo   = 190) AS clasificacion;   -- 0, 0, 0
-- Con el torneo borrado, el videojuego 91 ya puede eliminarse
DELETE FROM Videojuegos WHERE idVideojuego = 91;

-- ON DELETE SET NULL (clasificación): el participante queda sin clasificación
INSERT INTO Clasificacion VALUES (191, 191);
UPDATE Participantes SET clasificacion = 191 WHERE id_participante = 192;
DELETE FROM Clasificacion WHERE idClasificacion = 191;
SELECT id_participante, clasificacion FROM Participantes WHERE id_participante = 192;   -- NULL

-- ON DELETE CASCADE (participante): se borran su fila de Jugador y sus PartidasHechas
INSERT INTO Partidas VALUES (191, 'Victoria', 5, '2099-06-02', 191);
INSERT INTO PartidasHechas VALUES (193, 191);
DELETE FROM Participantes WHERE id_participante = 193;
SELECT (SELECT COUNT(*) FROM Jugador        WHERE id_participante = 193) AS jugador,
       (SELECT COUNT(*) FROM PartidasHechas WHERE participante    = 193) AS partidashechas;   -- 0, 0

-- ON DELETE SET NULL (equipo): los jugadores del equipo quedan sin equipo
DELETE FROM Equipo WHERE id_participante = 191;
SELECT id_participante, equipo FROM Jugador WHERE id_participante = 192;   -- NULL

-- disparadoresOK

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

-- Indices y vistas

-- Índices y Vistas: Definición de índices de rendimiento y vistas de consulta

-- ÍNDICES

-- Índice para búsquedas de videojuegos por tipo
CREATE INDEX idx_videojuegos_tipo ON Videojuegos (tipoVideojuego); 

-- Índice para consultas de partidas en fechas específicas
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

-- IndicesVistasOK

-- IndicesVistasOK: consultas que requieren los índices y las vistas definidos
-- (se ejecuta después de poblarOK.sql)

-- idx_videojuegos_tipo: videojuegos de un tipo
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

-- Componentes

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

-- ComponentesOK

-- Package

-- PC_VIDEOJUEGO
CALL PC_VIDEOJUEGO.AD_VIDEOJUEGO(10, 'Arena Kings', 'Lucha');
CALL PC_VIDEOJUEGO.MOD_VIDEOJUEGO(10, 'Arena Kings II', 'Lucha');
BEGIN;
SELECT PC_VIDEOJUEGO.CO_VIDEOJUEGO();
FETCH ALL FROM co_videojuego;
SELECT PC_VIDEOJUEGO.CO_VIDEOJUEGOS_MAS_TORNEOS();
FETCH ALL FROM co_videojuegos_mas_torneos;
COMMIT;

-- PC_TORNEO
CALL PC_TORNEO.AD_TORNEO(10, 8, '2099-03-01', 'Mixto', 10);
CALL PC_TORNEO.MOD_TORNEO(10, 16, '2099-03-15', 'Mixto', 10);
BEGIN;
SELECT PC_TORNEO.CO_TORNEO();
FETCH ALL FROM co_torneo;
SELECT PC_TORNEO.CO_TORNEOS_DISPONIBLES();
FETCH ALL FROM co_torneos_disponibles;
COMMIT;

-- PC_INSCRIPCION
CALL PC_INSCRIPCION.AD_INSCRIPCION(10, '2099-01-10', 10);
CALL PC_INSCRIPCION.AD_INSCRIPCION(11, NULL, 10);
CALL PC_INSCRIPCION.AD_INSCRIPCION(12, '2099-01-12', 10);

-- PC_PARTICIPANTE
CALL PC_PARTICIPANTE.AD_EQUIPO(10, 'Titanes', 10, 3);
CALL PC_PARTICIPANTE.MOD_EQUIPO(10, 'Titanes eSports', 10, 4);
CALL PC_PARTICIPANTE.AD_JUGADOR(11, 'Sofia Rojas', 11, 'sofia.rojas@example.com', 21, 10);
CALL PC_PARTICIPANTE.AD_JUGADOR(12, 'Mateo Diaz', 12, 'mateo.diaz@example.com', 18, NULL);
CALL PC_PARTICIPANTE.MOD_JUGADOR(12, 'Mateo Diaz', 12, 'mateo.diaz@example.com', 19, 10);
BEGIN;
SELECT PC_PARTICIPANTE.CO_JUGADOR();
FETCH ALL FROM co_jugador;
SELECT PC_PARTICIPANTE.CO_EQUIPO();
FETCH ALL FROM co_equipo;
SELECT PC_PARTICIPANTE.CO_TORNEOS_JUGADOR(2);
FETCH ALL FROM co_torneos_jugador;
SELECT PC_PARTICIPANTE.CO_MEJOR_DESEMPENO(1);
FETCH ALL FROM co_mejor_desempeno;
COMMIT;

-- PC_PARTIDA
CALL PC_PARTIDA.AD_PARTIDA(10, 'Victoria', 15, '2099-03-16', 10);
CALL PC_PARTIDA.AD_PARTIDA(NULL, 'Empate', 5, '2099-03-17', 10);
CALL PC_PARTIDA.MOD_PARTIDA(10, 'Victoria', 20, '2099-03-16', 10);
BEGIN;
SELECT PC_PARTIDA.CO_PARTIDA();
FETCH ALL FROM co_partida;
SELECT PC_PARTIDA.CO_RESULTADOS_TORNEO(1);
FETCH ALL FROM co_resultados_torneo;
COMMIT;

-- PC_CLASIFICACION
CALL PC_CLASIFICACION.AD_CLASIFICACION(10, 10);
CALL PC_CLASIFICACION.MOD_CLASIFICACION(10, 10);
BEGIN;
SELECT PC_CLASIFICACION.CO_CLASIFICACION();
FETCH ALL FROM co_clasificacion;
SELECT PC_CLASIFICACION.CO_CLASIFICACION_TORNEO(1);
FETCH ALL FROM co_clasificacion_torneo;
COMMIT;

-- PC_PREMIO
CALL PC_PREMIO.AD_PREMIO(10, 'Trofeo', 10, 10);
CALL PC_PREMIO.MOD_PREMIO(10, 'Dinero', 10, 10);
BEGIN;
SELECT PC_PREMIO.CO_PREMIO();
FETCH ALL FROM co_premio;
SELECT PC_PREMIO.CO_PREMIOS_PARTICIPANTES();
FETCH ALL FROM co_premios_participantes;
COMMIT;
CALL PC_PREMIO.ELI_PREMIO(10);

-- PC_CLASIFICACION
CALL PC_CLASIFICACION.ELI_CLASIFICACION(10);

-- PC_PARTIDA
CALL PC_PARTIDA.ELI_PARTIDA(10);

-- PC_PARTICIPANTE
CALL PC_PARTICIPANTE.ELI_JUGADOR(12);
CALL PC_PARTICIPANTE.ELI_EQUIPO(10);
CALL PC_PARTICIPANTE.ELI_JUGADOR(11);

-- PC_TORNEO
CALL PC_TORNEO.ELI_TORNEO(10);

-- PC_VIDEOJUEGO
CALL PC_VIDEOJUEGO.ELI_VIDEOJUEGO(10);

-- Actores

-- Actores: implementación de los servicios de los actores

-- ADMINISTRADOR
CREATE SCHEMA IF NOT EXISTS ADMINISTRADOR;

CREATE OR REPLACE PROCEDURE ADMINISTRADOR.AD_TORNEO(
    xIDTORNEO      Tid_,
    xPARTICIPANTES INTEGER,
    xFECHA_INICIO  DATE,
    xTIPO_TORNEO   Ttorneo,
    xVIDEOJUEGO    Tid_
)
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
BEGIN
    CALL PC_TORNEO.AD_TORNEO(xIDTORNEO, xPARTICIPANTES, xFECHA_INICIO, xTIPO_TORNEO, xVIDEOJUEGO);
END;
$$;

CREATE OR REPLACE PROCEDURE ADMINISTRADOR.MOD_TORNEO(
    xIDTORNEO      Tid_,
    xPARTICIPANTES INTEGER,
    xFECHA_INICIO  DATE,
    xTIPO_TORNEO   Ttorneo,
    xVIDEOJUEGO    Tid_
)
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
BEGIN
    CALL PC_TORNEO.MOD_TORNEO(xIDTORNEO, xPARTICIPANTES, xFECHA_INICIO, xTIPO_TORNEO, xVIDEOJUEGO);
END;
$$;

CREATE OR REPLACE PROCEDURE ADMINISTRADOR.ELI_TORNEO(
    xIDTORNEO Tid_
)
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
BEGIN
    CALL PC_TORNEO.ELI_TORNEO(xIDTORNEO);
END;
$$;

CREATE OR REPLACE FUNCTION ADMINISTRADOR.CO_TORNEO() RETURNS REFCURSOR
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
BEGIN
    RETURN PC_TORNEO.CO_TORNEO();
END;
$$;

CREATE OR REPLACE PROCEDURE ADMINISTRADOR.AD_PREMIO(
    xIDPREMIO       Tid_,
    xTIPOPREMIO     Tpremio,
    xIDTORNEO       Tid_,
    xIDPARTICIPANTE Tid_
)
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
BEGIN
    CALL PC_PREMIO.AD_PREMIO(xIDPREMIO, xTIPOPREMIO, xIDTORNEO, xIDPARTICIPANTE);
END;
$$;

CREATE OR REPLACE PROCEDURE ADMINISTRADOR.MOD_PREMIO(
    xIDPREMIO       Tid_,
    xTIPOPREMIO     Tpremio,
    xIDTORNEO       Tid_,
    xIDPARTICIPANTE Tid_
)
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
BEGIN
    CALL PC_PREMIO.MOD_PREMIO(xIDPREMIO, xTIPOPREMIO, xIDTORNEO, xIDPARTICIPANTE);
END;
$$;

CREATE OR REPLACE PROCEDURE ADMINISTRADOR.ELI_PREMIO(
    xIDPREMIO Tid_
)
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
BEGIN
    CALL PC_PREMIO.ELI_PREMIO(xIDPREMIO);
END;
$$;

CREATE OR REPLACE FUNCTION ADMINISTRADOR.CO_PREMIO() RETURNS REFCURSOR
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
BEGIN
    RETURN PC_PREMIO.CO_PREMIO();
END;
$$;

CREATE OR REPLACE PROCEDURE ADMINISTRADOR.AD_CLASIFICACION(
    xIDCLASIFICACION Tid_,
    xTORNEO          Tid_
)
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
BEGIN
    CALL PC_CLASIFICACION.AD_CLASIFICACION(xIDCLASIFICACION, xTORNEO);
END;
$$;

CREATE OR REPLACE PROCEDURE ADMINISTRADOR.MOD_CLASIFICACION(
    xIDCLASIFICACION Tid_,
    xTORNEO          Tid_
)
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
BEGIN
    CALL PC_CLASIFICACION.MOD_CLASIFICACION(xIDCLASIFICACION, xTORNEO);
END;
$$;

CREATE OR REPLACE PROCEDURE ADMINISTRADOR.ELI_CLASIFICACION(
    xIDCLASIFICACION Tid_
)
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
BEGIN
    CALL PC_CLASIFICACION.ELI_CLASIFICACION(xIDCLASIFICACION);
END;
$$;

CREATE OR REPLACE FUNCTION ADMINISTRADOR.CO_CLASIFICACION() RETURNS REFCURSOR
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
BEGIN
    RETURN PC_CLASIFICACION.CO_CLASIFICACION();
END;
$$;

CREATE OR REPLACE PROCEDURE ADMINISTRADOR.AD_PARTIDA(
    xIDPARTIDA Tid_,
    xRESULTADO Tresultado,
    xPUNTAJE   INTEGER,
    xFECHA     DATE,
    xTORNEO    Tid_
)
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
BEGIN
    CALL PC_PARTIDA.AD_PARTIDA(xIDPARTIDA, xRESULTADO, xPUNTAJE, xFECHA, xTORNEO);
END;
$$;

CREATE OR REPLACE PROCEDURE ADMINISTRADOR.MOD_PARTIDA(
    xIDPARTIDA Tid_,
    xRESULTADO Tresultado,
    xPUNTAJE   INTEGER,
    xFECHA     DATE,
    xTORNEO    Tid_
)
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
BEGIN
    CALL PC_PARTIDA.MOD_PARTIDA(xIDPARTIDA, xRESULTADO, xPUNTAJE, xFECHA, xTORNEO);
END;
$$;

CREATE OR REPLACE PROCEDURE ADMINISTRADOR.ELI_PARTIDA(
    xIDPARTIDA Tid_
)
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
BEGIN
    CALL PC_PARTIDA.ELI_PARTIDA(xIDPARTIDA);
END;
$$;

CREATE OR REPLACE FUNCTION ADMINISTRADOR.CO_PARTIDA() RETURNS REFCURSOR
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
BEGIN
    RETURN PC_PARTIDA.CO_PARTIDA();
END;
$$;

CREATE OR REPLACE PROCEDURE ADMINISTRADOR.AD_VIDEOJUEGO(
    xIDVIDEOJUEGO   Tid_,
    xNOMBRE         VARCHAR,
    xTIPOVIDEOJUEGO Tvideojuego
)
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
BEGIN
    CALL PC_VIDEOJUEGO.AD_VIDEOJUEGO(xIDVIDEOJUEGO, xNOMBRE, xTIPOVIDEOJUEGO);
END;
$$;

CREATE OR REPLACE PROCEDURE ADMINISTRADOR.MOD_VIDEOJUEGO(
    xIDVIDEOJUEGO   Tid_,
    xNOMBRE         VARCHAR,
    xTIPOVIDEOJUEGO Tvideojuego
)
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
BEGIN
    CALL PC_VIDEOJUEGO.MOD_VIDEOJUEGO(xIDVIDEOJUEGO, xNOMBRE, xTIPOVIDEOJUEGO);
END;
$$;

CREATE OR REPLACE PROCEDURE ADMINISTRADOR.ELI_VIDEOJUEGO(
    xIDVIDEOJUEGO Tid_
)
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
BEGIN
    CALL PC_VIDEOJUEGO.ELI_VIDEOJUEGO(xIDVIDEOJUEGO);
END;
$$;

CREATE OR REPLACE FUNCTION ADMINISTRADOR.CO_VIDEOJUEGO() RETURNS REFCURSOR
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
BEGIN
    RETURN PC_VIDEOJUEGO.CO_VIDEOJUEGO();
END;
$$;

-- USUARIO
CREATE SCHEMA IF NOT EXISTS USUARIO;

CREATE OR REPLACE PROCEDURE USUARIO.AD_JUGADOR(
    xID_PARTICIPANTE Tid_,
    xNOMBRE          VARCHAR,
    xINSCRIPCION     Tid_,
    xCORREO          Tcorreo,
    xEDAD            INTEGER,
    xEQUIPO          Tid_
)
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
BEGIN
    CALL PC_PARTICIPANTE.AD_JUGADOR(xID_PARTICIPANTE, xNOMBRE, xINSCRIPCION, xCORREO, xEDAD, xEQUIPO);
END;
$$;

CREATE OR REPLACE PROCEDURE USUARIO.MOD_JUGADOR(
    xID_PARTICIPANTE Tid_,
    xNOMBRE          VARCHAR,
    xINSCRIPCION     Tid_,
    xCORREO          Tcorreo,
    xEDAD            INTEGER,
    xEQUIPO          Tid_
)
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
BEGIN
    CALL PC_PARTICIPANTE.MOD_JUGADOR(xID_PARTICIPANTE, xNOMBRE, xINSCRIPCION, xCORREO, xEDAD, xEQUIPO);
END;
$$;

CREATE OR REPLACE PROCEDURE USUARIO.ELI_JUGADOR(
    xID_PARTICIPANTE Tid_
)
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
BEGIN
    CALL PC_PARTICIPANTE.ELI_JUGADOR(xID_PARTICIPANTE);
END;
$$;

CREATE OR REPLACE FUNCTION USUARIO.CO_JUGADOR() RETURNS REFCURSOR
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
BEGIN
    RETURN PC_PARTICIPANTE.CO_JUGADOR();
END;
$$;

CREATE OR REPLACE PROCEDURE USUARIO.AD_EQUIPO(
    xID_PARTICIPANTE Tid_,
    xNOMBRE          VARCHAR,
    xINSCRIPCION     Tid_,
    xNO_INTEGRANTES  INTEGER
)
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
BEGIN
    CALL PC_PARTICIPANTE.AD_EQUIPO(xID_PARTICIPANTE, xNOMBRE, xINSCRIPCION, xNO_INTEGRANTES);
END;
$$;

CREATE OR REPLACE PROCEDURE USUARIO.MOD_EQUIPO(
    xID_PARTICIPANTE Tid_,
    xNOMBRE          VARCHAR,
    xINSCRIPCION     Tid_,
    xNO_INTEGRANTES  INTEGER
)
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
BEGIN
    CALL PC_PARTICIPANTE.MOD_EQUIPO(xID_PARTICIPANTE, xNOMBRE, xINSCRIPCION, xNO_INTEGRANTES);
END;
$$;

CREATE OR REPLACE PROCEDURE USUARIO.ELI_EQUIPO(
    xID_PARTICIPANTE Tid_
)
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
BEGIN
    CALL PC_PARTICIPANTE.ELI_EQUIPO(xID_PARTICIPANTE);
END;
$$;

CREATE OR REPLACE FUNCTION USUARIO.CO_EQUIPO() RETURNS REFCURSOR
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
BEGIN
    RETURN PC_PARTICIPANTE.CO_EQUIPO();
END;
$$;

CREATE OR REPLACE PROCEDURE USUARIO.AD_INSCRIPCION(
    xID_INSCRIPCION Tid_,
    xFECHA          DATE,
    xTORNEO         Tid_
)
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
BEGIN
    CALL PC_INSCRIPCION.AD_INSCRIPCION(xID_INSCRIPCION, xFECHA, xTORNEO);
END;
$$;

CREATE OR REPLACE FUNCTION USUARIO.CO_TORNEOS_DISPONIBLES() RETURNS REFCURSOR
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
BEGIN
    RETURN PC_TORNEO.CO_TORNEOS_DISPONIBLES();
END;
$$;

CREATE OR REPLACE FUNCTION USUARIO.CO_VIDEOJUEGOS_MAS_TORNEOS() RETURNS REFCURSOR
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
BEGIN
    RETURN PC_VIDEOJUEGO.CO_VIDEOJUEGOS_MAS_TORNEOS();
END;
$$;

CREATE OR REPLACE FUNCTION USUARIO.CO_TORNEOS_JUGADOR(
    xID_PARTICIPANTE Tid_
) RETURNS REFCURSOR
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
BEGIN
    RETURN PC_PARTICIPANTE.CO_TORNEOS_JUGADOR(xID_PARTICIPANTE);
END;
$$;

CREATE OR REPLACE FUNCTION USUARIO.CO_MEJOR_DESEMPENO(
    xIDTORNEO Tid_
) RETURNS REFCURSOR
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
BEGIN
    RETURN PC_PARTICIPANTE.CO_MEJOR_DESEMPENO(xIDTORNEO);
END;
$$;

CREATE OR REPLACE FUNCTION USUARIO.CO_RESULTADOS_TORNEO(
    xIDTORNEO Tid_
) RETURNS REFCURSOR
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
BEGIN
    RETURN PC_PARTIDA.CO_RESULTADOS_TORNEO(xIDTORNEO);
END;
$$;

CREATE OR REPLACE FUNCTION USUARIO.CO_PREMIOS_PARTICIPANTES() RETURNS REFCURSOR
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
BEGIN
    RETURN PC_PREMIO.CO_PREMIOS_PARTICIPANTES();
END;
$$;

CREATE OR REPLACE FUNCTION USUARIO.CO_CLASIFICACION_TORNEO(
    xIDTORNEO Tid_
) RETURNS REFCURSOR
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
BEGIN
    RETURN PC_CLASIFICACION.CO_CLASIFICACION_TORNEO(xIDTORNEO);
END;
$$;

-- Seguridad

-- Seguridad: definición de roles y permisos
-- (se ejecuta después de Componentes.sql y Actores.sql)

-- Roles
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'rol_administrador') THEN
        CREATE ROLE rol_administrador;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'rol_usuario') THEN
        CREATE ROLE rol_usuario;
    END IF;
END;
$$;

-- Permisos
REVOKE ALL ON ALL TABLES IN SCHEMA public FROM PUBLIC, rol_administrador, rol_usuario;
REVOKE ALL ON SCHEMA PC_TORNEO, PC_PREMIO, PC_CLASIFICACION, PC_PARTIDA, PC_VIDEOJUEGO, PC_PARTICIPANTE, PC_INSCRIPCION
    FROM PUBLIC, rol_administrador, rol_usuario;
REVOKE EXECUTE ON ALL ROUTINES IN SCHEMA PC_TORNEO, PC_PREMIO, PC_CLASIFICACION, PC_PARTIDA, PC_VIDEOJUEGO, PC_PARTICIPANTE, PC_INSCRIPCION
    FROM PUBLIC;
REVOKE EXECUTE ON ALL ROUTINES IN SCHEMA ADMINISTRADOR, USUARIO FROM PUBLIC;

GRANT USAGE ON SCHEMA ADMINISTRADOR TO rol_administrador;
GRANT EXECUTE ON ALL ROUTINES IN SCHEMA ADMINISTRADOR TO rol_administrador;

GRANT USAGE ON SCHEMA USUARIO TO rol_usuario;
GRANT EXECUTE ON ALL ROUTINES IN SCHEMA USUARIO TO rol_usuario;

-- SeguridadOK

-- SeguridadOK

-- ADMINISTRADOR
SET ROLE rol_administrador;
CALL ADMINISTRADOR.AD_VIDEOJUEGO(40, 'Neon Racers', 'Deportivo');
CALL ADMINISTRADOR.MOD_VIDEOJUEGO(40, 'Neon Racers X', 'Deportivo');
CALL ADMINISTRADOR.AD_TORNEO(40, 8, '2099-05-01', 'Individual', 40);
CALL ADMINISTRADOR.MOD_TORNEO(40, 10, '2099-05-02', 'Individual', 40);
CALL ADMINISTRADOR.AD_PARTIDA(40, 'Victoria', 12, '2099-05-03', 40);
CALL ADMINISTRADOR.MOD_PARTIDA(40, 'Victoria', 15, '2099-05-03', 40);
CALL ADMINISTRADOR.AD_CLASIFICACION(40, 40);
CALL ADMINISTRADOR.MOD_CLASIFICACION(40, 40);
BEGIN;
SELECT ADMINISTRADOR.CO_TORNEO();
FETCH ALL FROM co_torneo;
SELECT ADMINISTRADOR.CO_VIDEOJUEGO();
FETCH ALL FROM co_videojuego;
SELECT ADMINISTRADOR.CO_PARTIDA();
FETCH ALL FROM co_partida;
SELECT ADMINISTRADOR.CO_CLASIFICACION();
FETCH ALL FROM co_clasificacion;
COMMIT;
RESET ROLE;

-- USUARIO
SET ROLE rol_usuario;
CALL USUARIO.AD_INSCRIPCION(40, NULL, 40);
CALL USUARIO.AD_INSCRIPCION(41, NULL, 40);
CALL USUARIO.AD_EQUIPO(40, 'Furia Roja', 40, 3);
CALL USUARIO.MOD_EQUIPO(40, 'Furia Roja eSports', 40, 3);
CALL USUARIO.AD_JUGADOR(41, 'Valeria Cruz', 41, 'valeria.cruz@example.com', 20, 40);
CALL USUARIO.MOD_JUGADOR(41, 'Valeria Cruz', 41, 'valeria.cruz@example.com', 21, 40);
BEGIN;
SELECT USUARIO.CO_JUGADOR();
FETCH ALL FROM co_jugador;
SELECT USUARIO.CO_EQUIPO();
FETCH ALL FROM co_equipo;
SELECT USUARIO.CO_TORNEOS_DISPONIBLES();
FETCH ALL FROM co_torneos_disponibles;
SELECT USUARIO.CO_VIDEOJUEGOS_MAS_TORNEOS();
FETCH ALL FROM co_videojuegos_mas_torneos;
SELECT USUARIO.CO_TORNEOS_JUGADOR(41);
FETCH ALL FROM co_torneos_jugador;
SELECT USUARIO.CO_MEJOR_DESEMPENO(1);
FETCH ALL FROM co_mejor_desempeno;
SELECT USUARIO.CO_RESULTADOS_TORNEO(1);
FETCH ALL FROM co_resultados_torneo;
SELECT USUARIO.CO_PREMIOS_PARTICIPANTES();
FETCH ALL FROM co_premios_participantes;
SELECT USUARIO.CO_CLASIFICACION_TORNEO(1);
FETCH ALL FROM co_clasificacion_torneo;
COMMIT;
RESET ROLE;

-- ADMINISTRADOR
SET ROLE rol_administrador;
CALL ADMINISTRADOR.AD_PREMIO(40, 'Trofeo', 40, 41);
CALL ADMINISTRADOR.MOD_PREMIO(40, 'Dinero', 40, 41);
BEGIN;
SELECT ADMINISTRADOR.CO_PREMIO();
FETCH ALL FROM co_premio;
COMMIT;
CALL ADMINISTRADOR.ELI_PREMIO(40);
CALL ADMINISTRADOR.ELI_CLASIFICACION(40);
CALL ADMINISTRADOR.ELI_PARTIDA(40);
RESET ROLE;

-- USUARIO
SET ROLE rol_usuario;
CALL USUARIO.ELI_JUGADOR(41);
CALL USUARIO.ELI_EQUIPO(40);
RESET ROLE;

-- ADMINISTRADOR
SET ROLE rol_administrador;
CALL ADMINISTRADOR.ELI_TORNEO(40);
CALL ADMINISTRADOR.ELI_VIDEOJUEGO(40);
RESET ROLE;

-- Pruebas

-- Pruebas: Historias complementarias 

-- Historia 1: Registro completo de un torneo con sus respectivos participantes y partidas iniciales
INSERT INTO Videojuegos VALUES (50, 'Cyber Game', 'Estrategia');
INSERT INTO Torneos VALUES (501, 4, '2099-08-01', 'PorEquipos', 50);

-- Historia 2: Consulta gerencial de validación cruzada de puntajes
SELECT t.idTorneo, COUNT(p.idPartida) AS total_partidas, SUM(p.puntaje) AS puntaje_acumulado
FROM Torneos t
LEFT JOIN Partidas p ON t.idTorneo = p.torneo
GROUP BY t.idTorneo;
