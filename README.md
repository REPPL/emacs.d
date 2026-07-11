
# emacs.d

![Built with Org](https://img.shields.io/badge/Built%20with-Org%20Mode-77aa99?logo=org&logoColor=white)
![macOS](https://img.shields.io/badge/macOS-Supported-000000?logo=apple&logoColor=white)
![Maintained](https://img.shields.io/badge/Maintained%3F-yes-green.svg)
![Created with Claude Code](https://img.shields.io/badge/Created%20with-Claude%20Code-8B5CF6)

My personal Emacs configuration.

![](./docs/img/screenshot.png)

## Installation

### One-line install (recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/REPPL/emacs.d/main/install.sh | bash
```

This clones the configuration into `~/.emacs.d` as a git repository, so you can pull updates and commit your own changes. If `~/.emacs.d` already exists you are asked what to do first — nothing is deleted without your consent (an existing configuration is moved to `~/.emacs.d.backup-<timestamp>`; if `~/.emacs.d` is already this configuration, you are offered a `git pull` instead). To install somewhere else, set `EMACS_D`:

```bash
curl -fsSL https://raw.githubusercontent.com/REPPL/emacs.d/main/install.sh | EMACS_D=~/my-emacs bash
```

### Manual install

```bash
# Back up any existing configuration first
mv ~/.emacs.d ~/.emacs.d.backup

# Clone directly to ~/.emacs.d
git clone https://github.com/REPPL/emacs.d.git ~/.emacs.d
```

### First Launch

When you first start Emacs with this configuration:

1. **Package installation** - Emacs automatically installs `use-package` and the packages declared in `inits/repp.org`, creating the `elpa/` directory.

2. **Tangle and compile** - The config is tangled from `inits/repp.org` to `inits/repp.el` and byte-compiled. The first launch takes a moment whilst packages download and the config compiles; later launches load the compiled config directly and are fast.

3. **Restart Emacs** - After packages install, restart once so everything loads cleanly.

4. **Optional setup wizard** - This configuration runs as a fast editor out of the box. Python and other language tooling load only when needed. If some optional system tools are missing, a single passive note points you at `M-x ar-setup-wizard`; it never blocks startup. The wizard installs missing tools (Python LSP via [pipx](https://pipx.pypa.io/), linters, a default Python venv), asking y/n for each — nothing installs without confirmation. It writes `.setup-done` in your Emacs directory once every category is complete; delete that file (or run with `C-u`) to re-run.

### What Gets Auto-Generated

These directories/files are created automatically and should not be committed:

- `elpa/` - Package installation directory
- `eln-cache/` - Native-compiled code
- `auto-save-list/` - Auto-save files
- `recentf` - Recent files list
- `projectile-bookmarks.eld` - Project bookmarks
- `.lsp-session-v1` - LSP session data
- `tramp`, `transient/`, `eshell/`, `tree-sitter/` - Runtime data
- `inits/repp.el` and `inits/repp.elc` - Tangled and byte-compiled from `repp.org`

### Core Configuration Files

The essential files you need are:

- `init.el` - Main initialisation file
- `inits/custom.el` - Custom variables
- `inits/repp.org` - Main configuration (loaded via org-babel)

## Troubleshooting

For installation and compilation issues, see [docs/troubleshooting/](docs/troubleshooting/).
