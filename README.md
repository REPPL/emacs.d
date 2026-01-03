
# emacs.d

![Built with Org](https://img.shields.io/badge/Built%20with-Org%20Mode-77aa99?logo=org&logoColor=white)
![macOS](https://img.shields.io/badge/macOS-Supported-000000?logo=apple&logoColor=white)
![Maintained](https://img.shields.io/badge/Maintained%3F-yes-green.svg)
![Created with Claude Code](https://img.shields.io/badge/Created%20with-Claude%20Code-8B5CF6)

My personal Emacs configuration.

![](./docs/img/screenshot.png)

## Installation

### Option 1: Symbolic Link (Recommended)

This allows you to keep the configuration in version control whilst using it as your Emacs configuration:

```bash
# Clone the repository
git clone https://github.com/REPPL/emacs.d.git ~/path/to/emacs.d

# Back up existing configuration (if any)
mv ~/.emacs.d ~/.emacs.d.backup

# Create symbolic link
ln -s ~/path/to/emacs.d ~/.emacs.d
```

### Option 2: Direct Copy

```bash
# Back up existing configuration (if any)
mv ~/.emacs.d ~/.emacs.d.backup

# Clone directly to ~/.emacs.d
git clone https://github.com/REPPL/emacs.d.git ~/.emacs.d
```

### First Launch

When you first start Emacs with this configuration:

1. **Package installation** - Emacs will automatically:
   - Install `use-package` if not already present
   - Download and install packages defined in `inits/repp.org`
   - Create the `elpa/` directory for packages

2. **Wait for completion** - The first launch may take a few minutes whilst packages download

3. **Restart Emacs** - After packages install, restart Emacs to ensure everything loads correctly

### What Gets Auto-Generated

These directories/files are created automatically and should not be committed:

- `elpa/` - Package installation directory
- `auto-save-list/` - Auto-save files
- `recentf` - Recent files list
- `projectile-bookmarks.eld` - Project bookmarks
- `.lsp-session-v1` - LSP session data
- `tramp`, `transient/`, `eshell/`, `tree-sitter/` - Runtime data
- `inits/repp.el` - Auto-generated from `repp.org` via org-babel

### Core Configuration Files

The essential files you need are:

- `init.el` - Main initialisation file
- `inits/custom.el` - Custom variables
- `inits/repp.org` - Main configuration (loaded via org-babel)
- `snippets/` - YASnippet templates (optional)

## Troubleshooting

For installation and compilation issues, see [docs/troubleshooting/](docs/troubleshooting/).
