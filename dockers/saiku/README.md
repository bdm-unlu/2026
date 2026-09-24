# Saiku — el mismo cubo, en Mondrian 4

[Saiku](https://saiku.bi) es un servidor OLAP con interfaz web: se arrastran dimensiones y
medidas, y el navegador escribe el MDX. Corre sobre **Mondrian 4.8** (fork de Spicule) con
un planner de SQL basado en Apache Calcite.

---

## 1. Levantar

```bash
docker-compose up -d
```

La primera vez baja unos 1,5 GB. Cuando responde, la interfaz está en:

**http://localhost:8095/ui/** — usuario `admin`, clave `bdm`

Para bajarlo:

```bash
docker-compose down
```

| Servicio | Qué es | Dónde |
| --- | --- | --- |
| `saiku` | Servidor OLAP + interfaz web + endpoint XMLA | http://localhost:8095 |
| `postgres` | El data warehouse | `localhost:5471` |
| `pgadmin` | Cliente web de PostgreSQL, para ver los datos crudos y el diagrama | http://localhost:8096 |

### pgAdmin, desde el navegador

http://localhost:8096 — usuario `bdm@unlu.edu.ar`, clave `bdm`.

---

## 2. Los datos

```
saiku/initdb/
├── 01_star_schema.sql        <- DDL + carga del DW (5000 hechos)
├── 02_copo_nieve.sql         <- las dos tablas del modelo copo de nieve
└── 03_pg_stat_statements.sql <- la extension para ver el SQL que genera el cubo
```

Los scripts corren una sola vez, cuando la base se crea vacía. Después de tocarlos hay
que recrearla:

```bash
docker-compose down && docker-compose up -d
```

`01_` y `02_` hacen lo mismo que los de [`../emondrian/initdb/`](../emondrian/initdb/), pero
sin comentarios: están duplicados para que esta carpeta ande sola, así que **si se cambia el
data warehouse hay que cambiarlo en los dos lados**. `test_saiku.py` avisa si dejan de
coincidir.

---

## 3. Conectarse desde afuera

Saiku también publica **XMLA**, así que se conecta desde Excel, Power BI, Python:

```
http://localhost:8095/xmla
```