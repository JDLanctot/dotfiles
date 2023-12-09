<link rel="stylesheet" href="https://raw.githubusercontent.com/JDLanctot/readme_formatting/main/assets/css/basic.css">
<h1 align="center">
  My Dotfiles
</h1>

<p align="center">
  My Dotfiles is a collection of configurations for various applications and tools I use on my workstation. This repository contains my personal dotfiles, which can be used as a starting point for setting up a new workstation.
  
## Table of Contents

- [Introduction](#introduction)
- [Less Bloated Windows Install](#windows-install)
- [Prerequisites](#prerequisites)
- [Installation Steps](#installation-steps)
  - [Programs](#programs)
  - [Make the Terminal Better (Autocomplete and Header Info)](#make-the-terminal-better-(autocomplete-and-header-info))
  - [Python and Anaconda Environments](#python-and-anaconda-environments)
  - [Julia](#julia)
  - [Neovim (Better Code Editting on the Command Line)](#neovim-better-code-editting-on-the-command-line)
  - [Webdev with React and NextJs](#webdev-with-react-and-nextJs)
- [GitHub SSH Setup for PowerShell and WSL](#github-ssh-setup-for-powershell-and-wsl)
  - [SSH Prerequisites](#ssh-prerequisites)
  - [Common Steps](#common-steps)
  - [For Powershell](#for-powershell)
  - [For WSL](#for-wsl)
  - [Repository Configuration](#repository-configuration)
- [Terminal Settings JSON](#terminal-settings-json)

## Introduction

Setting up a new workstation can be a time-consuming process. My dotfiles contain pre-configured settings and tools that can help you get up and running quickly.

## Windows Install

If you would like to have a cleaner Windows 11 experience:

1. Install with windows using the [ISO](https://www.microsoft.com/en-ca/software-download/windows11).
2. Choose languague as English (World) instead of a regional english to avoid installing programs like Amazon Prime on install (You will need to change it to a regional English in your settings later to use the Windows Store).
3. Right Click on the Windows Button on the taskbar and open terminal as admin.
4. Run the following command in the Terminal to open Chris Titus install program -- this will give you a GUI to install useful Programs, Programming Languages, etc.
    ```bash
    irm christitus.com/win | iex
    ```
5. DO NOT USE THIS GUI TO INSTALL THE LANGUAGES UNLESS YOU WANT TO BE ACCESSING THEM FROM POWERSHELL. WE WILL BE INSTALLING OUR LANGUAGES ON LINUX IN A LATER STEP.
6. Use the GUI to Install your favourite browser.
7. Go to the Tweaks tab of the GUI and click the Desktop Recommended Selections button and it will check the good tweaks you should be running.
8. Also add Remove Cortana as one of the selected Tweaks.
9. Click the Run Tweaks Button.
10. Restart your computer to have the tweaks take effect.
11. OPTIONAL - Buy and Install [Start11](https://www.stardock.com/products/start11/) which will allow you to improve the look of the windows start menu and give improved features such as grouping the pinned programs in custom groups.
12. OPTIONAL - Install and Run [Rectifier11](https://github.com/Rectify11/Installer) which will clean up aesthetic of control panel and other legacy OS parts of windows 11. (Make sure to choose Micah Alt for the Darkmode for best results)

## Prerequisites

Before you begin, ensure that the following prerequisites are met:

- Windows Subsystem for Linux (WSL) and Virtual Machine Platform are enabled. To enable these, open Control Panel, select Programs, then Turn Windows features on or off, and check the boxes next to Windows Subsystem for Linux and Virtual Machine Platform.

- Install the newest version of [Powershell](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-core-on-windows?view=powershell-7.1) on Windows.

- Install [Git for Windows](https://gitforwindows.org/).

- Nerd Fonts (I use JetBrainsMono Nerd Font) is installed on Windows. There are a few different options:
    - EASIEST -- You can install it by downloading it manually from the [Nerd Fonts Download Page](https://www.nerdfonts.com/font-downloads) and installing the fonts contained in the download. 
    - Alternatively, you can setup your Git Account on the command line and running the following command in PowerShell to get all of the fonts (PowerShell needs to be opened as administrator by right clicking on it):
    ```bash
    git clone --filter=blob:none --sparse git@github.com:ryanoasis/nerd-fonts
    ```
    - Or you can see more options on the [Nerd Fonts Github Repo](https://github.com/ryanoasis/nerd-fonts).

- Install Ubuntu and Windows Terminal from the Microsoft Store on Windows.

- Install [VSCode](https://code.visualstudio.com/) on Windows.
- Install the following extensions in VSCode:
  - [WSL](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-wsl)
  - [Git](https://marketplace.visualstudio.com/items?itemName=eamodio.gitlens)
  - [Python](https://marketplace.visualstudio.com/items?itemName=ms-python.python)


## Installation Steps

Follow the steps below to set up a new workstation:

### Programs
1. add WSL, Git, python extensions for VSCODE.
2. Replace JSON file in the Terminal applications settings with JSON content contained below

### Make the Terminal Better (Autocomplete and Header Info)
All of these steps should also make it so that when `Powershell` is run from `Terminal`, you will have better formatting and autocomplete -- not just when `Terminal` is running an instance of the `WSL terminal`.
A small note if you plan to use both: You will need to install `conda` on the PC side of things as well (which you can do through just installing the `Anaconda Navigator`, and this will give you `Anaconda Prompt`
for `Terminal` as well to be able to set up Conda environments for your PC/Powershell -- which can be useful if some packages you want are not released on Linux. If you choose to do this: 

3. ***OPTIONAL*** -- Install Anaconda Navigator, Open `Anaconda Prompt` and run 
  ```bash
  conda init powershell
  ```
This will make it so `Powershell` can run all of the conda commands and you will never have to open `Anaconda Prompt` again.

THE FOLLOWING STEPS ARE ALL LINUX UNLESS LINUX AND POWERSHELL OPTIONS ARE GIVEN. I FIND IT USEFUL TO SETUP BOTH TO BE ABLE TO BE FLEXIBLE DEPENDING ON IF YOU NEED TO CODE IN SOMETHING THAT MIGHT ONLY HAVE PACKAGES FOR ONE OS.

4. From the Ubuntu Command Line install Zsh  
    ```bash
    sudo apt install zsh
    ```
5. Get my dotfiles
    ```bash
    git clone https://github.com/JDLanctot/dotfiles.git
    ```
    ```bash
    mv dotfiles/{.,}* .
    ```
    ```bash
    rm -r .git
    ```
    ```bash
    rm -r dotfiles
    ```
6. Install ohmyzsh  
    ```bash
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    ```
7. Install zsh-autocompletions  
    ```bash
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    ```
8. Add it to the plugins list in .zshrc
9. Install zsh-completions  
    ```bash
    git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions
    ```
    ```bash
    fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src
    ```
10. Ohmyzsh likely overwrote the .zshrc and .zshenv so make sure that the .zshrc and .zshenv files you have now still contain the contents of my .zshrc and .zshenv from my github and that you still have the .zsh folder from my github with the same contents. This will now allow you to change between the bash shell (the default one) and the zsh shell (the one I prefer), but both should be customized. Just type either of the following to switch to the desired shell:
    ```
    bash
    ```
    ```
    zsh
    ```
  Note that if there are issues that any of the aliases aren't working in the respective shell, you can do the following to make sure that the correct rc file is in the path while using the shell that should source it:
    ```bash
    source ~/.bashrc
    ```
    ```bash
    source ~/.zshrc
    ```
    
11. Install Starship
    ```bash
    curl -sS https://starship.rs/install.sh | sh
    ```
    
12. Install Unzip
    ```bash
    sudo apt-get install unzip
    ```
    
13. Install Exa 
    ```bash
    sudo apt-get update
    ```
    ```bash
    sudo apt-get -y install exa
    ```
    
### Python and Anaconda Environments
14. Install anaconda on Ubuntu 
15. Pull from a git repo to get a code base for a Python project and `cd` into it. I don't have any public Python GitRepos at the moment, so you'll want probably want to make a directory, `cd` into it and have a file called `environment.devenv.yml` inside it that looks something like these two yaml examples (This will install of the packages listed in the yaml and the packages that they depend on. This yaml probably has things you don't need like Pytorch, TorchGeometric, tensorboard, cudatoolkit, etc):
    ```yaml
    name: assignments

    channels:
      - conda-forge
      - defaults
    
    dependencies:
      - ipdb
      - ipython
      - matplotlib
      - numpy
      - openpyxl
      - pandas
      - pip
      - python
      - pyyaml
      - tqdm
      - pip:
          - more-itertools
          - simple-parsing
    ```
    ```yaml
    name: netrl

    channels:
      - pytorch
      - rusty1s
      - nvidia
      - conda-forge
      - defaults
    
    dependencies:
      - cudatoolkit =11.1
      - ipdb
      - ipython
      - matplotlib
      - networkx >=2.0
      - numpy
      - pip
      - python >=3.8
      - pytorch =1.8
      - pytorch-geometric <=1.7.2
      - pytorch-scatter
      - pytorch-sparse
      - pyyaml
      - tensorboard
      - tqdm
      - pip:
          - abstractcp
          - gym
          - more-itertools
          - simple-parsing
          - wurlitzer
    ```
16. Create an env from the repo  
    ```bash
    conda env create --name name --file=environment.devenv.yml
    ```
17. Activate the environment. You will need to do this in the terminal everytime you want python to have access to all these packages, but this means that as you add new environments for different purposes, conda is allowing Python to have access to different bundles of packages. This also means that different environments could even have different versions of packages in the case where something you are working on old works with old packages and not any of the recent updates.
    ```bash
    conda activate name
    ```
  If you aren't sure of the name you can list all of the environments you have set up with:
    ```bash
    conda env list
    ```
    
18. As long as you are still `cd` into the folder, you can add the folder you are working on as a package it can call. This is useful when you want to be able to do python imports of scripts in the folder itself, allowing you to have calls to your own functions from other scripts. Eg. I can do something like `from netrl.visualize import Visualize` in one script in the folder so that it has access to the Visualize method. Note the `netrl` here will be based on the `--name` you did in the previous step, or the name from the yaml if you didn't use the `--name` flag in the previous step.
    ```bash
    pip install -e .
    ```
    
19. You can now run any python script that you have cd into the same folder as using:
    ```bash
    python3 filename.py
    ```
  If you have setup my zsh configs then you can do, because I have set p to be an alias for python3:
    ```bash
    p filename.py
    ```
    
### Julia
20. Install Julia  
    ```bash
    curl -O https://julialang-s3.julialang.org/bin/linux/x64/1.8/julia-1.8.5-linux-x86_64.tar.gz
    ```
    ```bash
    tar -xvzf julia-1.8.5-linux-x86_64.tar.gz
    ```

### Neovim - Better Code Editting on the Command Line
21. Install version 0.9+ of Neovim (Here I use the unstable ppa because Ubuntu only has up to 0.6 in the stable repository but in the future /unstable will be sufficient. Last command here echos the version to check if you have installed a version that is 0.9+.)
    ```bash
    sudo add-apt-repository ppa:neovim-ppa/unstable
    ```
    ```bash
    sudo apt-get update
    ```
    ```bash
    sudo apt-get install neovim
    ```
    ```bash
    nvim --version
    ```
22. Install Packer (This is currently not maintained and I may have to move over to Lazy NVIM at some point, but works fine for now)

    Linux
    ```bash
    git clone --depth 1 https://github.com/wbthomason/packer.nvim\ ~/.local/share/nvim/site/pack/packer/start/packer.nvim
    ```
    PowerShell
    ```bash
    git clone https://github.com/wbthomason/packer.nvim "$env:LOCALAPPDATA\nvim-data\site\pack\packer\start\packer.nvim"
    ```
    You will need to add nvim to your Path on Windows, so search for "Edit the system environment variables" in the Search Bar in Windows Settings, and Click the "Environment Variables..." button. Then click on Path in the User Variables table (the top one of the two displayed in this window), and click Edit. Now click the New button and add the following location followed by hitting the Ok button in that window and in the previously opened window with the tables:
    ```bash
    C:\tools\neovim\nvim-win64\bin
    ```
    If `nvim` is not working on the PowerShell, try restarting the PowerShell and make sure that the new path you added is indeed in the path variable we were just modifying by navigating back to the same window with the same steps and confirming it is there.
24. Go to the nvim directory. Powershell will require that you download my dotfiles in this step, because you only have them on the WSL at this point, and then do some modifying of what 

    Linux
    ```bash
    cd .config/nvim
    ```
    PowerShell
    ```bash
    cd C:\Users\Jordi\AppData\Local
    ```
    ```bash
    git clone https://github.com/JDLanctot/dotfiles.git nvim
    ```
    ```bash
    cd nvim
    ```
    Move only the items we need for Windows to the top level
    ```bash
    Move-Item .config/nvim/* .
    ```
    Remove Linux related files and reference to the Github repo
    ```bash
    Remove-Item .config -Recurse -Force
    Remove-Item .zsh -Recurse -Force
    Remove-Item .bashrc -Force
    Remove-Item .zshrc -Force
    Remove-Item .zshenv -Force
    Remove-Item README.md -Force
    Remove-Item .git -Recurse -Force
    ```
26. Open this directory in Neovim
    ```bash
    nvim .
    ```
27. There will be a ton of errors. Navigate past them and navigate into the toofaeded folder in lua and open the packer.lua file.
28. Source it and synch the packages (you may also have to source the init.lua in the .config/nvim folder).
    ```vim
    :so
    ```
    ```vim
    :PackerSync
    ```
29. Quit nvim and restart it and all of the changes should be implemented.

### Webdev with React and NextJs
28. If you want to install NPM and NodeJS on WSL to allow you to do web-development, following the guide on [Installing Node.js on Windows Subsystem for Linux (WSL2)](https://learn.microsoft.com/en-us/windows/dev-environment/javascript/nodejs-on-wsl).
29. If you installed npm, install pnpm using npm so that you can use pnpm instead of npm which makes it so that it doesn't duplicate node modules being installed when they are used in multiple projects.
    ```bash
    npm install -g pnpm
    ```
## GitHub SSH Setup for PowerShell and WSL
This is a step-by-step walkthrough for setting up SSH keys to access GitHub repositories in PowerShell and WSL (Windows Subsystem for Linux).

### SSH Prerequisites
- A GitHub account.
- PowerShell for Windows `Run as Administrator`.
- WSL installed for Linux commands.

### Common Steps
30. **Generate an SSH Key**:
    ```bash
    ssh-keygen -t ed25519 -C "your_email@example.com"
    ```
    - Follow the prompts to save the key to the default location.
    - Set a passphrase (optional but recommended).

31. **Add SSH Key to GitHub**:
    ```bash
    cat ~/.ssh/id_ed25519.pub
    ```
    - Copy the displayed key to your clipboard.
    - In GitHub, go to Settings → SSH and GPG keys → New SSH key.
    - Paste the key and save it.

### For PowerShell
32. **Start and Configure ssh-agent**:
    - Open PowerShell as Administrator.
    - Enable `ssh-agent` service:
      ```powershell
      Set-Service -Name ssh-agent -StartupType Automatic
      ```
    - Start the service:
      ```powershell
      Start-Service ssh-agent
      ```

33. **Add SSH Key to ssh-agent**:
    ```powershell
    ssh-add ~/.ssh/id_ed25519
    ```

34. **Test SSH Connection**:
    ```powershell
    ssh -T git@github.com
    ```

### For WSL
32. **Start and Configure ssh-agent**:
    - Open WSL terminal.
    - Start ssh-agent:
      ```bash
      eval "$(ssh-agent -s)"
      ```

33. **Add SSH Key to ssh-agent**:
    ```bash
    ssh-add ~/.ssh/id_ed25519
    ```

34. **Test SSH Connection**:
    ```bash
    ssh -T git@github.com
    ```

### Repository Configuration
For each Git repository:
- Change the remote URL to SSH if needed:
  ```bash
  git remote set-url origin git@github.com:username/repo.git
  ```

## Terminal Settings JSON
Just copy and paste the content below into the Terminal (the app) settings json.

  ```json
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
