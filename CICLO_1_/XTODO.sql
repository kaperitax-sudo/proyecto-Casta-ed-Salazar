DROP SCHEMA IF EXISTS ADMINISTRADOR, USUARIO CASCADE;
DROP SCHEMA IF EXISTS PC_TORNEO, PC_PREMIO, PC_CLASIFICACION, PC_PARTIDA,
                      PC_VIDEOJUEGO, PC_PARTICIPANTE, PC_INSCRIPCION CASCADE;

DO $$
DECLARE
    r RECORD;
BEGIN
    FOR r IN SELECT viewname FROM pg_views WHERE schemaname = 'public' LOOP
        EXECUTE format('DROP VIEW IF EXISTS public.%I CASCADE', r.viewname);
    END LOOP;

    FOR r IN SELECT tablename FROM pg_tables WHERE schemaname = 'public' LOOP
        EXECUTE format('DROP TABLE IF EXISTS public.%I CASCADE', r.tablename);
    END LOOP;

    FOR r IN SELECT p.oid::regprocedure AS rutina, p.prokind
               FROM pg_proc p
               JOIN pg_namespace n ON n.oid = p.pronamespace
              WHERE n.nspname = 'public' AND p.prokind IN ('f', 'p')
                AND NOT EXISTS (SELECT 1 FROM pg_depend d WHERE d.objid = p.oid AND d.deptype = 'e') LOOP
        EXECUTE format('DROP %s IF EXISTS %s CASCADE',
                       CASE WHEN r.prokind = 'p' THEN 'PROCEDURE' ELSE 'FUNCTION' END, r.rutina);
    END LOOP;

    FOR r IN SELECT t.typname
               FROM pg_type t
               JOIN pg_namespace n ON n.oid = t.typnamespace
              WHERE n.nspname = 'public' AND t.typtype = 'd' LOOP
        EXECUTE format('DROP DOMAIN IF EXISTS public.%I CASCADE', r.typname);
    END LOOP;
END;
$$;

DO $$
DECLARE
    r TEXT;
BEGIN
    FOREACH r IN ARRAY ARRAY['rol_administrador', 'rol_usuario', 'rol_gerente', 'rol_jugador'] LOOP
        IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = r) THEN
            BEGIN
                EXECUTE format('DROP OWNED BY %I', r);
                EXECUTE format('DROP ROLE %I', r);
            EXCEPTION WHEN OTHERS THEN
                RAISE NOTICE 'No se pudo borrar el rol %: %', r, SQLERRM;
            END;
        END IF;
    END LOOP;
END;
$$;

