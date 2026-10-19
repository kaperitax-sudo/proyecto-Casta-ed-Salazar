CREATE TABLE Videojuegos (
    idVideojuego     Tid          NOT NULL,
    nombre           VARCHAR(20)  NOT NULL,
    tipoVideojuego   Tvideojuego  NOT NULL
);

CREATE TABLE Torneos (
    idTorneo         Tid       NOT NULL,
    participantes    INTEGER   NOT NULL,
    fecha_inicio     DATE      NOT NULL,
    tipo_torneo      Ttorneo   NOT NULL,
    videojuego       Tid       NOT NULL
   
);

CREATE TABLE Premios (
    idPremio     Tid      NOT NULL,
    tipoPremio   Tpremio  NOT NULL,
    idTorneo     Tid      NOT NULL,
    idParticipante Tid    NOT NULL -- agregado
);

CREATE TABLE Partidas (
    idPartida    Tid          NOT NULL,
    resultado    Tresultado   NOT NULL,
    puntaje      INTEGER      NOT NULL ,
    fecha        DATE         NOT NULL,
    torneo       Tid          NOT NULL
);

CREATE TABLE Inscripciones (
    id_inscripcion   Tid    NOT NULL,
    fecha            DATE   NOT NULL,
    torneo           Tid    NOT NULL
);

CREATE TABLE Clasificacion (
    idClasificacion   Tid   NOT NULL,
    torneo            Tid   NOT NULL
);
 
-- Inscripcion y clasificacion son UNIQUE porque cada inscripción/clasificación pertenece a un único participante.

CREATE TABLE Participantes (
    id_participante   Tid          NOT NULL,
    nombre            VARCHAR(20)  NOT NULL,
    inscripcion       Tid          NOT NULL,
    clasificacion     Tid
  
);

CREATE TABLE Equipo (
    id_participante   Tid       NOT NULL,
    no_integrantes    SMALLINT  NOT NULL
);

-- Un jugador puede no pertenecer a ningún equipo

CREATE TABLE Jugador (
    id_participante   Tid      NOT NULL,
    correo            Tcorreo  NOT NULL,
    edad              Tedad    NOT NULL,
    equipo            Tid
);

-- Tabla de asociación Participantes y Partidas
CREATE TABLE PartidasHechas (
    participante   Tid   NOT NULL,
    partida        Tid   NOT NULL
    
);
