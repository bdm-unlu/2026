# Apache Hop Web, con dos ajustes sobre la imagen oficial.
#
# 1. El proyecto por omision. Hop Web abre con el que diga "defaultProject" en
#    hop-config.json, y de fabrica ese es "default". Si no se cambia, la GUI
#    arranca en el proyecto equivocado, ${PROJECT_HOME} apunta a
#    config/projects/default y los pipelines fallan con "The pipeline path ...
#    is invalid". El arranque de la imagen registra el proyecto bdm, pero no lo
#    deja seleccionado.
#
# 2. El usuario. La imagen crea el usuario "hop" con UID 501 fijo, asi que todo
#    lo que se guarda en el bind mount de project/ queda con un owner que en el
#    host no le corresponde a nadie. El entrypoint de aca lo ajusta al arrancar
#    al dueño real de la carpeta, para que "docker-compose up" funcione en
#    cualquier maquina sin tener que pasarle variables de entorno.
FROM apache/hop-web:2.19.0

USER root

COPY entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod +x /usr/local/bin/entrypoint.sh \
 && /usr/local/tomcat/webapps/ROOT/hop-conf.sh --default-project=bdm

# Se arranca como root a proposito: el entrypoint necesita hacer usermod antes
# de bajar a "hop" con setpriv. Hop Web nunca llega a correr como root.
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/bin/bash", "/tmp/run-web.sh"]
