#!/usr/bin/env bash
set -e

CONFIG_DIR="$HOME/.config"
BACKUP_DIR="$HOME/backup/dotfiles/.config"
MAX_BACKUPS=50

if [ ! -d "$BACKUP_DIR" ]; then
  mkdir -p "$BACKUP_DIR"
  echo "Created backup directory at $BACKUP_DIR"
fi

backup() {
  local date_suffix=$(date +%Y-%m-%d_%H-%M-%S)
  local backup_dir="$BACKUP_DIR/config_backup_$date_suffix"

  if command -v rsync &> /dev/null; then
    echo "Using rsync for backup..."
    rsync -aH "$CONFIG_DIR/" "$backup_dir/"
  else
    echo "rsync not found, using cp for backup..."
    cp -ra "$CONFIG_DIR" "$backup_dir"
  fi

  echo "Backed up $CONFIG_DIR to $backup_dir"

  local backups=($(ls -d $BACKUP_DIR/config_backup_*))
  if [ ${#backups[@]} -gt $MAX_BACKUPS ]; then
    local excess=$((${#backups[@]} - $MAX_BACKUPS))
    echo "Removing $excess old backup(s)"
    rm -rf "${backups[@]:0:$excess}"
  fi
}

backup

