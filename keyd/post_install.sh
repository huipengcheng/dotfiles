#!/usr/bin/env bash
set -euo pipefail

if [[ "${DOTFILES_DRY_RUN:-false}" == "true" ]]; then
  echo "[keyd] Would enable and restart the keyd service."
  exit 0
fi

echo "Enabling and restarting keyd service..."
sudo systemctl enable --now keyd
sudo systemctl restart keyd
