-- Unicas

ALTER TABLE Jugador ADD CONSTRAINT UK_correo_jugador UNIQUE(correo);
ALTER TABLE Participantes ADD CONSTRAINT UK_participantes_inscripcion UNIQUE(inscripcion);
ALTER TABLE Participantes ADD CONSTRAINT UK_participantes_clasificados UNIQUE(clasificacion);
