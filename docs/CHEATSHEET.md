# Dotfiles CLI Cheat Sheet

Beginner-friendly guide for using this dotfiles setup on Windows, Linux/WSL, and macOS.

## Start here

| Step | Action | Why |
|---|---|---|
| 1 | Install platform tools from `README.md` | Gets shell + CLI dependencies in place |
| 2 | Apply shell profile (`.zshrc`, `.bashrc`, or PowerShell profile) | Enables aliases/functions in this cheat sheet |
| 3 | Restart terminal | Loads profile changes |
| 4 | Run sanity checks: `uv --version`, `ruff --version`, `fzf --version` | Confirms setup works |
| 5 | Practice the Daily Workflow section | Builds muscle memory quickly |

## Command line basics (for beginners)

### Core concepts

| Concept | Linux/macOS | PowerShell | Notes |
|---|---|---|---|
| Current folder | `pwd` | `Get-Location` (or `pwd`) | Shows where you are |
| List files | `ls` | `ls` / `dir` | In this setup, `ls` is enhanced |
| Change folder | `cd <path>` | `cd <path>` | Relative or absolute paths |
| Go up one level | `cd ..` | `cd ..` | You can also use `..` helper |
| Clear screen | `clear` | `clear` / `cls` | Quick reset |
| Stop running command | `Ctrl+C` | `Ctrl+C` | Safe interrupt |
| Command history | `history` | `Get-History` / `history` | `Ctrl+R` fuzzy history in PSFzf |

### Path examples

| Type | Example |
|---|---|
| Relative path | `src/app.py` |
| Parent folder | `../` |
| Home folder | `~` |
| Absolute path (Linux/macOS) | `/home/user/project` |
| Absolute path (Windows) | `C:\Users\name\project` |

## What this dotfiles setup adds

| Feature | Command(s) | What it does |
|---|---|---|
| Faster upward navigation | `..`, `...`, `....` | Jump up 1/2/3 levels |
| Smart directory jumping | `z <query>` | Jump to frequently used dirs |
| Fuzzy file picker to Neovim | `fzn` | Find file with preview and open in `nvim` |
| Fuzzy file picker to VS Code (PowerShell) | `fzc` | Find file with preview and open in `code` |
| Enhanced listing | `ls`, `la`, `ll` | Better file listing via `eza`/`exa` |
| Python env sync helper | `uvs` | Runs `uv sync` |
| Python command helper | `uvr ...` | Runs `uv run ...` |
| Python test helper | `uvt` | Runs `uv run pytest` |
| Ruff autofix helper | `rufffix` | Runs `ruff check --fix` then `ruff format` |
| Legacy conda activate | `ca <env>` | Activates conda env |
| Legacy conda jump+activate | `caz <env-or-query>` | `z` jump then `conda activate` |

## Daily workflow (copy/paste friendly)

### 1) Navigate to project

```bash
z my-project
```

or

```bash
cd ~/code/my-project
```

### 2) Sync Python dependencies (modern default)

```bash
uvs
```

### 3) Run tests

```bash
uvt
```

### 4) Lint + format

```bash
rufffix
```

### 5) Open/edit files quickly

```bash
fzn
```

## Python workflows

### Modern default: `uv` + `pyproject.toml`

| Task | Command |
|---|---|
| Create project | `uv init my_project --python 3.12` |
| Add dependency | `uv add requests` |
| Sync env | `uv sync` |
| Run command in env | `uv run python -m my_package` |
| Run tests | `uv run pytest` |
| Ruff lint | `uv run ruff check .` |
| Ruff format | `uv run ruff format .` |

### Legacy option: Conda (for older repos)

| Task | Command |
|---|---|
| Activate env | `ca <env>` |
| Jump + activate | `caz <env-or-query>` |

Use Conda when repo tooling depends on existing Conda/CUDA stacks.

## Search, inspect, and edit faster

| Tool | Example | Use case |
|---|---|---|
| `ag` | `ag "TODO"` | Fast text search in repo |
| `fzf` | `fzf` | Fuzzy file/entry chooser |
| `bat` | `bat README.md` | Pretty file preview |
| `nvim` | `nvim .` | Open current project in Neovim |

## Optional webdev stack

| Tool | Install | Verify |
|---|---|---|
| Biome | `npm install -g @biomejs/biome` | `biome --version` |
| AWS CLI | Windows: `choco install awscli`<br>Linux/WSL: `sudo apt install awscli`<br>macOS: `brew install awscli` | `aws --version` |
| SST | `npm install -g sst` | `sst version` |

