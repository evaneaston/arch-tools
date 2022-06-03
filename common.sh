#!/usr/bin/env bash
set -euo pipefail

exec 5>/dev/null

enableVerboseOutput() {
    exec 5>&1
}
[[ ${DEBUG:-} == true ]] && enableVerboseOutput

ensureYayInstalled() {    
    if which yay > /dev/null ; then
        echo "Prerequisite yay is present."
    else
        echo "Yay is not installed.  Installing it."

        echo "Making sure git and base-dev are installed" >&5
        sudo pacman -S --needed git base-devel

        BUILD_YAY_DIR="${SCRIPT_DIR}/.yay"
        [ -d "${BUILD_YAY_DIR}" ] && rm -rf "${BUILD_YAY_DIR}"
        git clone https://aur.archlinux.org/yay.git "${BUILD_YAY_DIR}"
        cd "${BUILD_YAY_DIR}" ; makepkg -si
        cd "${SCRIPT_DIR}"
        rm -rf "${BUILD_YAY_DIR}"
    fi 
}

installPackages() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: ${SCRIPT_FULL_PATH} <package-names-space-separated>"
        exit 1
    fi

    # install or update the provided packages
    sudo pacman -S --needed "$@"
}

installAurPackages() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: ${SCRIPT_FULL_PATH} <package-names-space-separated>"
        exit 1
    fi
}
