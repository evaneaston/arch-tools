#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
. "${SCRIPT_DIR}/../common.sh"

installAurPackages rate-mirrors

USER=$(id -un)
GROUP=$(id -gn)

for file in ${SCRIPT_DIR}/*.{timer,service} ; do
    echo "Installing ${file}"
    sed -e "s:%USER%:${USER}:g" -e "s:%GROUP%:${GROUP}:g" "${file}" | sudo tee "/etc/systemd/system/$(basename ${file})" >/dev/null
done
sudo systemctl daemon-reload
sudo systemctl enable --now "rate-mirrors.timer"



