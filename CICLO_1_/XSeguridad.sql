-- XSeguridad

DROP SCHEMA IF EXISTS ADMINISTRADOR CASCADE;
DROP SCHEMA IF EXISTS USUARIO CASCADE;

DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'rol_administrador') THEN
        REVOKE ALL ON ALL TABLES IN SCHEMA public FROM rol_administrador;
        DROP ROLE rol_administrador;
    END IF;
    IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'rol_usuario') THEN
        REVOKE ALL ON ALL TABLES IN SCHEMA public FROM rol_usuario;
        DROP ROLE rol_usuario;
    END IF;
END;
$$;
