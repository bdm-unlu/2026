# TRABAJO PRÁCTICO 03: Árboles de decisión

**Bases de Datos Masivas (11088)** — Departamento de Ciencias Básicas
2° Cuatrimestre 2026 — Universidad Nacional de Luján

## Introducción

En este trabajo práctico veremos cómo ajustar árboles de decisión y cómo funcionan los principales algoritmos a través de evaluar diferentes parámetros. En primer lugar, se utilizarán las nociones de entropía y ganancia de información introducidas en clase a efectos de entender cómo son los mecanismos para generar un árbol de decisión a partir de un dataset. Luego, se utilizará el lenguaje Python, puntualmente la librería Scikit-Learn.

Los tres conjuntos de datos se encuentran en la carpeta `data/` del directorio `TP03` en el repositorio GitHub del curso. En el [Anexo](#anexo-fuentes-y-descripción-de-los-conjuntos-de-datos) se detallan su origen, sus atributos y cómo fueron preparados. Tenga en cuenta que Scikit-Learn requiere atributos numéricos, por lo que los atributos categóricos deberán codificarse antes de generar los árboles.

## Consignas

1. Con el siguiente dataset (*parcial.csv*<sup>1</sup>), implementar en Python dos funciones, una que realice el cálculo de entropía y otra que calcule la ganancia de información. A partir de esas funciones genere el árbol de decisión para el dataset que se muestra a continuación:

   ```
   ASISTENCIA,TPS,TRABAJA,MODALIDAD,APRUEBA
   alta,completos,no,presencial,si
   alta,parciales,si,virtual,si
   alta,completos,si,presencial,si
   alta,parciales,no,virtual,si
   baja,completos,no,presencial,no
   baja,parciales,si,presencial,no
   baja,completos,si,virtual,no
   baja,parciales,no,virtual,no
   media,completos,si,presencial,si
   media,completos,no,virtual,si
   media,parciales,no,presencial,si
   media,parciales,si,virtual,no
   media,parciales,si,presencial,no
   media,completos,si,virtual,si
   ```

2. Trabaje con el dataset *gliomas.csv*<sup>2</sup>.

   a. Utilice la ficha del dataset en el repositorio de la UCI y el Anexo de este enunciado, ¿Cuál es el tema que aborda el dataset?

   b. Genere el árbol de decisión que permita clasificar el grado del tumor utilizando un muestreo con proporciones de 80% para entrenamiento y 20% para testeo.

   c. Explore la solución dada y las posibles configuraciones para obtener un nuevo árbol que clasifique “mejor”. Documente las conclusiones.

3. Trabaje con el dataset *asalariados_eph.csv*<sup>3</sup>, construido a partir de la Encuesta Permanente de Hogares del INDEC.

   a. Utilice el Anexo y el registro de diseño de la EPH para entender los datos, ¿Cuál es el tema que aborda el dataset?

   b. ¿Qué variable se debe modelar? ¿Cómo se distribuye? ¿Está balanceada?

   c. Genere el árbol de decisión que permita modelar la variable objetivo utilizando como criterio la entropía. Defina una estrategia de hold-out con proporciones de 80% para entrenamiento y 20% para testeo. Evalúe el resultado obtenido.

   d. Ahora, evalúe diferentes combinaciones de valores para los parámetros:

      i. `max_depth`

      ii. `min_samples_split`

      iii. `min_samples_leaf`

      iv. `max_leaf_nodes`

      Realice al menos 10 corridas y tabule las configuraciones con los respectivos resultados.

   e. Repita el experimento en d) agregando una validación cruzada con 5-folds.

   f. Documente las conclusiones.

## Referencias sugeridas:

Data Mining. Concepts & Techniques. Jiawei Han, Micheline Kamber & Jian Pei. 3ra ed. 2011. Capítulo 8.

Induction of Decision Trees. J. R. Quinlan. Machine Learning 1, 81–106. 1986.

Classification and Regression Trees. Leo Breiman, Jerome Friedman, Richard Olshen & Charles Stone. 1984.

Scikit-Learn: Decision Trees — https://scikit-learn.org/stable/modules/tree.html

---

## Anexo: fuentes y descripción de los conjuntos de datos

### <sup>1</sup> `parcial.csv` — *14 filas × 5 columnas*

Dataset didáctico construido por la cátedra para el cálculo manual del árbol. Los datos son ficticios.

- **Atributos:** `ASISTENCIA` (alta, media o baja); `TPS` (trabajos prácticos entregados: completos o parciales); `TRABAJA` (si/no); `MODALIDAD` (presencial o virtual); `APRUEBA` (clase: si/no).

### <sup>2</sup> `gliomas.csv` — *839 filas × 24 columnas*

