-- Seguridad

-- Roles
DO $$
DECLARE
    r TEXT;
BEGIN
    FOREACH r IN ARRAY ARRAY['rol_administrador', 'rol_usuario'] LOOP
        IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = r) THEN
            BEGIN
                EXECUTE format('CREATE ROLE %I', r);
            EXCEPTION WHEN insufficient_privilege THEN
                RAISE NOTICE 'Sin permiso para crear el rol %: se omiten sus permisos', r;
                CONTINUE;
            END;
        END IF;
        BEGIN
            EXECUTE format('GRANT %I TO %I', r, current_user);
        EXCEPTION WHEN OTHERS THEN
            NULL;
        END;
    END LOOP;
END;
$$;

-- Permisos
REVOKE ALL ON ALL TABLES IN SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA PC_TORNEO, PC_PREMIO, PC_CLASIFICACION, PC_PARTIDA, PC_VIDEOJUEGO, PC_PARTICIPANTE, PC_INSCRIPCION
    FROM PUBLIC;
REVOKE EXECUTE ON ALL ROUTINES IN SCHEMA PC_TORNEO, PC_PREMIO, PC_CLASIFICACION, PC_PARTIDA, PC_VIDEOJUEGO, PC_PARTICIPANTE, PC_INSCRIPCION
    FROM PUBLIC;
REVOKE EXECUTE ON ALL ROUTINES IN SCHEMA ADMINISTRADOR, USUARIO FROM PUBLIC;

DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'rol_administrador') THEN
        GRANT USAGE ON SCHEMA ADMINISTRADOR TO rol_administrador;
        GRANT EXECUTE ON ALL ROUTINES IN SCHEMA ADMINISTRADOR TO rol_administrador;
    END IF;
    IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'rol_usuario') THEN
        GRANT USAGE ON SCHEMA USUARIO TO rol_usuario;
        GRANT EXECUTE ON ALL ROUTINES IN SCHEMA USUARIO TO rol_usuario;
    END IF;
END;
$$;
