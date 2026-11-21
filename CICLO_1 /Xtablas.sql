-- XTablas: eliminación de tablas y dominios
-- (antes: XSeguridad, XComponentes y XIndicesVistas, que dependen de las tablas)

DROP TABLE IF EXISTS PartidasHechas;
DROP TABLE IF EXISTS Premios;
DROP TABLE IF EXISTS Jugador;
DROP TABLE IF EXISTS Equipo;
DROP TABLE IF EXISTS Participantes;
DROP TABLE IF EXISTS Partidas;
DROP TABLE IF EXISTS Clasificacion;
DROP TABLE IF EXISTS Inscripciones;
DROP TABLE IF EXISTS Torneos;
DROP TABLE IF EXISTS Videojuegos;

DROP DOMAIN IF EXISTS Tid_;
DROP DOMAIN IF EXISTS Tresultado;
DROP DOMAIN IF EXISTS Tpremio;
DROP DOMAIN IF EXISTS Tvideojuego;
DROP DOMAIN IF EXISTS Ttorneo;
DROP DOMAIN IF EXISTS Tcorreo;
DROP DOMAIN IF EXISTS Tedad;
