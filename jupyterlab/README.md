# Entorno JupyterLab con uv

Entorno de trabajo de la materia. Reemplaza al contenedor Docker de años anteriores: en
lugar de construir una imagen, se usa [uv](https://docs.astral.sh/uv/) para crear un
entorno virtual local con todas las librerías de la cursada y levantar JupyterLab.

La ventaja es que uv resuelve e instala las dependencias en segundos y garantiza que todos
tengamos exactamente las mismas versiones, porque quedan congeladas en `uv.lock`.

---

## 1. Instalar uv

### Linux / macOS

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

Cerrar y volver a abrir la terminal (el instalador agrega `~/.local/bin` al `PATH`).

### Windows (PowerShell)

```powershell
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
```

### Alternativas

```bash
pipx install uv        # si ya usan pipx
brew install uv        # macOS con Homebrew
winget install astral-sh.uv   # Windows con winget
```

### Verificar la instalación

```bash
uv --version
```

Tiene que responder algo como `uv 0.8.13` o superior.

> **No hace falta instalar Python.** El proyecto pide Python 3.12 o 3.13 y, si no lo
> encuentran en el sistema, uv lo descarga solo.

---

## 2. Crear el entorno

Desde **esta** carpeta (`jupyterlab/`):

```bash
uv sync
```

Esto ejecuta lo siguiente:

1. Crea el entorno virtual en `.venv/`.
2. Descarga el intérprete de Python si es necesario.
3. Instala las librerías con las versiones exactas de `uv.lock`.

La primera vez descarga cerca de 1,8 GB y tarda unos minutos. Las siguientes son casi
instantáneas porque uv reutiliza su caché.

No hace falta activar el entorno a mano: todo se ejecuta con `uv run`.

---

## 3. Levantar JupyterLab

Desde la raíz del repositorio (`bdm2026/`), para tener a mano también los TPs:

```bash
uv run --project jupyterlab jupyter lab
```

Abre el navegador solo. Si no lo hace, entrar a la URL que imprime la consola, del estilo:

```
http://localhost:8888/lab?token=...
```

Para bajarlo: `Ctrl+C` en la terminal.

### Por qué desde la raíz y no desde `jupyterlab/`

El navegador de archivos de JupyterLab **no puede subir por encima de la carpeta donde se
lo levantó**. Si se lo arranca dentro de `jupyterlab/`, se ven sólo `data/` y `notebooks/`,
y las carpetas `TPs/` y `Guias de Lectura/` quedan inaccesibles.

Arrancando desde la raíz del repositorio se ve todo el árbol. Si ya están dentro de
`jupyterlab/`, el equivalente es:

```bash
uv run jupyter lab --notebook-dir=..
```

### Variantes útiles

```bash
# Otro puerto, si el 8888 está ocupado
uv run --project jupyterlab jupyter lab --port 8899

# Sin abrir el navegador automáticamente
uv run --project jupyterlab jupyter lab --no-browser

# La interfaz clásica de notebook en lugar de Lab
uv run --project jupyterlab jupyter notebook
```

Al crear un notebook hay que elegir el kernel **Python 3 (ipykernel)**, que ya apunta al
intérprete de `.venv`. No hay que registrar nada.

---

## 4. Estructura de carpetas

```
bdm2026/                   <- raíz del repo: acá se levanta JupyterLab
├── TPs/                   <- enunciados, notebooks y datasets de los TPs
├── Guias de Lectura/
└── jupyterlab/
    ├── README.md          <- este archivo
    ├── pyproject.toml     <- lista de librerías de la materia
    ├── uv.lock            <- versiones exactas (no editar a mano)
    ├── data/              <- datasets propios
    ├── notebooks/         <- notebooks propios
    └── .venv/             <- entorno virtual (lo genera uv, no se sube al repo)
```

Las rutas dentro de un notebook son relativas **a la ubicación del notebook**, no a la
carpeta desde donde se levantó JupyterLab:

```python
import pandas as pd
df = pd.read_csv("../data/penguins.csv")   # desde jupyterlab/notebooks/
df = pd.read_csv("data/penguins.csv")      # desde TPs/TP00/
```

---

## 5. Librerías incluidas

| Grupo | Paquetes |
| --- | --- |
| Notebooks | `jupyterlab`, `ipykernel`, `ipywidgets`, `nbconvert` |
| Datos | `pandas`, `numpy`, `scipy`, `numexpr`, `pyarrow`, `openpyxl` |
| Visualización | `matplotlib`, `seaborn`, `missingno`, `plotly`, `pyecharts` |
| Estadística y ML | `scikit-learn`, `statsmodels`, `xgboost`, `shap`, `prince`, `pca`, `mlxtend`, `graphviz` |
| Geoespacial | `geopandas`, `geopy`, `geoplot`, `folium`, `shapely`, `fiona`, `pyproj` |
| Dashboards | `dash`, `dash-bootstrap-components`, `streamlit`, `streamlit-folium` |
| Acceso a datos | `sqlalchemy`, `psycopg[binary]`, `requests`, `python-dotenv` |

### Agregar o quitar librerías

```bash
uv add nombre-del-paquete       # agrega y actualiza pyproject.toml + uv.lock
uv remove nombre-del-paquete    # la saca
uv lock --upgrade               # actualiza todas a la última versión compatible
```

---

## 6. Problemas frecuentes

**`uv: command not found` después de instalarlo**
Cerrar y volver a abrir la terminal. Si persiste, agregar `export PATH="$HOME/.local/bin:$PATH"`
al `~/.bashrc` (o `~/.zshrc`).

**No veo la carpeta `TPs/` en el navegador de archivos**
Levantaron JupyterLab dentro de `jupyterlab/`. Bajarlo y volver a levantarlo desde la raíz
del repo, o agregar `--notebook-dir=..`.

**`Port 8888 is already in use`**
Hay otro Jupyter corriendo. Levantarlo en otro puerto: `uv run jupyter lab --port 8899`.

**Aviso `VIRTUAL_ENV=... does not match the project environment path`**
Tienen activado el entorno virtual de otro proyecto en esa terminal. Es sólo un aviso: uv
usa el `.venv` de esta carpeta igual. Para que no aparezca, correr `deactivate` antes.

**Los gráficos de `graphviz` no se renderizan**
El paquete de Python es un wrapper: hace falta el binario del sistema.

```bash
sudo apt install graphviz     # Debian / Ubuntu
brew install graphviz         # macOS
```

En Windows conviene instalarlo desde https://graphviz.org/download/ y marcar la opción de
agregarlo al `PATH`.

**Reconstruir entorno**

```bash
rm -rf .venv
uv sync
```