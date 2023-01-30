#!/usr/bin/env bash

# DO NOT EDIT
# Generated by bin/generate_files
set -ex

function main() {
  local user_name=${USER_NAME:-user}

  if [ ! -d "${HOME}" ]; then
    mkdir -p "${HOME}"
  fi

  if ! whoami &> /dev/null; then
    if [ -w /etc/passwd ]; then
      echo "${user_name}:x:$(id -u):0:${user_name} user:${HOME}:/bin/bash" >> /etc/passwd
      echo "${user_name}:x:$(id -u):" >> /etc/group
      echo "${user_name}:!:$(expr $(date +%s) / 86400):0:99999:7:::" >> /etc/shadow
    fi
  fi

  sudo chown -R $(id -u) "${HOME}"

  Xvfb :0 -screen 0 ${XVFB_SCREEN_WHD:-1280x800x24} &
  x11vnc -forever -shared -noxrecord &
  /novnc/novnc/utils/novnc_proxy --vnc localhost:5900 --listen ${NOVNC_LISTEN_PORT:-6080}
}

main

exec "$@"