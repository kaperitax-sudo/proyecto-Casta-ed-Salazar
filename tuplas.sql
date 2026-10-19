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
