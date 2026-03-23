# Dotfiles

Personal cross-platform dotfiles for Windows, Linux/WSL, and macOS.

If you are onboarding to this setup, start here:
- `CHEATSHEET.md` (daily commands + workflow)

## Table of contents

- [What this repo includes](#what-this-repo-includes)
- [Quick start](#quick-start)
- [Platform installs](#platform-installs)
- [Shell setup](#shell-setup)
- [Neovim and editor workflow](#neovim-and-editor-workflow)
- [Python environments (uv first, conda legacy)](#python-environments-uv-first-conda-legacy)
- [Optional webdev stack](#optional-webdev-stack)
- [Tooling and command profile](#tooling-and-command-profile)
- [Windows extras](#windows-extras)
- [Troubleshooting](#troubleshooting)

## What this repo includes

- Shell configs:
  - Zsh: `.zshrc`, `.zshenv`, `.zsh/`
  - Bash: `.bashrc`
  - PowerShell: `.windows/powershell/profile.ps1`
- Prompt config: `.config/starship.toml`
- Package baseline for macOS: `Brewfile`, `setup.sh`
- Optional Windows app/config customizations in `.windows/`

Core CLI stack used by these configs:
- `starship`
- `zoxide`
- `fzf`
- `ag` (The Silver Searcher)
- `bat`
- `eza` / `exa`
- `neovim`
- `uv` (primary Python package/project workflow)
- `ruff` (installed via `uv tool`)

Conda remains supported for legacy environments.

## Quick start

1) Clone this repo

```bash
git clone https://github.com/JDLanctot/dotfiles.git ~/dotfiles
```

2) Install platform tools from [Platform installs](#platform-installs)

3) Link/copy the shell files you want from this repo into your home directory

4) Restart your terminal and verify:

```bash
zoxide --version
fzf --version
ag --version
bat --version
nvim --version
uv --version
ruff --version
```

5) Open `CHEATSHEET.md` and test the daily workflows (`..`, `fzn`, `ca`, `caz`, `z <query>`)

## Platform installs

### Windows (PowerShell)

Install dependencies with Chocolatey:

```powershell
choco install starship zoxide fzf ag bat
Install-Module -Name PSFzf
```

Install `uv` (official installer):

```powershell
irm https://astral.sh/uv/install.ps1 | iex
uv tool install ruff
```

If script execution blocks your profile:

```powershell
Set-ExecutionPolicy RemoteSigned
```

### Linux / WSL (apt)

```bash
sudo apt update
sudo apt install zsh fzf zoxide bat silversearcher-ag eza neovim
```

Install `uv` (official installer):

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
uv tool install ruff
```

Optional but expected by current zsh setup:

```bash
sudo apt install zsh-autosuggestions
```

### macOS (Homebrew)

The repo includes a Brew bootstrap script and package manifest:

```bash
./setup.sh
```

This installs Homebrew (if needed) and applies `Brewfile`.

`uv` is included in this repo's `Brewfile`.
Ruff install:

```bash
uv tool install ruff
```

## Shell setup

Use the shell profile for your platform:

- Zsh: `.zshrc` + `.zshenv` + `.zsh/`
- Bash: `.bashrc`
- PowerShell: `.windows/powershell/profile.ps1`

Recommended approach: symlink from your home directory to files in this repo.

### Linux/WSL symlink example

```bash
ln -sfn ~/dotfiles/.zshrc ~/.zshrc
ln -sfn ~/dotfiles/.zshenv ~/.zshenv
ln -sfn ~/dotfiles/.zsh ~/.zsh
ln -sfn ~/dotfiles/.bashrc ~/.bashrc
ln -sfn ~/dotfiles/.config/starship.toml ~/.config/starship.toml
```

### PowerShell profile example

```powershell
New-Item -Type Directory -Force "$HOME\Documents\PowerShell" | Out-Null
New-Item -ItemType SymbolicLink -Force -Path "$HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1" -Target "$HOME\dotfiles\.windows\powershell\profile.ps1"
```

Reload profiles:

- Bash: `source ~/.bashrc`
- Zsh: `source ~/.zshrc`
- PowerShell: `. $PROFILE`

## Neovim and editor workflow

- Open a project: `nvim .`
- Fuzzy open into Neovim: `fzn`
- In PowerShell, fuzzy open into VS Code: `fzc`

Neovim is installed as part of the managed package set (`Brewfile` on macOS, apt/choco on Linux/Windows).

## Python environments (uv first, conda legacy)

Default approach for new work: use `uv` + `pyproject.toml`.

Recommended modern Python protocol:
- Project metadata and dependencies in `pyproject.toml` (PEP 621 style).
- Locked, reproducible envs with `uv.lock`.
- Run tools and scripts through `uv run ...`.

Typical new-project flow:

```bash
uv init my_project --python 3.12
cd my_project
uv add ruff pytest
uv sync
uv run pytest
```

Typical existing-project flow:

```bash
uv sync
uv run python -m your_package
```

Lint/format workflow with Ruff:

```bash
uv run ruff check .
uv run ruff format .
```

When you need legacy Conda workflows (older repos, CUDA stacks, pinned environments), Conda helpers are still available in shell configs:
- `ca <env>` activate Conda env
- `caz <env-or-query>` jump + activate

Conda is optional and no longer the default recommendation for new projects.

## Optional webdev stack

Use this if you want frontend/infrastructure tooling beyond the base shell setup.

Includes:
- `biome` (JS/TS formatter + linter)
- `aws` CLI
- `sst`

Prereq:
- Node.js (recommend Node 20+; `nvm` is already wired in shell configs)

### Windows (PowerShell)

```powershell
choco install awscli
npm install -g @biomejs/biome sst
```

### Linux / WSL

```bash
sudo apt install awscli
npm install -g @biomejs/biome sst
```

### macOS

```bash
brew install awscli
npm install -g @biomejs/biome sst
```

Verify:

```bash
biome --version
aws --version
sst version
```

## Tooling and command profile

The setup is tuned for fast navigation and fuzzy workflows:

- Directory movement:
  - `..`, `...`, `....`
- Smart jump:
  - `z <query>` (`zoxide`)
- Fuzzy picking:
  - `fzf` + `bat` preview
  - default file source uses `ag` via `FZF_DEFAULT_COMMAND`
- Conda helpers:
  - `ca <env>` activate (legacy Conda repos)
  - `caz <env-or-query>` jump then activate (legacy Conda repos)
- uv/Ruff helpers:
  - `uvs` sync dependencies
  - `uvr` run any command via `uv run`
  - `uvt` run pytest via `uv run pytest`
  - `rufffix` run Ruff autofix + format

For full day-to-day command reference, use `CHEATSHEET.md`.

## Windows extras

The `.windows/` directory contains optional app-specific configs and tweaks for tools such as:

- Windows Terminal
- Firefox
- Obsidian
- Steam
- Discord
- Zebar/GlazeWM
- Registry tweak snippets under `.windows/_reg/`

These are optional and can be applied selectively.

## Troubleshooting

- `fzf` opens but list is empty:
  - confirm `ag` is installed and on `PATH`
- preview pane in fuzzy finder is broken:
  - confirm `bat` is installed and on `PATH`
- profile updates not loading:
  - source profile manually (see Shell setup)
- WSL + VS Code interop issues:
  - check `.zsh/wsl2fix.zsh`

## License

MIT. See `LICENSE`.
