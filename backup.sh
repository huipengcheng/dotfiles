#!/usr/bin/env bash
set -eo pipefail

CONFIG_DIR="$HOME/.config"
BACKUP_DIR="$HOME/backup/dotfiles/.config"
MAX_BACKUPS=50

log() { echo -e "\033[34m[BACKUP]\033[0m $*"; }

if [ ! -d "$BACKUP_DIR" ]; then
  mkdir -p "$BACKUP_DIR"
  log "Created backup directory at $BACKUP_DIR"
fi

date_suffix=$(date +%Y-%m-%d_%H-%M-%S)
backup_dir="$BACKUP_DIR/config_backup_$date_suffix"

if command -v rsync &> /dev/null; then
  log "Using rsync to backup configs..."
  rsync -aH --delete "$CONFIG_DIR/" "$backup_dir/"
else
  log "rsync not found, using cp..."
  cp -ra "$CONFIG_DIR" "$backup_dir"
fi

log "Successfully backed up to $backup_dir"

# Clean up old backups safely using array manipulation
backups=($(ls -1dt "$BACKUP_DIR"/config_backup_* 2>/dev/null || true))
if [ ${#backups[@]} -gt $MAX_BACKUPS ]; then
  excess=$((${#backups[@]} - MAX_BACKUPS))
  log "Removing $excess oldest backup(s) to maintain maximum of $MAX_BACKUPS..."
  
  # Delete items from index MAX_BACKUPS to the end of the array
  for old_backup in "${backups[@]:$MAX_BACKUPS}"; do
    rm -rf "$old_backup"
  done
fi