Prereq: Node.js 20+ recommended.

## Platform install quick reference

| Platform | Core commands |
|---|---|
| Windows (PowerShell) | `choco install ag bat fzf zoxide starship`<br>`Install-Module -Name PSFzf`<br>`irm https://astral.sh/uv/install.ps1 | iex`<br>`uv tool install ruff` |
| Linux / WSL | `sudo apt update`<br>`sudo apt install zsh fzf zoxide bat silversearcher-ag eza neovim`<br>`curl -LsSf https://astral.sh/uv/install.sh | sh`<br>`uv tool install ruff` |
| macOS | `./setup.sh`<br>`uv tool install ruff` |

## Troubleshooting

| Problem | Check | Fix |
|---|---|---|
| `fzf` list is empty | Is `ag` installed? | Install `ag` and restart shell |
| Preview pane fails | Is `bat` installed? | Install `bat` and restart shell |
| New functions missing | Did profile load? | `source ~/.zshrc` / `source ~/.bashrc` / `. $PROFILE` |
| `uv` not found | Is installer run? | Re-run uv install command and restart terminal |
| `ruff` not found | Installed with `uv tool install ruff`? | Run install command and restart shell |

## Claude CLI quick start

### Open Claude

| Task | Command |
|---|---|
| Start Claude in current folder | `claude` |
| Start Claude in a specific folder | `claude` (run after `cd /path/to/project`) |
| Start with a direct prompt | `claude "explain this repo structure"` |

Tip: open Claude from the project root so it sees the right files.

### Useful slash commands

| Command | What it does | Typical use |
|---|---|---|
| `/help` | Shows available commands | First command to run in a new install |
| `/clear` | Clears current chat context | Start fresh on a new task |
| `/model` | Shows or changes model | Switch models for speed/quality |
| `/status` | Shows session/tool status | Check environment and current state |
| `/diff` | Shows pending file changes | Review edits before commit |
| `/review` | Requests a code review pass | Catch issues before merging |

Note: exact slash commands can vary by Claude CLI version. Run `/help` to see the commands available on your machine.

### Good prompts to use in this dotfiles repo

| Goal | Example prompt |
|---|---|
| Explain shell setup | `Explain how .zshrc, .bashrc, and PowerShell profile differ in this repo.` |
| Add a new alias/function | `Add a zsh + PowerShell helper for running my common git pull workflow.` |
| Improve docs | `Update CHEATSHEET.md with a section for tmux basics and examples.` |
| Safe review before commit | `Review all modified files and list risks before I commit.` |

## OpenCode CLI quick start

### Open OpenCode

| Task | Command |
|---|---|
| Start OpenCode in current folder | `opencode` |
| Start OpenCode in a specific folder | `opencode` (run after `cd /path/to/project`) |
| Start with a direct prompt | `opencode "summarize this project and suggest next improvements"` |

Tip: like Claude, start OpenCode from the repo root for best context.

### Useful slash commands

| Command | What it does | Typical use |
|---|---|---|
| `/help` | Shows available commands | First check in a new install |
| `/clear` | Clears current chat context | Start fresh task context |
| `/model` | Shows or changes model | Balance speed vs quality |
| `/status` | Shows session/tool status | Confirm environment state |
| `/diff` | Shows pending file changes | Review edits before commit |
| `/review` | Requests a code review pass | Catch issues before merge |

Note: available slash commands can differ by OpenCode version/config. Run `/help` in your local install to confirm.

### Good OpenCode prompts for this repo

| Goal | Example prompt |
|---|---|
| Explain repo conventions | `List key shell conventions and helper commands in this dotfiles repo.` |
| Add cross-shell helper | `Add matching zsh and PowerShell helpers for running uv lint + tests.` |
| Tighten docs | `Rewrite README quick start to be copy-paste friendly for beginners.` |
| Pre-commit safety check | `Review my staged changes and highlight breaking risks.` |

## Where things are configured

| Area | File |
|---|---|
| Zsh main config | `.zshrc` |
| Zsh aliases | `.zsh/aliases.zsh` |
| Zsh functions | `.zsh/functions.zsh` |
| Bash config | `.bashrc` |
| PowerShell profile | `.windows/powershell/profile.ps1` |
| Claude/OpenCode shared skills | `.claude/skills/` |
| Starship prompt config | `.config/starship.toml` |
| macOS package baseline | `Brewfile` |

## Reference

- Full install guide: `README.md`
- This quick guide: `CHEATSHEET.md`
