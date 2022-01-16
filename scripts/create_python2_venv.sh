#!/usr/bin/env bash

PROJECT_ROOT="$(git rev-parse --show-toplevel)"

echo "[+] Creating venv"
if [[ ! -d "${PROJECT_ROOT}/venv" ]]; then
    virtualenv "${PROJECT_ROOT}/venv"
else
    echo "[=] Venv exists - skipping"
fi

echo "[+] Activate venv"
source venv/bin/activate
env | grep -i VIRTUAL

echo "[+] Installing PIP packages"
pip install -r requirements.txt


# molecule init scenario --driver-name vagrant --verifier-name goss
