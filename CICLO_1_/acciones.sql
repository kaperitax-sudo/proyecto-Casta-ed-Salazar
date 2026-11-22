-- Acciones

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
