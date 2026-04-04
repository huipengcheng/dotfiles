#!/usr/bin/env bash
set -euo pipefail

DRYRUN="${DOTFILES_DRY_RUN:-false}"
BACKUP_ROOT="$HOME/backup/dotfiles"
MAX_BACKUPS=50
BACKUP_TARGETS=(
  ".config"
  ".local/bin"
  ".local/share/fcitx5/rime"
  ".bashrc"
  ".gitconfig"
  ".xprofile"
)

date_suffix="$(date +%Y-%m-%d_%H-%M-%S)"
backup_dir="$BACKUP_ROOT/backup_$date_suffix"

log() { echo -e "\033[34m[BACKUP]\033[0m $*"; }

backup_target() {
  local relative_path="$1"
  local source_path="$HOME/$relative_path"
  local destination_path="$backup_dir/$relative_path"

  if [[ ! -e "$source_path" && ! -L "$source_path" ]]; then
    return 0
  fi

  if [[ "$DRYRUN" == "true" ]]; then
    log "Would back up $source_path to $destination_path"
    return 0
  fi

  mkdir -p "$(dirname "$destination_path")"

  if command -v rsync >/dev/null 2>&1; then
    if [[ -d "$source_path" && ! -L "$source_path" ]]; then
      mkdir -p "$destination_path"
      rsync -aH "$source_path/" "$destination_path/"
    else
      rsync -aH "$source_path" "$destination_path"
    fi
  else
    cp -a "$source_path" "$destination_path"
  fi

  log "Backed up $source_path to $destination_path"
}

cleanup_old_backups() {
  local backups=()
  local excess=0
  local old_backup=""

  if [[ "$DRYRUN" == "true" ]]; then
    log "Would keep the latest $MAX_BACKUPS backup directories under $BACKUP_ROOT"
    return 0
  fi

  mapfile -t backups < <(ls -1dt "$BACKUP_ROOT"/backup_* 2>/dev/null || true)
  if [[ ${#backups[@]} -le $MAX_BACKUPS ]]; then
    return 0
  fi

  excess=$((${#backups[@]} - MAX_BACKUPS))
  log "Removing $excess oldest backup(s) to maintain maximum of $MAX_BACKUPS..."

  for old_backup in "${backups[@]:$MAX_BACKUPS}"; do
    rm -rf "$old_backup"
  done
}

for target in "${BACKUP_TARGETS[@]}"; do
  backup_target "$target"
done

cleanup_old_backups
