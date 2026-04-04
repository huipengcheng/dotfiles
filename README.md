# Dotfiles

Personal Linux dotfiles managed with GNU Stow.

This repository is organized as modular packages. Most packages install into
`$HOME`, while `keyd` also contains a system-level package for `/etc/keyd`.

## Requirements

- Linux
- GNU Stow
- `rsync` (optional, used by `backup.sh` when available)
- `sudo` (required for system-level packages such as `keyd`)

Arch Linux is the primary target, but the layout is generic enough for other
Linux distributions.

## Quick Start

### Clone the Repository

```bash
git clone <repository-url> ~/dotfiles
cd ~/dotfiles
```

### Install Default Packages

```bash
./install.sh
```

### Install Selected Packages

```bash
./install.sh fish starship nvim
```

### Preview Changes

```bash
./install.sh --dry-run
```

`--dry-run` also previews package hooks when those hooks support dry-run mode.

### Verbose Mode

```bash
./install.sh --verbose
```

### Combined Example

```bash
./install.sh --dry-run --verbose fish git nvim
```

## Packages

The repository currently contains these packages:

| Package | Description |
|--------|-------------|
| `Qoder` | Qoder editor settings |
| `bash` | Bash configuration |
| `bat` | `bat` configuration |
| `bin` | Custom scripts in `~/.local/bin` |
| `chromium` | Chromium flags and related setup |
| `electron` | Electron flags and related setup |
| `fastfetch` | Fastfetch configuration |
| `fcitx5` | Fcitx5 configuration |
| `firefox` | Firefox `userChrome.css` template; install manually into the correct profile |
| `fish` | Fish shell configuration |
| `git` | Git configuration |
| `gtk` | GTK configuration |
| `hypr` | Hyprland configuration |
| `keyd` | Keyd configuration, including `/etc/keyd` |
| `kitty` | Kitty configuration |
| `nvim` | Neovim configuration in `~/.config/nvim` |
| `paru` | Paru configuration |
| `qtile` | Qtile configuration |
| `rime` | Rime configuration |
| `starship` | Starship prompt configuration |
| `stow` | User-level Stow config such as `~/.stow-global-ignore` |
| `waybar` | Waybar configuration |
| `wofi` | Wofi configuration |
| `x11` | X11 configuration |
| `zathura` | Zathura configuration |

### Default vs Manual Packages

`./install.sh` installs the packages listed in `DEFAULT_PACKAGES` inside
[`install.sh`](install.sh). `firefox` is intentionally excluded because Firefox
profile paths are machine-specific.

If you pass `firefox` to `install.sh`, the script still skips it and prints a
warning. That package is meant to be copied or linked manually into the correct
Firefox profile.

## Scripts

### `install.sh`

The main deployment script:

- Locates the repository from the script path instead of assuming `~/dotfiles`
- Runs `backup.sh` before deployment
- Supports package-level and global `pre_install.sh` / `post_install.sh` hooks
- Passes `DOTFILES_DRY_RUN=true` to hooks during `--dry-run`
- Uses Stow with `--no-folding` for user-level packages
- Validates every entry under `root/` before allowing system-level deployment
- Uses `sudo stow` for allowed system paths

Supported options:

- `--dry-run`
- `--verbose`, `-v`

### `backup.sh`

The backup script:

- Backs up these user-level targets when they exist:
  - `~/.config`
  - `~/.local/bin`
  - `~/.local/share/fcitx5/rime`
  - `~/.bashrc`
  - `~/.gitconfig`
  - `~/.xprofile`
- Writes backups to `~/backup/dotfiles/backup_<timestamp>/`
- Uses `rsync` when available, otherwise falls back to `cp -a`
- Keeps the most recent 50 backup directories
- Supports preview mode through `DOTFILES_DRY_RUN=true`

### `.stowrc`

The repository root contains [`.stowrc`](.stowrc), which provides Stow options
used during deployment from this repository. It currently ignores runtime and
backup artifacts such as:

- `*.bak`
- `*.lock`
- `*.log`
- `lazy-lock.json`

## Repository Layout

```text
dotfiles/
├── .stowrc
├── install.sh
├── backup.sh
├── <package>/
│   ├── .config/        # user-level config
│   ├── .local/         # user-level local data/scripts
│   ├── root/           # system-level config
│   ├── pre_install.sh  # optional package hook
│   └── post_install.sh # optional package hook
└── README.md
```

## System-Level Deployment

Only explicitly allowed system paths can be deployed. The current allowlist is:

- `/etc/keyd`

For packages with a `root/` directory, `install.sh`:

1. Validates the target path tree against the allowlist
2. Uses plain `stow -nv` in `--dry-run`
3. Uses `sudo stow` for the real deployment

If `/etc/keyd` already exists and conflicts with the managed layout, the script
does not migrate or back it up automatically. Resolve that conflict manually
before retrying.

If `/etc/keyd` does not exist, Stow will create the managed symlink during
installation.

## Hook Behavior

Supported hook locations:

- `pre_install.sh` in the repository root
- `post_install.sh` in the repository root
- `<package>/pre_install.sh`
- `<package>/post_install.sh`

During `--dry-run`, hooks receive:

```bash
DOTFILES_DRY_RUN=true
```

Other useful environment variables passed to hooks:

- `DOTFILES_DIR`
- `DOTFILES_PACKAGE`
- `DOTFILES_HOOK_NAME`
- `DOTFILES_VERBOSE`

## Package-Specific Notes

- `chromium` and `electron` use post-install hooks to manage
  `~/.config/*-flags.conf` based on whether the current session is Wayland.
- `nvim` now deploys directly to `~/.config/nvim`.
- `stow` is a regular package in this repository and can install
  `~/.stow-global-ignore`, but deployment-time ignore behavior is controlled by
  the repository-level `.stowrc`.
- `zathura` uses Git submodules for some theme directories.

Initialize submodules when needed:

```bash
git submodule update --init --recursive
```

## Uninstall

Remove a user-level package:

```bash
cd ~/dotfiles
stow -D <package-name>
```

Remove a system-level package:

```bash
sudo stow -d ~/dotfiles/<package> -t / -D root
```

For `chromium` and `electron`, hook-managed `*-flags.conf` files may still need
manual cleanup or restoration from backup after unstowing.

## License

See [LICENSE](LICENSE).
