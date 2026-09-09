# Apache Hop — procesos ETL

[Apache Hop](https://hop.apache.org/) es una herramienta de orquestación de datos: se
diseñan visualmente los procesos de extracción, transformación y carga arrastrando
*transforms* y uniéndolos con *hops*, y después el mismo archivo se ejecuta desde la
interfaz o desde la línea de comandos. Es el sucesor de Pentaho Data Integration (Kettle),
del que hereda buena parte de los transforms.

Acá se usa **Hop Web**, que es el mismo Hop GUI de escritorio servido desde un Tomcat: no
hay que instalar nada, alcanza con el navegador.

| Servicio | Qué es | Dónde |
| --- | --- | --- |
| `hop` | Hop Web 2.19.0 (Tomcat 10 + JDK 21) | http://localhost:8090 |

---

## 1. Levantar

```bash
docker-compose up
```

La primera vez baja la imagen (~2 GB) y el arranque tarda unos 20 segundos. Cuando el
servicio figura `healthy` está listo:

```bash
docker-compose ps
```

Para bajarlo:

```bash
docker-compose down
```

---

## 2. Qué hay adentro

La carpeta `project/` está montada dentro del contenedor y es el proyecto de Hop. Todo lo
que se guarda desde el navegador queda acá.

```
project/
├── project-config.json
├── datos/                     <- los CSV de entrada
│   ├── inscripciones.csv
│   ├── carreras.csv
│   └── sedes.csv
├── pipelines/                 <- los cuatro pipelines de la clase
├── workflows/etl-alumnos.hwf  <- el workflow que los encadena
└── salida/                    <- acá escriben los pipelines
```

### Los datos

`inscripciones.csv` son 204 filas de un sistema académico, **sucias a propósito**.
`carreras.csv` y `sedes.csv` son las tablas de referencia.

| Problema en los datos | Dónde se resuelve |
| --- | --- |
| Espacios de más en el nombre y en los códigos | `02`, *String operations* |
| `sexo` escrito de 11 formas distintas (`F`, `f`, `Femenino`, `FEMENINO`, …) | `02`, *Value mapper* |
| Decimales con coma en parte de las filas (`9,45`) | `02`, *Replace in string* |
| `materias_aprobadas` o `promedio` vacíos | `02`, *Filter rows* → rechazos |
| Promedios imposibles (`45.50`, `87`) | `02`, *Filter rows* → rechazos |
| Filas duplicadas | `02`, *Sort rows* + *Unique rows* |
| `carrera_cod` que no existe en `carreras.csv` | `03`, *Filter rows* después del lookup |

### Los pipelines

| Pipeline | Qué muestra |
| --- | --- |
| `01-leer-y-escribir.hpl` | El pipeline más simple: leer un CSV, elegir columnas, escribir otro CSV. Sirve para presentar qué es un transform, qué es un hop, y la diferencia entre *preview* y *run*. |
| `02-limpiar.hpl` | La limpieza completa. Lo importante es el **Filter rows con dos salidas**: lo que pasa el filtro sigue, lo que no se escribe aparte en un archivo de rechazos. Un ETL no descarta filas en silencio. |
| `03-enriquecer.hpl` | Dos *Stream lookup* contra los CSV de referencia, y qué hacer con **lo que no matchea**: los cinco `carrera_cod` huérfanos no se pierden, van a su propio archivo. |
| `04-agregar.hpl` | Agregación por departamento y carrera. Muestra por qué **Group by exige la entrada ordenada**, y una división que si no se castea da entera (326/26 = 12 en vez de 12,54). |

Se encadenan por archivo, se puede ver en el workflow:

```
datos/inscripciones.csv
   └─02─▶ 02-inscripciones-limpias.csv  (186)   +  02-rechazos-limpieza.csv  (14)
             └─03─▶ 03-inscripciones-enriquecidas.csv  (181)  +  03-rechazos-lookup.csv  (5)
                       └─04─▶ 04-resumen-por-carrera.csv  (7)
```

### Pipeline y workflow no son lo mismo

- Un **pipeline** (`.hpl`) mueve **filas**. Todos los transforms arrancan a la vez y las
  filas los van atravesando; no hay un "paso 1, paso 2".
- Un **workflow** (`.hwf`) ejecuta **acciones en secuencia** y decide según el resultado de
  cada una. `etl-alumnos.hwf` corre los tres pipelines en orden y, si alguno falla, se va
  por la rama roja a *Cortar el proceso* en lugar de seguir con datos incompletos.

Para verlo fallar: renombrar `datos/inscripciones.csv` y ejecutá el workflow.