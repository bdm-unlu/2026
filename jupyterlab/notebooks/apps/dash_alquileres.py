"""Dashboard de alquileres temporarios en CABA con Dash + Bootstrap.

Correr desde la raíz del repo (bdm2026/):
    uv run --project jupyterlab python jupyterlab/notebooks/apps/dash_alquileres.py
y abrir http://localhost:8060
"""
from pathlib import Path

import dash_bootstrap_components as dbc
import pandas as pd
import plotly.express as px
from dash import Dash, Input, Output, callback, dcc, html

RAIZ = Path(__file__).resolve().parents[3]          # .../bdm2026
DATA = RAIZ / "TPs" / "TP01" / "data"

# ---------------------------------------------------------------- datos
alq = pd.read_csv(DATA / "alquileres.csv").dropna(subset=["precio_ars"])
p01, p99 = alq.precio_ars.quantile([0.01, 0.99])
alq = alq[alq.precio_ars.between(p01, p99)]
BARRIOS = alq.barrio.value_counts().head(15).index.tolist()
TIPOS = sorted(alq.tipo_habitacion.unique())


def tarjeta_kpi(titulo, id_valor):
    return dbc.Card(dbc.CardBody([html.Small(titulo, className="text-muted"),
                                  html.H3(id=id_valor, className="mb-0")]))


# ---------------------------------------------------------------- layout
controles = dbc.Card(dbc.CardBody([
    html.Label("Barrios"),
    dcc.Dropdown(id="barrios", options=BARRIOS, value=BARRIOS[:5], multi=True),
    html.Label("Tipo de habitación", className="mt-3"),
    dcc.Checklist(id="tipos", options=TIPOS, value=TIPOS,
                  inputStyle={"marginRight": "6px"}, labelStyle={"display": "block"}),
    html.Label("Precio por noche ($)", className="mt-3"),
    dcc.RangeSlider(id="precio", min=0, max=int(p99), step=10_000, value=[0, int(p99)],
                    marks=None, tooltip={"placement": "bottom", "always_visible": True}),
    dbc.Switch(id="super", label="Sólo superanfitriones", value=False, className="mt-3"),
]))

app = Dash(__name__, external_stylesheets=[dbc.themes.FLATLY])
app.title = "Alquileres CABA"

app.layout = dbc.Container([
    html.H2("Alquileres temporarios en CABA", className="my-3"),
    dbc.Row([
        dbc.Col(controles, md=3),
        dbc.Col([
            dbc.Row([
                dbc.Col(tarjeta_kpi("Publicaciones", "kpi-n")),
                dbc.Col(tarjeta_kpi("Precio mediano", "kpi-precio")),
                dbc.Col(tarjeta_kpi("Puntaje medio", "kpi-puntaje")),
            ], className="mb-3"),
            dbc.Tabs([
                dbc.Tab(dcc.Graph(id="g-box"), label="Precios"),
                dbc.Tab(dcc.Graph(id="g-mapa"), label="Mapa"),
                dbc.Tab(dcc.Graph(id="g-scatter"), label="Precio vs. puntaje"),
            ]),
        ], md=9),
    ]),
], fluid=True)


# ---------------------------------------------------------------- callbacks
@callback(
    Output("kpi-n", "children"), Output("kpi-precio", "children"),
    Output("kpi-puntaje", "children"),
    Output("g-box", "figure"), Output("g-mapa", "figure"), Output("g-scatter", "figure"),
    Input("barrios", "value"), Input("tipos", "value"),
    Input("precio", "value"), Input("super", "value"),
)
def actualizar(barrios, tipos, rango, solo_super):
    d = alq[alq.barrio.isin(barrios or []) & alq.tipo_habitacion.isin(tipos or [])
            & alq.precio_ars.between(*rango)]
    if solo_super:
        d = d[d.superanfitrion == "si"]

    box = px.box(d, x="barrio", y="precio_ars", color="tipo_habitacion", points=False,
                 labels={"precio_ars": "$ / noche"}, template="plotly_white")
    mapa = px.scatter_map(d.sample(min(len(d), 4000), random_state=2026),
                          lat="latitud", lon="longitud", color="precio_ars",
                          color_continuous_scale="Viridis", zoom=11.3, height=550,
                          map_style="carto-positron", hover_name="barrio")
    scatter = px.scatter(d, x="puntaje_resenias", y="precio_ars", color="barrio",
                         opacity=0.4, template="plotly_white",
                         labels={"precio_ars": "$ / noche", "puntaje_resenias": "puntaje"})

    if d.empty:
        return "0", "—", "—", box, mapa, scatter
    return (f"{len(d):,}", f"${d.precio_ars.median():,.0f}",
            f"{d.puntaje_resenias.mean():.2f}", box, mapa, scatter)


if __name__ == "__main__":
    app.run(debug=True, port=8060)
