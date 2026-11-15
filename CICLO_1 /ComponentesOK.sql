-- ComponentesOK: Casos correctos de uso de los servicios

-- Prueba de inserción correcta de partida mediante procedimiento
CALL sv_partidas_adicionar(901, 'Victoria', 10, '2099-06-01', 101);

-- Verificación de consulta mediante refcursor
BEGIN;
SELECT sv_torneos_consultar('cursor_torneos');
FETCH ALL FROM cursor_torneos;
COMMIT;
