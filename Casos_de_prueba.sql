-- Pruebas

-- Caso de prueba 1: un usuario se inscribe en un torneo

-- Precondición: existe un torneo con 2 cupos
CALL ADMINISTRADOR.AD_VIDEOJUEGO(800, 'Galaxy Clash', 'MOBA');
CALL ADMINISTRADOR.AD_TORNEO(800, 2, '2099-12-01', 'Individual', 800);

-- el usuario se inscribe sin poner la fecha
CALL USUARIO.AD_INSCRIPCION(800, NULL, 800);
SELECT * FROM Inscripciones WHERE id_inscripcion = 800;
-- Esperado: la inscripción tiene la fecha de hoy

--  el usuario se registra como jugador
CALL USUARIO.AD_JUGADOR(800, 'Laura Pineda', 800, 'laura@example.com', 20, NULL);
SELECT * FROM VParticipantesDetalle WHERE id_participante = 800;
-- Esperado: aparece Laura con su correo y su edad

-- el torneo quedó con 1 inscrito y le queda 1 cupo
SELECT COUNT(*) AS inscritos FROM Inscripciones WHERE torneo = 800;
-- Esperado: 1

-- Limpieza
CALL USUARIO.ELI_JUGADOR(800);
CALL ADMINISTRADOR.ELI_TORNEO(800);
CALL ADMINISTRADOR.ELI_VIDEOJUEGO(800);


-- Caso de prueba 2: el administrador registra partidas y cierra un torneo

-- Precondición: existe un torneo con una jugadora inscrita
CALL ADMINISTRADOR.AD_VIDEOJUEGO(900, 'Speed Arena', 'Lucha');
CALL ADMINISTRADOR.AD_TORNEO(900, 2, '2099-12-01', 'Individual', 900);
CALL USUARIO.AD_INSCRIPCION(900, NULL, 900);
CALL USUARIO.AD_JUGADOR(900, 'Ana Ruiz', 900, 'ana@example.com', 21, NULL);

--  el administrador registra una victoria de 10 puntos
CALL ADMINISTRADOR.AD_PARTIDA(900, 'Victoria', 10, '2099-12-02', 900);
SELECT * FROM Partidas WHERE torneo = 900;
-- Esperado: aparece la partida 900 con Victoria y 10 puntos

--  intenta registrar una derrota con puntos
DO $$
BEGIN
    CALL ADMINISTRADOR.AD_PARTIDA(901, 'Derrota', 5, '2099-12-02', 900);
    RAISE NOTICE 'FALLA: dejó registrar una derrota con puntos';
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'PASA: %', SQLERRM;
END;
$$;
-- Esperado: PASA, una derrota debe tener 0 puntos

--  intenta borrar el videojuego del torneo
DO $$
BEGIN
    CALL ADMINISTRADOR.ELI_VIDEOJUEGO(900);
    RAISE NOTICE 'FALLA: dejó borrar un videojuego que tiene torneos';
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'PASA: %', SQLERRM;
END;
$$;
-- Esperado: PASA, el videojuego tiene un torneo

--  se retira la jugadora y se cierra el torneo
CALL USUARIO.ELI_JUGADOR(900);
CALL ADMINISTRADOR.ELI_TORNEO(900);
SELECT COUNT(*) AS partidas FROM Partidas WHERE torneo = 900;
-- Esperado: 0, las partidas se borraron junto con el torneo
