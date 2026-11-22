-- Primarias

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
