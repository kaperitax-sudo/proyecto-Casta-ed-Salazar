-- Foraneas

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
