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