Pacientes con diagnóstico de glioma del proyecto *The Cancer Genome Atlas* (TCGA), con sus datos clínicos y el estado de los 20 genes que mutan con mayor frecuencia en este tipo de tumor.

- **Fuente:** UCI Machine Learning Repository, *Glioma Grading Clinical and Mutation Features* (Tasci, Zhang, Tasci & Gonzalez, 2022; licencia CC BY 4.0) — https://archive.ics.uci.edu/dataset/759/glioma+grading+clinical+and+mutation+features+dataset (archivo `TCGA_InfoWithGrade.csv`).
- **Atributos:** `sexo`; `edad_diagnostico` (años, con decimales); `raza`; las columnas `IDH1`, `TP53`, `ATRX`, `PTEN`, `EGFR`, `CIC`, `MUC16`, `PIK3CA`, `NF1`, `PIK3R1`, `FUBP1`, `RB1`, `NOTCH1`, `BCOR`, `CSMD3`, `SMARCA4`, `GRIN2A`, `IDH2`, `FAT4` y `PDGFRA` (1 si el gen está mutado, 0 si no); `grado` (clase: LGG, glioma de bajo grado, o GBM, glioblastoma multiforme).
- **Preparación:** Se tradujeron los nombres de las columnas y se reemplazaron los códigos numéricos de `sexo`, `raza` y `grado` por sus etiquetas, según la documentación de la fuente. El dataset no tiene valores faltantes.

### <sup>3</sup> `asalariados_eph.csv` — *13.938 filas × 14 columnas*

Asalariados (obreros o empleados, incluido el servicio doméstico) relevados por la Encuesta Permanente de Hogares en los 32 aglomerados urbanos que cubre la base durante el primer trimestre de 2026. Cada fila es una persona encuestada; las filas no están expandidas por el ponderador, por lo que las proporciones del dataset no son estimaciones poblacionales.

- **Fuente:** INDEC, Encuesta Permanente de Hogares — https://www.indec.gob.ar/Institucional/Indec/BasesDeDatos (archivo `EPH_usu_1_Trim_2026_txt.zip`, base individual, y su registro de diseño `EPH_registro_1T2026.pdf`).
- **Atributos:**
  - `region` — región estadística (GBA, Noroeste, Noreste, Cuyo, Pampeana o Patagonia) [`REGION`].
  - `sexo` [`CH04`] y `edad` en años cumplidos [`CH06`].
  - `nivel_educativo` — máximo nivel alcanzado, de *Sin instrucción* a *Superior completo* [`NIVEL_ED`].
  - `sector` — si el lugar de trabajo es Estatal, Privado u Otro [`PP04A`].
  - `rama` — rama de actividad del establecimiento, agrupada a partir del clasificador CAES-Mercosur [`PP04B_COD`]. La categoría *Otras* reúne minería, electricidad, gas, agua, actividades inmobiliarias y organismos extraterritoriales.
  - `calificacion` — calificación de la ocupación según el Clasificador Nacional de Ocupaciones: Profesional, Técnica, Operativa o No calificada [quinto dígito de `PP04D_COD`].
  - `tamanio_establecimiento` — cantidad de personas que trabajan en el establecimiento, en tramos ordenados del 1 al 12: 1 a 5 = esa misma cantidad de personas; 6 = de 6 a 10; 7 = de 11 a 25; 8 = de 26 a 40; 9 = de 41 a 100; 10 = de 101 a 200; 11 = de 201 a 500; 12 = más de 500 [`PP04C`].
  - `lugar_trabajo` — dónde realiza principalmente sus tareas [`PP04G`].
  - `antiguedad` — tiempo en ese empleo en forma continua, de *Menos de 1 mes* a *Más de 5 años* [`PP07A`].
  - `empleo_temporario` — si el empleo tiene tiempo de finalización (si/no) [`PP07C`].
  - `horas_semanales` — horas trabajadas en la semana en la ocupación principal [`PP3E_TOT`].
  - `ingreso_mensual` — ingreso de la ocupación principal, en pesos corrientes [`P21`].
  - `informal` — **clase**: *si* cuando el asalariado no tiene descuento jubilatorio por ese trabajo, *no* cuando lo tiene [`PP07H`]. Es el criterio con el que el INDEC mide la informalidad de los asalariados.
- **Preparación:** Se seleccionaron los ocupados en relación de dependencia que respondieron la pregunta sobre descuento jubilatorio y se reemplazaron los códigos de las variables categóricas por sus etiquetas. Los códigos de no respuesta (9, 99, 999 y, en el ingreso, −9) se convirtieron en celdas vacías. Las preguntas del bloque “Ocupación principal” que el cuestionario no le hace al servicio doméstico en casas de familia quedaron vacías tal como en la fuente.

