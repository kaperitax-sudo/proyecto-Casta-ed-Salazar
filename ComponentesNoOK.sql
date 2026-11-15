-- ComponentesNoOK: Casos incorrectos protegidos por los servicios

-- Intento de insertar partida con datos inválidos o llave duplicada (debe fallar)
CALL sv_partidas_adicionar(901, 'Derrota', 5, '2099-06-01', 9999);