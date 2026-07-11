#!/usr/bin/env bash
#
# One-line installer for this Emacs configuration.
#
#   curl -fsSL https://raw.githubusercontent.com/REPPL/emacs.d/main/install.sh | bash
#
# Clones the configuration into ~/.emacs.d (override with EMACS_D=/path).
# The result is a normal git clone, so you can pull updates and commit your
# own changes. If the target directory already exists you are asked what to
# do first — nothing is deleted without your consent.

set -euo pipefail

REPO_URL="${EMACS_D_REPO:-https://github.com/REPPL/emacs.d.git}"
TARGET="${EMACS_D:-$HOME/.emacs.d}"

say() { printf '%s\n' "$*"; }
err() { printf 'error: %s\n' "$*" >&2; }

# Prompts must read from the terminal: when this script is run via
# `curl ... | bash`, the shell's stdin is the script itself, not the
# keyboard. If no terminal is available (e.g. CI) the reply is empty, which
# every prompt below treats as "no" so nothing is overwritten.
ask() {
  local prompt="$1" reply=""
  # Only prompt if /dev/tty is actually usable for I/O, not merely present.
  if { : > /dev/tty; } 2>/dev/null; then
    printf '%s' "$prompt" > /dev/tty
    read -r reply < /dev/tty || reply=""
  fi
  printf '%s' "$reply"
}

command -v git >/dev/null 2>&1 || { err "git is required but not installed."; exit 1; }

if ! command -v emacs >/dev/null 2>&1; then
  say "note: Emacs is not on your PATH. Install it, then launch it after this finishes."
fi

if [ -e "$TARGET" ]; then
  # Already a clone of this configuration: offer to update in place. Match
  # the origin URL exactly (anchored), not by substring, so a lookalike
  # remote is not mistaken for this repo.
  origin_url=""
  [ -d "$TARGET/.git" ] && origin_url=$(git -C "$TARGET" remote get-url origin 2>/dev/null || true)
  case "$origin_url" in
    https://github.com/REPPL/emacs.d | https://github.com/REPPL/emacs.d.git | \
      git@github.com:REPPL/emacs.d | git@github.com:REPPL/emacs.d.git)
      case "$(ask "$TARGET already holds this configuration. Update it (git pull)? [y/N] ")" in
        y | Y) git -C "$TARGET" pull --ff-only; say "Updated."; exit 0 ;;
        *)     say "Cancelled; nothing changed."; exit 0 ;;
      esac
      ;;
  esac
  # Some other existing configuration: back it up or cancel. Never delete.
  case "$(ask "$TARGET already exists. Move it aside and install? [y/N] ")" in
    y | Y)
      backup="$TARGET.backup-$(date +%Y%m%d-%H%M%S)"
      [ -e "$backup" ] && backup="$backup-$$"
      mv -- "$TARGET" "$backup"
      say "Backed up existing configuration to $backup"
      ;;
    *) say "Cancelled; nothing changed."; exit 0 ;;
  esac
fi

git clone -- "$REPO_URL" "$TARGET"

say ""
say "Installed to $TARGET"
say "Launch Emacs — the first start tangles and byte-compiles the config"
say "(this takes a moment; later starts are fast)."
