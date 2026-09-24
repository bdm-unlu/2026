CREATE SCHEMA bdm;

COMMENT ON SCHEMA bdm IS 'Data warehouse de la materia Bases de Datos Masivas';

CREATE TABLE bdm.dcarrera (
    id           integer     PRIMARY KEY,
    descripcion  varchar(80) NOT NULL,
    departamento varchar(40) NOT NULL
);

COMMENT ON TABLE bdm.dcarrera IS 'Dimension carrera, con jerarquia Departamento > Carrera';

INSERT INTO bdm.dcarrera (id, descripcion, departamento) VALUES
    (1, 'Licenciatura en Sistemas de Informacion', 'Ciencias Basicas'),
    (2, 'Ingenieria en Alimentos',                 'Tecnologia'),
    (3, 'Licenciatura en Administracion',          'Ciencias Sociales'),
    (4, 'Licenciatura en Trabajo Social',          'Ciencias Sociales'),
    (5, 'Profesorado en Ciencias de la Educacion', 'Educacion'),
    (6, 'Licenciatura en Enfermeria',              'Ciencias Basicas'),
    (7, 'Ingenieria Industrial',                   'Tecnologia');

CREATE TABLE bdm.dsede (
    id          integer     PRIMARY KEY,
    descripcion varchar(40) NOT NULL
);

COMMENT ON TABLE bdm.dsede IS 'Dimension sede (centros regionales de la UNLu)';

INSERT INTO bdm.dsede (id, descripcion) VALUES
    (1, 'Lujan'),
    (2, 'San Miguel'),
    (3, 'Chivilcoy'),
    (4, 'Campana');

CREATE TABLE bdm.dsexo (
    id          integer     PRIMARY KEY,
    descripcion varchar(20) NOT NULL
);

COMMENT ON TABLE bdm.dsexo IS 'Dimension sexo';

INSERT INTO bdm.dsexo (id, descripcion) VALUES
    (1, 'Masculino'),
    (2, 'Femenino');

CREATE TABLE bdm.dtiempo (
    id           integer     PRIMARY KEY,
    anio         integer     NOT NULL,
    cuatrimestre varchar(2)  NOT NULL,
    etiqueta     varchar(20) NOT NULL,
    UNIQUE (anio, cuatrimestre)
);

COMMENT ON TABLE bdm.dtiempo IS 'Dimension tiempo, con jerarquia Anio > Cuatrimestre';

INSERT INTO bdm.dtiempo (id, anio, cuatrimestre, etiqueta)
SELECT (a - 2022) * 2 + c,
       a,
       c || 'C',
       a || '-' || c || 'C'
  FROM generate_series(2022, 2026) AS a,
       generate_series(1, 2)       AS c;

CREATE TABLE bdm.halumno (
    id                 integer      PRIMARY KEY,
    id_carrera         integer      NOT NULL REFERENCES bdm.dcarrera(id),
    id_sede            integer      NOT NULL REFERENCES bdm.dsede(id),
    id_sexo            integer      NOT NULL REFERENCES bdm.dsexo(id),
    id_tiempo          integer      NOT NULL REFERENCES bdm.dtiempo(id),
    materias_aprobadas integer      NOT NULL,
    promedio           numeric(4,2) NOT NULL
);

COMMENT ON TABLE bdm.halumno IS 'Tabla de hechos: un registro por alumno inscripto';

SELECT setseed(0.42);

INSERT INTO bdm.halumno (id, id_carrera, id_sede, id_sexo, id_tiempo,
                         materias_aprobadas, promedio)
SELECT g,
       1 + floor(power(random(), 1.6) * 7)::int,
       1 + floor(power(random(), 2.0) * 4)::int,
       1 + floor(random() * 2)::int,
       1 + floor(random() * 10)::int,
       floor(random() * 36)::int,
       round((4 + random() * 6)::numeric, 2)
  FROM generate_series(1, 5000) AS g;

CREATE INDEX halumno_carrera_idx ON bdm.halumno (id_carrera);
CREATE INDEX halumno_sede_idx    ON bdm.halumno (id_sede);
CREATE INDEX halumno_sexo_idx    ON bdm.halumno (id_sexo);
CREATE INDEX halumno_tiempo_idx  ON bdm.halumno (id_tiempo);

ANALYZE bdm.dcarrera;
ANALYZE bdm.dsede;
ANALYZE bdm.dsexo;
ANALYZE bdm.dtiempo;
ANALYZE bdm.halumno;
