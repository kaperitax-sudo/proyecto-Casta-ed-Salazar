ALTER TABLE Torneos ADD CONSTRAINT chk_torenosParticipantes CHECK (participantes > 0);
ALTER TABLE Partidas ADD CONSTRAINT chk_partidasPuntajes CHECK (puntaje >= 0);
ALTER TABLE Equipo ADD CONSTRAINT chk_EquipoIntegrantes CHECK ( no_integrantes > 0);
