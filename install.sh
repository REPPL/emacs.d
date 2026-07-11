#!/usr/bin/env bash
#
# One-line installer for this Emacs configuration.
#
#   curl -fsSL https://raw.githubusercontent.com/REPPL/emacs.d/main/install.sh | bash
#
# Clones the configuration into ~/.emacs.d (override with EMACS_D=/path).
# The result is a normal git clone, so you can pull updates and commit your
# own changes. If the target directory already exists you are asked what to
# do first — nothing is deleted without your consent. After installing, it
# offers to install the optional tools the configuration can use (pandoc,
# aspell, pipx, the Python language server), each only if it is missing.

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

# Offer to install an optional tool if its binary ($1) is missing. The
# remaining args are the install command, run directly (never eval'd) and
# only after an explicit y. A no/empty reply skips it.
dep_prompt() {
  local bin="$1" label="$2"; shift 2
  command -v "$bin" >/dev/null 2>&1 && return 0
  case "$(ask "Install $label? [y/N] ")" in
    y | Y) "$@" || err "install of $label failed (continuing).";;
    *) : ;;
  esac
}

# Offer the optional tools the configuration can use, each only if absent.
# System tools come from Homebrew; the Python language server from pipx.
offer_optional_deps() {
  say ""
  say "Optional tools this configuration can use:"
  if command -v brew >/dev/null 2>&1; then
    dep_prompt pandoc "pandoc (Markdown export)"          brew install pandoc
    dep_prompt aspell "aspell (spell-checking)"           brew install aspell
    dep_prompt pipx   "pipx (installs the Python server)" brew install pipx
  else
    say "  Homebrew not found — skipping pandoc/aspell/pipx."
    say "  Install Homebrew (https://brew.sh), or run M-x ar-setup-wizard inside Emacs."
  fi
  # pylsp is installed with pipx; only offer it once pipx is available.
  if command -v pipx >/dev/null 2>&1; then
    dep_prompt pylsp "python-lsp-server (Python LSP)" pipx install "python-lsp-server[all]"
  fi
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
        y | Y) git -C "$TARGET" pull --ff-only; say "Updated."; offer_optional_deps; exit 0 ;;
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

offer_optional_deps

say ""
say "Launch Emacs — the first start tangles and byte-compiles the config"
say "(this takes a moment; later starts are fast)."
