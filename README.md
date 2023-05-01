<h1 align="center">
  My Dotfiles
  </h1>

  <p align="center">
  My Dotfiles is a collection of configurations for various applications and tools I use on my workstation. This repository contains my personal dotfiles, which can be used as a starting point for setting up a new workstation.
  </p>

  ## Introduction

  Setting up a new workstation can be a time-consuming process. My dotfiles contain pre-configured settings and tools that can help you get up and running quickly.

  ## Prerequisites

  Before you begin, ensure that the following prerequisites are met:

  - Windows Subsystem for Linux (WSL) and Virtual Machine Platform are enabled. To enable these, open Control Panel, select Programs, then Turn Windows features on or off, and check the boxes next to Windows Subsystem for Linux and Virtual Machine Platform.

  - Install the newest version of [Powershell](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-core-on-windows?view=powershell-7.1) on Windows.
  - Nerd Fonts (I use JetBrainsMono Nerd Font) is installed on Windows. You can install it by running the following command in PowerShell:
    ```
    git clone --filter=blob:none --sparse git@github.com:ryanoasis/nerd-fonts
    ```

  - Install Ubuntu and Terminal from the Microsoft Store on Windows.

  - Install [VSCode](https://code.visualstudio.com/) on Windows.
  - Install the following extensions in VSCode:
    - [WSL](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-wsl)
    - [Git](https://marketplace.visualstudio.com/items?itemName=eamodio.gitlens)
    - [Python](https://marketplace.visualstudio.com/items?itemName=ms-python.python)


  ## Steps

  Follow the steps below to set up a new workstation:

  1. add WSL, Git, python extensions for VSCODE.
  2. Replace JSON file in the Terminal applications settings with JSON content contained below
  3. From the Ubuntu Command Line install Zsh  
    ```
    sudo apt install zsh
    ```
  4. Get my dotfiles
    ```
    git clone https://github.com/JDLanctot/dotfiles.git
    ```
    ```
    mv dotfiles/{.,}* .
    ```
    ```
    rm -r .git
    ```
    ```
    rm -r dotfiles
    ```
  5. Install ohmyzsh  
    ```
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    ```
  6. Install zsh-autocompletions  
    ```
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    ```
  7. Add it to the plugins list in .zshrc
  8. Install zsh-completions  
    ```
    git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions
    ```
    ```
    fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src
    ```
  9. Get my dotfiles for .zsh and update the one that ohmyzsh made and add the .zsh folder
  10. Install Starship
    ```
    curl -sS https://starship.rs/install.sh | sh
    ```
  11. Install Unzip
    ```
    sudo apt-get install unzip
    ```
  12. Install Exa 
    ```
    sudo apt-get update
    ```
    ```
    sudo apt-get -y install exa
    ```
  13. Install anaconda on Ubuntu 
  14. Pull from a git repo
  15. Create an env from the repo  
    ```
    conda env create --name name --file=environment.devenv.yml
    ```
  16. cd into the folder and add the package itself  
    ```
    pip install -e .
    ```
  17. Install Julia  
    ```
    curl -O https://julialang-s3.julialang.org/bin/linux/x64/1.8/julia-1.8.5-linux-x86_64.tar.gz
    ```
    ```
    tar -xvzf julia-1.8.5-linux-x86_64.tar.gz
    ```
  18. Install version 0.9+ of Neovim (Here I use the unstable ppa because Ubuntu only has up to 0.6 in the stable repository but in the future /unstable will be sufficient. Last command here echos the version to check if you have installed a version that is 0.9+.)
    ```
    sudo add-apt-repository ppa:neovim-ppa/unstable
    ```
    ```
    sudo apt-get update
    ```
    ```
    sudo apt-get install neovim
    ```
    ```
    nvim --version
    ```
  19. Install Packer
    ```
    git clone --depth 1 https://github.com/wbthomason/packer.nvim\ ~/.local/share/nvim/site/pack/packer/start/packer.nvim
    ```
  20. Go to the nvim directory
    ```
    cd .config/nvim
    ```
  21. Open this directory in Neovim
    ```
    nvim .
    ```
  22. There will be a ton of errors. Navigate past them and navigate into the toofaeded folder in lua and open the packer.lua file.
  23. Source it and synch the packages (you may also have to source the init.lua in the .config/nvim folder).
    ```
    :so
    ```
    ```
    :PackerSync
    ```
  24. Quit nvim and restart it and all of the changes should be implemented.

  ## JSON For Nicer Terminal Settings
  Just copy and paste the content below into the terminal settings json.

  ```
  {
    "$help": "https://aka.ms/terminal-documentation",
    "$schema": "https://aka.ms/terminal-profiles-schema",
    "actions": 
    [
    {
    "command": "find",
    "keys": "ctrl+shift+f"
    },
    {
    "command": "paste",
    "keys": "ctrl+v"
    },
    {
    "command": 
    {
    "action": "copy",
    "singleLine": false
    },
    "keys": "ctrl+c"
    },
    {
    "command": 
    {
    "action": "splitPane",
    "split": "auto",
    "splitMode": "duplicate"
    },
    "keys": "alt+shift+d"
    }
    ],
    "copyFormatting": "none",
    "copyOnSelect": false,
    "defaultProfile": "{51855cb2-8cce-5362-8f54-464b92b32386}",
    "firstWindowPreference": "defaultProfile",
    "profiles": 
    {
    "defaults": 
    {
    "colorScheme": "xcad",
    "cursorShape": "filledBox",
    "font": 
    {
    "face": "JetBrainsMono Nerd Font",
    "size": 14.0
    },
    "historySize": 12000,
    "intenseTextStyle": "bright",
    "opacity": 60,
    "padding": "8",
    "scrollbarState": "visible",
    "useAcrylic": true
    },
    "list": 
    [
    {
    "commandline": "C:\\Program Files\\PowerShell\\7\\pwsh.exe --NoLogo",
    "elevate": false,
    "guid": "{574e775e-4f2a-5b96-ac1e-a2962a402336}",
    "hidden": false,
    "name": "PowerShell",
    "source": "Windows.Terminal.PowershellCore"
    },
    {
    "commandline": "%SystemRoot%\\System32\\cmd.exe",
    "guid": "{0caa0dad-35be-5f56-a8ff-afceeeaa6101}",
    "hidden": true,
    "name": "Command Prompt"
    },
    {
    "commandline": "cmd.exe /K C:\\Users\\Too_Faeded\\anaconda3\\Scripts\\activate.bat",
    "guid": "{5c5feee2-b2a6-4109-8f8c-45171ac94222}",
    "hidden": false,
    "icon": "C:\\Users\\Too_Faeded\\anaconda3\\Menu\\anaconda-navigator.ico",
    "name": "Conda",
    "startingDirectory": "C:/Users/Too_Faeded/Documents"
    },
    {
    "guid": "{b453ae62-4e3d-5e58-b989-0a998ec441b8}",
    "hidden": true,
    "name": "Azure Cloud Shell",
    "source": "Windows.Terminal.Azure"
    },
    {
    "guid": "{51855cb2-8cce-5362-8f54-464b92b32386}",
    "hidden": false,
    "name": "Ubuntu",
    "source": "CanonicalGroupLimited.Ubuntu_79rhkp1fndgsc"
    },
    {
    "guid": "{2c4de342-38b7-51cf-b940-2309a097f518}",
    "hidden": true,
    "name": "Ubuntu",
    "source": "Windows.Terminal.Wsl"
    }
    ]
    },
    "schemes": 
    [
    {
    "background": "#0C0C0C",
    "black": "#0C0C0C",
    "blue": "#0037DA",
    "brightBlack": "#767676",
    "brightBlue": "#3B78FF",
    "brightCyan": "#61D6D6",
    "brightGreen": "#16C60C",
    "brightPurple": "#B4009E",
    "brightRed": "#E74856",
    "brightWhite": "#F2F2F2",
    "brightYellow": "#F9F1A5",
    "cursorColor": "#FFFFFF",
    "cyan": "#3A96DD",
    "foreground": "#CCCCCC",
    "green": "#13A10E",
    "name": "Campbell",
    "purple": "#881798",
    "red": "#C50F1F",
    "selectionBackground": "#FFFFFF",
    "white": "#CCCCCC",
    "yellow": "#C19C00"
    },
    {
    "background": "#012456",
    "black": "#0C0C0C",
    "blue": "#0037DA",
    "brightBlack": "#767676",
    "brightBlue": "#3B78FF",
    "brightCyan": "#61D6D6",
    "brightGreen": "#16C60C",
    "brightPurple": "#B4009E",
    "brightRed": "#E74856",
    "brightWhite": "#F2F2F2",
    "brightYellow": "#F9F1A5",
    "cursorColor": "#FFFFFF",
    "cyan": "#3A96DD",
    "foreground": "#CCCCCC",
    "green": "#13A10E",
    "name": "Campbell Powershell",
    "purple": "#881798",
    "red": "#C50F1F",
    "selectionBackground": "#FFFFFF",
    "white": "#CCCCCC",
    "yellow": "#C19C00"
    },
    {
    "background": "#282C34",
    "black": "#282C34",
    "blue": "#61AFEF",
    "brightBlack": "#5A6374",
    "brightBlue": "#61AFEF",
    "brightCyan": "#56B6C2",
    "brightGreen": "#98C379",
    "brightPurple": "#C678DD",
    "brightRed": "#E06C75",
    "brightWhite": "#DCDFE4",
    "brightYellow": "#E5C07B",
    "cursorColor": "#FFFFFF",
    "cyan": "#56B6C2",
    "foreground": "#DCDFE4",
    "green": "#98C379",
    "name": "One Half Dark",
    "purple": "#C678DD",
    "red": "#E06C75",
    "selectionBackground": "#FFFFFF",
    "white": "#DCDFE4",
    "yellow": "#E5C07B"
    },
    {
    "background": "#FAFAFA",
    "black": "#383A42",
    "blue": "#0184BC",
    "brightBlack": "#4F525D",
    "brightBlue": "#61AFEF",
    "brightCyan": "#56B5C1",
    "brightGreen": "#98C379",
    "brightPurple": "#C577DD",
    "brightRed": "#DF6C75",
    "brightWhite": "#FFFFFF",
    "brightYellow": "#E4C07A",
    "cursorColor": "#4F525D",
    "cyan": "#0997B3",
    "foreground": "#383A42",
    "green": "#50A14F",
    "name": "One Half Light",
    "purple": "#A626A4",
    "red": "#E45649",
    "selectionBackground": "#FFFFFF",
    "white": "#FAFAFA",
    "yellow": "#C18301"
    },
    {
    "background": "#002B36",
    "black": "#002B36",
    "blue": "#268BD2",
    "brightBlack": "#073642",
    "brightBlue": "#839496",
    "brightCyan": "#93A1A1",
    "brightGreen": "#586E75",
    "brightPurple": "#6C71C4",
    "brightRed": "#CB4B16",
    "brightWhite": "#FDF6E3",
    "brightYellow": "#657B83",
    "cursorColor": "#FFFFFF",
    "cyan": "#2AA198",
    "foreground": "#839496",
    "green": "#859900",
    "name": "Solarized Dark",
    "purple": "#D33682",
    "red": "#DC322F",
    "selectionBackground": "#FFFFFF",
    "white": "#EEE8D5",
    "yellow": "#B58900"
    },
    {
    "background": "#FDF6E3",
    "black": "#002B36",
    "blue": "#268BD2",
    "brightBlack": "#073642",
    "brightBlue": "#839496",
    "brightCyan": "#93A1A1",
    "brightGreen": "#586E75",
    "brightPurple": "#6C71C4",
    "brightRed": "#CB4B16",
    "brightWhite": "#FDF6E3",
    "brightYellow": "#657B83",
    "cursorColor": "#002B36",
    "cyan": "#2AA198",
    "foreground": "#657B83",
    "green": "#859900",
    "name": "Solarized Light",
    "purple": "#D33682",
    "red": "#DC322F",
    "selectionBackground": "#FFFFFF",
    "white": "#EEE8D5",
    "yellow": "#B58900"
    },
    {
    "background": "#000000",
    "black": "#000000",
    "blue": "#3465A4",
    "brightBlack": "#555753",
    "brightBlue": "#729FCF",
    "brightCyan": "#34E2E2",
    "brightGreen": "#8AE234",
    "brightPurple": "#AD7FA8",
    "brightRed": "#EF2929",
    "brightWhite": "#EEEEEC",
    "brightYellow": "#FCE94F",
    "cursorColor": "#FFFFFF",
    "cyan": "#06989A",
    "foreground": "#D3D7CF",
    "green": "#4E9A06",
    "name": "Tango Dark",
    "purple": "#75507B",
    "red": "#CC0000",
    "selectionBackground": "#FFFFFF",
    "white": "#D3D7CF",
    "yellow": "#C4A000"
    },
    {
    "background": "#FFFFFF",
    "black": "#000000",
    "blue": "#3465A4",
    "brightBlack": "#555753",
    "brightBlue": "#729FCF",
    "brightCyan": "#34E2E2",
    "brightGreen": "#8AE234",
    "brightPurple": "#AD7FA8",
    "brightRed": "#EF2929",
    "brightWhite": "#EEEEEC",
    "brightYellow": "#FCE94F",
    "cursorColor": "#000000",
    "cyan": "#06989A",
    "foreground": "#555753",
    "green": "#4E9A06",
    "name": "Tango Light",
    "purple": "#75507B",
    "red": "#CC0000",
    "selectionBackground": "#FFFFFF",
    "white": "#D3D7CF",
    "yellow": "#C4A000"
    },
    {
    "background": "#300A24",
    "black": "#171421",
    "blue": "#0037DA",
    "brightBlack": "#767676",
    "brightBlue": "#08458F",
    "brightCyan": "#2C9FB3",
    "brightGreen": "#26A269",
    "brightPurple": "#A347BA",
    "brightRed": "#C01C28",
    "brightWhite": "#F2F2F2",
    "brightYellow": "#A2734C",
    "cursorColor": "#FFFFFF",
    "cyan": "#3A96DD",
    "foreground": "#FFFFFF",
    "green": "#26A269",
    "name": "Ubuntu-20.04-ColorScheme",
    "purple": "#881798",
    "red": "#C21A23",
    "selectionBackground": "#FFFFFF",
    "white": "#CCCCCC",
    "yellow": "#A2734C"
    },
    {
    "background": "#300A24",
    "black": "#171421",
    "blue": "#0037DA",
    "brightBlack": "#767676",
    "brightBlue": "#08458F",
    "brightCyan": "#2C9FB3",
    "brightGreen": "#26A269",
    "brightPurple": "#A347BA",
    "brightRed": "#C01C28",
    "brightWhite": "#F2F2F2",
    "brightYellow": "#A2734C",
    "cursorColor": "#FFFFFF",
    "cyan": "#3A96DD",
    "foreground": "#FFFFFF",
    "green": "#26A269",
    "name": "Ubuntu-ColorScheme",
    "purple": "#881798",
    "red": "#C21A23",
    "selectionBackground": "#FFFFFF",
    "white": "#CCCCCC",
    "yellow": "#A2734C"
    },
    {
    "background": "#000000",
    "black": "#000000",
    "blue": "#000080",
    "brightBlack": "#808080",
    "brightBlue": "#0000FF",
    "brightCyan": "#00FFFF",
    "brightGreen": "#00FF00",
    "brightPurple": "#FF00FF",
    "brightRed": "#FF0000",
    "brightWhite": "#FFFFFF",
    "brightYellow": "#FFFF00",
    "cursorColor": "#FFFFFF",
    "cyan": "#008080",
    "foreground": "#C0C0C0",
    "green": "#008000",
    "name": "Vintage",
    "purple": "#800080",
    "red": "#800000",
    "selectionBackground": "#FFFFFF",
    "white": "#C0C0C0",
    "yellow": "#808000"
    },
    {
    "background": "#1A1A1A",
    "black": "#121212",
    "blue": "#2B4FFF",
    "brightBlack": "#666666",
    "brightBlue": "#5C78FF",
    "brightCyan": "#5AC8FF",
    "brightGreen": "#905AFF",
    "brightPurple": "#5EA2FF",
    "brightRed": "#BA5AFF",
    "brightWhite": "#FFFFFF",
    "brightYellow": "#685AFF",
    "cursorColor": "#FFFFFF",
    "cyan": "#28B9FF",
    "foreground": "#F1F1F1",
    "green": "#7129FF",
    "name": "xcad",
    "purple": "#2883FF",
    "red": "#A52AFF",
    "selectionBackground": "#FFFFFF",
    "white": "#F1F1F1",
    "yellow": "#3D2AFF"
    }
    ],
    "showTabsInTitlebar": true,
    "tabSwitcherMode": "inOrder",
    "themes": [],
    "useAcrylicInTabRow": true
  }
  ```
