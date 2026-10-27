"""Dashboard de alquileres temporarios en CABA con Streamlit.

Correr desde la raíz del repo (bdm2026/):
    uv run --project jupyterlab streamlit run jupyterlab/notebooks/apps/streamlit_alquileres.py
"""
from pathlib import Path

import pandas as pd
import plotly.express as px
import streamlit as st

RAIZ = Path(__file__).resolve().parents[3]          # .../bdm2026
DATA = RAIZ / "TPs" / "TP01" / "data"

# Tiene que ser la primera llamada a st.* del script
st.set_page_config(page_title="Alquileres CABA", page_icon="🏠", layout="wide")


# ------------------------------------------------------------ datos (con caché)
@st.cache_data
def cargar():
    """Se ejecuta UNA vez; en los reruns siguientes devuelve el DataFrame guardado."""
    df = pd.read_csv(DATA / "alquileres.csv").dropna(subset=["precio_ars"])
    p01, p99 = df.precio_ars.quantile([0.01, 0.99])
    return df[df.precio_ars.between(p01, p99)]


alq = cargar()
BARRIOS = alq.barrio.value_counts().head(15).index.tolist()
TIPOS = sorted(alq.tipo_habitacion.unique())
PRECIO_MAX = int(alq.precio_ars.max())

# ------------------------------------------------------------ barra lateral
st.sidebar.header("Filtros")
barrios = st.sidebar.multiselect("Barrios", BARRIOS, default=BARRIOS[:5])
tipos = st.sidebar.multiselect("Tipo de habitación", TIPOS, default=TIPOS)
rango = st.sidebar.slider("Precio por noche ($)", 0, PRECIO_MAX, (0, PRECIO_MAX), step=10_000)
solo_super = st.sidebar.toggle("Sólo superanfitriones")

# ------------------------------------------------------------ filtrado
# Esto es pandas común: se recalcula en cada interacción, y está bien porque es rápido
d = alq[alq.barrio.isin(barrios) & alq.tipo_habitacion.isin(tipos)
        & alq.precio_ars.between(*rango)]
if solo_super:
    d = d[d.superanfitrion == "si"]

# ------------------------------------------------------------ página
st.title("🏠 Alquileres temporarios en CABA")

if d.empty:
    st.warning("Ninguna publicación cumple los filtros.")
    st.stop()                                         # corta la ejecución del script acá

c1, c2, c3 = st.columns(3)
c1.metric("Publicaciones", f"{len(d):,}")
c2.metric("Precio mediano", f"${d.precio_ars.median():,.0f}",
          delta=f"{d.precio_ars.median() / alq.precio_ars.median() - 1:+.0%} vs. CABA",
          delta_color="inverse")
c3.metric("Puntaje medio", f"{d.puntaje_resenias.mean():.2f}")

tab_precios, tab_mapa, tab_datos = st.tabs(["Precios", "Mapa", "Datos"])

with tab_precios:
    st.plotly_chart(
        px.box(d, x="barrio", y="precio_ars", color="tipo_habitacion", points=False,
               labels={"precio_ars": "$ / noche"}, template="plotly_white"),
        width="stretch")

with tab_mapa:
    st.plotly_chart(
        px.scatter_map(d.sample(min(len(d), 4000), random_state=2026),
                       lat="latitud", lon="longitud", color="precio_ars",
                       color_continuous_scale="Viridis", zoom=11.3, height=600,
                       map_style="carto-positron", hover_name="barrio"),
        width="stretch")

with tab_datos:
    st.dataframe(d, width="stretch", hide_index=True)
    st.download_button("Descargar CSV filtrado", d.to_csv(index=False).encode("utf-8"),
                       file_name="alquileres_filtrados.csv", mime="text/csv")

# ------------------------------------------------------------ el estado entre reruns
with st.expander("¿Por qué hace falta st.session_state?"):
    st.write("Cada botón provoca un rerun completo del script. Compará los dos contadores:")

    contador_comun = 0                                 # se reinicia en cada rerun
    if "contador" not in st.session_state:             # sólo la primera vez de la sesión
        st.session_state.contador = 0

    if st.button("Sumar 1"):
        contador_comun += 1
        st.session_state.contador += 1

    a, b = st.columns(2)
    a.metric("Variable común", contador_comun)
    b.metric("st.session_state", st.session_state.contador)
