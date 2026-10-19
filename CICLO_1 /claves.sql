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





