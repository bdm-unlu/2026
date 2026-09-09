#!/usr/bin/env bash
#
# Ajusta el usuario interno del contenedor al dueño de la carpeta project/
# montada desde el host, y recien ahi arranca Hop Web.
#
# El problema que resuelve: la imagen oficial crea el usuario "hop" con UID 501
# fijo. Como project/ es un bind mount, todo lo que Hop Web guarda ahi (los
# pipelines que edita el alumno, los CSV de salida) queda con owner 501 y
# permisos 640, y desde el host no se puede ni leer. Detectando el UID en el
# arranque, "docker-compose up" funciona en cualquier maquina sin que haya que
# pasarle variables de entorno.
#
set -euo pipefail

PROYECTO="${HOP_PROJECT_FOLDER:-/project}"

log() { echo "$(date '+%Y/%m/%d %H:%M:%S') - entrypoint - $1"; }

if [ ! -d "$PROYECTO" ]; then
  log "ERROR: no existe $PROYECTO. Falta el volumen en el docker-compose.yml."
  exit 9
fi

uid_destino=$(stat -c %u "$PROYECTO")
gid_destino=$(stat -c %g "$PROYECTO")
uid_actual=$(id -u hop)
gid_actual=$(id -g hop)

# uid 0 = Docker Desktop (Windows y macOS): ahi el runtime traduce los permisos
# solo y no hay nada que ajustar. Tampoco se corre Hop como root, obviamente.
if [ "$uid_destino" -eq 0 ]; then
  log "$PROYECTO pertenece a root: es Docker Desktop o un montaje traducido, se deja el usuario como esta"
elif [ "$uid_destino" != "$uid_actual" ] || [ "$gid_destino" != "$gid_actual" ]; then
  log "Ajustando el usuario hop de ${uid_actual}:${gid_actual} a ${uid_destino}:${gid_destino} (dueño de $PROYECTO)"
  groupmod -o -g "$gid_destino" hop
  usermod  -o -u "$uid_destino" -g "$gid_destino" hop

  # Las rutas que Tomcat y Hop necesitan escribir. NO se chownea
  # /usr/local/tomcat entero: son ~2 GB y el resto alcanza con poder leerlo.
  #   config/ -> hop-conf.sh reescribe hop-config.json al registrar el proyecto
  #   audit/  -> es donde apunta HOP_AUDIT_FOLDER
  #   webapps/ROOT (sin -R) -> RAP crea ahi adentro su carpeta rwt-resources al
  #     desplegar; sin permiso el webapp no arranca y Tomcat se reinicia en loop
  chown hop:hop /usr/local/tomcat/webapps/ROOT
  chown -R hop:hop \
    /usr/local/tomcat/webapps/ROOT/config \
    /usr/local/tomcat/webapps/ROOT/audit \
    /usr/local/tomcat/work \
    /usr/local/tomcat/temp \
    /usr/local/tomcat/logs \
    /usr/local/tomcat/conf \
    /home/hop
else
  log "El usuario hop ya coincide con el dueño de $PROYECTO (${uid_destino}:${gid_destino})"
fi

# exec y no una subshell: run-web.sh atrapa SIGTERM para frenar Tomcat con
# gracia, asi que tiene que quedar como PID 1 y recibir las señales del docker.
exec setpriv --reuid=hop --regid=hop --init-groups "$@"
