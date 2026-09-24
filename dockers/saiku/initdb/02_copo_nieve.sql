CREATE TABLE bdm.ddepartamento (
    id          integer     PRIMARY KEY,
    descripcion varchar(40) NOT NULL UNIQUE
);

COMMENT ON TABLE bdm.ddepartamento IS
    'Copo de nieve: nivel Departamento, extraido de bdm.dcarrera';

INSERT INTO bdm.ddepartamento (id, descripcion)
SELECT row_number() OVER (ORDER BY departamento),
       departamento
  FROM (SELECT DISTINCT departamento FROM bdm.dcarrera) AS d;

CREATE TABLE bdm.dcarrera_copo (
    id              integer     PRIMARY KEY,
    descripcion     varchar(80) NOT NULL,
    id_departamento integer     NOT NULL REFERENCES bdm.ddepartamento(id)
);

COMMENT ON TABLE bdm.dcarrera_copo IS
    'Copo de nieve: nivel Carrera. Mismos ids que bdm.dcarrera, sin la columna departamento';

INSERT INTO bdm.dcarrera_copo (id, descripcion, id_departamento)
SELECT c.id,
       c.descripcion,
       d.id
  FROM bdm.dcarrera     c
  JOIN bdm.ddepartamento d ON c.departamento = d.descripcion;

CREATE INDEX dcarrera_copo_departamento_idx ON bdm.dcarrera_copo (id_departamento);

ANALYZE bdm.ddepartamento;
ANALYZE bdm.dcarrera_copo;

DO $$
DECLARE
    diferencias integer;
BEGIN
    SELECT count(*) INTO diferencias
      FROM bdm.dcarrera c
      FULL JOIN (SELECT cc.id, cc.descripcion, d.descripcion AS departamento
                   FROM bdm.dcarrera_copo  cc
                   JOIN bdm.ddepartamento  d ON cc.id_departamento = d.id) copo
        ON c.id = copo.id
     WHERE c.id           IS DISTINCT FROM copo.id
        OR c.descripcion  IS DISTINCT FROM copo.descripcion
        OR c.departamento IS DISTINCT FROM copo.departamento;

    IF diferencias > 0 THEN
        RAISE EXCEPTION
            'El copo de nieve no coincide con la estrella: % filas distintas', diferencias;
    END IF;
END $$;
