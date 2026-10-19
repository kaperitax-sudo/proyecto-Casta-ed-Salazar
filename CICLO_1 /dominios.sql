-- 1. Dominios 
CREATE DOMAIN Tid AS INTEGER
    CHECK (VALUE > 0);

-- Resultado de una partida
CREATE DOMAIN Tresultado AS VARCHAR(20)
    CHECK (VALUE IN ('Victoria', 'Derrota', 'Empate'));

-- Tipo de premio que ofrece un torneo
CREATE DOMAIN Tpremio AS VARCHAR(20)
    CHECK (VALUE IN ('Dinero', 'Trofeo', 'Puntos', 'Objeto_fisico'));

-- Tipo o género del videojuego
CREATE DOMAIN Tvideojuego AS VARCHAR(20)
    CHECK (VALUE IN ('FPS', 'MOBA', 'Deportivo', 'Estrategia', 'Lucha', 'BattleRoyale'));

-- Modalidad del torneo
CREATE DOMAIN Ttorneo AS VARCHAR(20)
    CHECK (VALUE IN ('Individual', 'PorEquipos', 'Mixto'));

-- Correo del jugador
CREATE DOMAIN Tcorreo AS VARCHAR(100)
    CHECK (VALUE ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$');

-- Edad del jugador 
CREATE DOMAIN Tedad AS SMALLINT
    CHECK (VALUE BETWEEN 10 AND 99);
    
