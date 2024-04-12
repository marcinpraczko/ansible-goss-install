#!/usr/bin/env bash

# set -eo

PROJECT_ROOT="$(git rev-parse --show-toplevel)"
VENV_NAME="venv"

echo "[+] Creating venv (python3)"
if [[ ! -d "${PROJECT_ROOT}/${VENV_NAME}" ]]; then
    python3 -m venv "${PROJECT_ROOT}/${VENV_NAME}"
else
    echo "[=] ${VENV_NAME} folder exists - skipping"
fi

echo "[+] Activate venv"
source ${VENV_NAME}/bin/activate
env | grep -i VIRTUAL

echo "[+] Upgrade PIP / Setuptools"
pip install -U pip setuptools wheel

requirements_file="${PROJECT_ROOT}/requirements.txt"
echo "[+] Installing PIP packages (for development)"
echo "[=] requirements file: ${requirements_file}"
pip install -r "${requirements_file}"
