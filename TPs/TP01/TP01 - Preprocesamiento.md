# TRABAJO PRÁCTICO 01: Preprocesamiento y transformación de datos

**Bases de Datos Masivas (11088)** — Departamento de Ciencias Básicas
2° Cuatrimestre 2026 — Universidad Nacional de Luján

## Introducción

En este trabajo práctico se abordan las cuestiones relacionadas con la selección de variables y reducción de dimensionalidad de un dataset a efectos de reconocer aquellos atributos que mejor lo representan.

Se plantean ejercicios y datasets cuyas resoluciones serán realizadas utilizando Pandas en Python.

Los cuatro conjuntos de datos se encuentran en la carpeta `data/` del directorio `TP01` en el repositorio GitHub del curso. En el [Anexo](#anexo-fuentes-y-descripción-de-los-conjuntos-de-datos) se detallan su origen, sus atributos y las unidades en que están expresados.

## Parte 1: Manejo de ruido, outliers y transformación de datos.

**Consignas:**

1. **Manejo de Ruido.** Para el siguiente dataset *calidad_aire.csv*[^1], que contiene mediciones horarias de tres contaminantes en tres estaciones de monitoreo, realice las siguientes operaciones:

   a. ¿Qué características tienen las variables? ¿Cómo se distribuyen las variables? Verifique gráficamente utilizando un gráfico QQ. ¿Qué puede decir sobre esas distribuciones?

   b. Realice un suavizado utilizando *binning* por *frecuencias iguales* y estime el valor del Bin por el cálculo de medias. Grafique las dos series resultantes y comente los resultados observados.

   c. Utilizando suavizado por extremos calcular los bins con *anchos iguales* de 2 a 10 y comparar los resultados gráficamente. ¿Qué ocurre conforme el bin aumenta?

   d. Encuentre un caso de aplicación de *binning*, consiga datos para probar un suavizado por *binning* con alguna de las variantes presentadas. Justifique la elección del conjunto de datos y comente en qué contribuye la técnica.

2. **Detección de outliers.** Utilizando el conjunto de datos *clima_smn.csv*[^2] analice los siguientes requerimientos:

   a. A partir de una primera exploración qué variables poseen observaciones que pueden etiquetarse como outliers.

   b. Analice las variables de manera gráfica utilizando boxplots.

   c. Verifique a cuántos desvíos de la media se encuentran las observaciones que se identificaron como outliers. ¿Hay relación con los criterios de identificación utilizados en los boxplots? Compare estos valores con los valores (bigotes) del boxplot.

   d. Analice si existen filas con outliers en más de una variable. Agregue una columna “CANT_OUT” al dataset que contabilice la cantidad de variables observadas como outliers en el dataset y realice al menos dos gráficos para ver dónde se ubican esos valores. ¿Qué puede comentar al respecto?

3. **Discretización.** A partir del dataset *clima_smn.csv*, opere sobre el atributo *humedad* de la siguiente manera:

   a. Transforme el atributo a discreto, definiendo 5 rangos de acuerdo al análisis de frecuencia de los valores encontrados para el atributo. ¿Qué tipo de variable se obtiene?

   b. Transforme el atributo a discreto, definiendo 5 rangos utilizando intervalos de clases.

   c. Transforme el atributo a discreto, utilizando percentiles cada 20%. Es decir, [0% a 20%), [20% a 40%), … etc

   d. Analice los resultados encontrados. Compare los mismos realizando gráficos de frecuencia sobre los intervalos resultantes en cada caso. ¿Qué conclusiones se pueden obtener en términos del balanceo de las mismas de acuerdo a la técnica utilizada? ¿Son consistentes todos los abordajes?

4. **Normalización.**

   **Entrada en calor**: [Papel y lápiz] Para el siguiente dominio:

   <p align="center">E = {1, 5, 9, 17, 18, 34, 45, 89, 99}</p>

   ¿Cuál sería el valor de escalado decimal para 65? ¿Y si utilizo mínimo-máximo?

   A partir del dataset *clima_smn.csv*, opere sobre los atributos ***temperatura*** y ***vel_viento*** de la siguiente manera:

   a. Normalice el atributo utilizando la técnica de mínimo-máximo.

   b. Ahora, normalice el atributo mediante la técnica de z-score.

   c. Por último, utilice la técnica de escalado decimal para llevar adelante la tarea de normalización.

   d. Analice los resultados encontrados. Compare los mismos realizando gráficos sobre los valores originales y además los atributos resultantes en cada caso.

   e. Repita el análisis utilizando boxplots y además el agrupamiento por la variable *temporada*. Compare los resultados obtenidos e indique qué ventajas tiene la comparación con las variables normalizadas.

## Parte 2: Manejo de datos faltantes y reducción de dimensionalidad

5. **Datos faltantes.** Identifique cuáles de las variables del dataset *alquileres.csv*[^3] poseen datos faltantes. Aplique los siguientes métodos a efectos de reemplazar esos valores:

   a. Analice el tipo de faltante. ¿Qué puede decir sobre eso?

   b. Sustituya los valores faltantes por una medida de tendencia central según corresponda.

   c. Sustituya los valores faltantes de acuerdo al método de “hot deck imputation”.

   d. Implemente una función *hot_deck* en python siguiendo el criterio explicado en clase de hot deck y compare los resultados obtenidos con los del módulo KNNImputer de Sklearn. Defina el criterio de similitud que crea adecuado para el dataset *alquileres.csv*

   e. Sustituya los valores faltantes realizando una imputación por regresión.

   f. Analice los resultados encontrados a partir de la aplicación de los métodos anteriores. Compare los mismos realizando gráficos sobre los valores resultantes en cada caso.

6. **Análisis de Componentes Principales.** Cargue el dataset *vehiculos.csv*[^4] y conteste las siguientes consignas:

   a. Calcule la matriz de covarianzas. ¿Qué nos indica la misma sobre los atributos del dataset?

   b. Realice ahora el análisis de componentes principales. ¿Cuánto explica de la variación total del dataset la primera componente? ¿Y si se incorpora la segunda? ¿Y el primer auto-valor?

   c. Grafique el perfil de variación de las componentes en un gráfico de dispersión donde las X es la varianza y la Y el componente.

   d. Analice la matriz de *loading*. ¿Qué información provee? ¿Qué variables están más correlacionadas con la primera componente?

   e. Genere un gráfico de *biplot* y explique brevemente qué información le provee el mismo.

   f. En función de los análisis realizados en los puntos anteriores. ¿Cuántas componentes principales elegiría para explicar el comportamiento del dataset? Justifique esa cantidad.

## Referencias sugeridas:

Principal component analysis. Hervé Adbi & otros. 2010.

Data mining and the impact of missing data. Marvin L. Brown & otros. 2003.

Data Mining. Concepts & Techniques. Jiawei Han and Micheline Kamber. 2006.

---

## Anexo: fuentes y descripción de los conjuntos de datos

### <sup>1</sup> `calidad_aire.csv` — *5.484 filas × 11 columnas*

Registros horarios de la red de monitoreo atmosférico de la Ciudad de Buenos Aires, de enero a agosto de 2026.

- **Fuente:** Agencia de Protección Ambiental, GCBA — https://data.buenosaires.gob.ar/dataset/calidad-aire (recurso “2026 Calidad del Aire”).
- **Atributos:** `fecha`; `hora` (0 a 23); y, para cada estación de monitoreo (Centenario, Córdoba y La Boca), las columnas `co_*` (monóxido de carbono, ppm), `no2_*` (dióxido de nitrógeno, ppb) y `pm10_*` (material particulado menor a 10 µm, µg/m³).
- **Preparación:** Se ordenaron los registros por fecha y hora, se descartaron las columnas de la estación Palermo (sin datos en el período) y se reemplazó el literal “s/d” por celda vacía. Los faltantes se conservaron.

### <sup>2</sup> `clima_smn.csv` — *23.019 filas × 9 columnas*

Observaciones horarias de superficie en 40 estaciones del país y de la Antártida, correspondientes a los días 10 y 20 de cada mes entre septiembre de 2025 y agosto de 2026.

- **Fuente:** Servicio Meteorológico Nacional — https://www.smn.gob.ar/descarga-de-datos (archivos `datohorarioAAAAMMDD.txt`).
- **Atributos:** `fecha`; `hora`; `estacion_meteorologica`; `temporada` (Verano, Otoño, Invierno o Primavera, según el hemisferio sur); `temperatura` (°C); `humedad` (humedad relativa, %); `presion` (presión reducida al nivel del mar, hPa); `dir_viento` (dirección del viento, en grados); `vel_viento` (velocidad del viento, km/h).
- **Preparación:** Se convirtieron los archivos de ancho fijo a CSV, se conservaron las estaciones con cobertura completa del período y se derivó la columna `temporada` a partir del mes. No se alteraron los valores informados por el organismo.

### <sup>3</sup> `alquileres.csv` — *29.438 filas × 16 columnas*

Avisos de alquiler temporario publicados para la Ciudad de Buenos Aires, relevados el 24 de julio de 2026.

- **Fuente:** Inside Airbnb — https://insideairbnb.com/get-the-data/ (Buenos Aires, `listings.csv.gz`).
- **Atributos:** `id`; `barrio`; `tipo_propiedad`; `tipo_habitacion`; `capacidad` (cantidad de personas); `banios`; `dormitorios`; `camas`; `precio_ars` (precio por noche, en pesos); `minimo_noches`; `cantidad_resenias`; `puntaje_resenias` (puntaje promedio, de 1 a 5); `superanfitrion` (si/no); `latitud`; `longitud`; `noches_ocupadas_anio` (ocupación estimada en los últimos 365 días).
- **Preparación:** Se seleccionó un subconjunto de columnas y se tradujeron sus nombres, se convirtió el precio a valor numérico y se descartaron 171 avisos con precios superiores a $1.500.000 por noche. Los datos faltantes originales se conservaron sin modificación.

### <sup>4</sup> `vehiculos.csv` — *2.809 filas × 17 columnas*

Ficha oficial de consumo y emisiones de los modelos 2024 a 2026 comercializados en los Estados Unidos.

- **Fuente:** U.S. Environmental Protection Agency / Department of Energy — https://www.fueleconomy.gov/feg/download.shtml (archivo `vehicles.csv`).
- **Atributos:** `marca`; `modelo`; `anio`; `clase`; `traccion`; `combustible`; `transmision`; `cilindros`; `cilindrada` (litros); `mpg_ciudad`, `mpg_ruta` y `mpg_combinado` (rendimiento en millas por galón); `co2_g_milla` (gramos de CO₂ por milla); `barriles_anio` (barriles de petróleo consumidos por año); `costo_combustible_anio` (USD por año); `puntaje_gei` (índice de gases de efecto invernadero, de 1 a 10); `ahorro_5anios` (ahorro —o sobrecosto, si es negativo— en USD a cinco años respecto del vehículo promedio).
- **Preparación:** Se filtraron los modelos 2024 a 2026, se excluyeron los vehículos exclusivamente eléctricos (no informan cilindrada ni cantidad de cilindros, y su rendimiento se expresa en MPGe, no comparable con el de un motor de combustión) y se tradujeron los nombres de las columnas.

[^1]: https://data.buenosaires.gob.ar/dataset/calidad-aire
[^2]: https://www.smn.gob.ar/descarga-de-datos
[^3]: https://insideairbnb.com/get-the-data/
[^4]: https://www.fueleconomy.gov/feg/download.shtml
