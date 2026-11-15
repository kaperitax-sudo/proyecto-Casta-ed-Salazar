-- Seguridad: Definición de roles y permisos de acceso

-- Creación de roles de base de datos según los actores 
CREATE ROLE rol_gerente;
CREATE ROLE rol_jugador;

-- Otorgar permisos específicos al rol de Gerente sobre las tablas principales
GRANT SELECT, INSERT, UPDATE, DELETE ON Torneos, Videojuegos, Premios TO rol_gerente;

-- Otorgar permisos de consulta controlada al rol de Jugador
GRANT SELECT ON Torneos, Partidas TO rol_jugador;
