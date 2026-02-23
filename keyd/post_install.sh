#!/usr/bin/env bash
set -e

echo "Enabling and starting keyd service..."
sudo systemctl enable --now keyd
sudo systemctl restart keyd
