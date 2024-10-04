My Dotfiles is a collection of configurations for various applications and tools I use on my workstation. This repository contains my personal dotfiles, which can be used as a starting point for setting up a new workstation.
  
## Table of Contents

- [Introduction](#introduction)
- [Less Bloated Windows Install](#less-bloated-windows-install)
- [Prerequisites](#prerequisites)
- [Installation Steps](#installation-steps)
  - [Programs](#programs)
  - [Make the Terminal Better (Autocomplete and Header Info)](#make-the-terminal-better-autocomplete-and-header-info)
  - [Python and Anaconda Environments](#python-and-anaconda-environments)
  - [Julia](#julia)
  - [Neovim - Better Code Editing on the Command Line](#neovim---better-code-editing-on-the-command-line)
  - [Webdev with React and NextJs](#webdev-with-react-and-nextjs)
- [GitHub SSH Setup for PowerShell and WSL](#github-ssh-setup-for-powershell-and-wsl)
  - [SSH Prerequisites](#ssh-prerequisites)
  - [Common Steps](#common-steps)
  - [For PowerShell](#for-powershell)
  - [For WSL](#for-wsl)
  - [Repository Configuration](#repository-configuration)
- [Terminal Settings JSON](#terminal-settings-json)
- [CLI Tools](#cli-tools)
- [Problems When Upgrading Ubuntu](#problems-when-upgrading-ubuntu)
- [Academic Resources](#academic-resources)
  - [LaTex Template](#latex-template)
  - [Scholarship Applications](#scholarship-applications)
  - [Portfolio Website](#portfolio-website)
- [Contributing](#contributing)
- [License](#license)

## Introduction

Welcome to my Dotfiles repository! Setting up a new workstation is often a daunting and time-consuming task, especially for developers and researchers who require a highly personalized and efficient working environment. This collection of dotfiles is designed to streamline that process, offering pre-configured settings and tools that I've refined over time to enhance productivity and ease the setup of new machines.

Whether you're setting up a system for coding, writing, or research, these configurations can serve as a solid foundation or inspiration for your own setup. They are the result of countless hours of tweaking and optimizing, aimed at creating a seamless development experience across various platforms.

By using these dotfiles, you'll be able to quickly replicate my setup on your own machine, saving you the hassle of manual configuration while also introducing you to best practices and tools that you might not have been aware of. Let's dive into making your workstation setup as painless and efficient as possible!

## Less Bloated Windows Install

To achieve a cleaner and more streamlined Windows 11 experience, follow these steps:

1. Begin by installing Windows using the [ISO from Microsoft's official site](https://www.microsoft.com/en-ca/software-download/windows11).
2. During installation, select English (World) as your language to avoid pre-installed regional-specific programs (e.g., Amazon Prime). You can switch to a regional English variant later in settings for Windows Store access.
3. After installation, right-click the Windows button on the taskbar and open Terminal as an administrator.
4. Execute the following command in the Terminal to launch Chris Titus's install program, which provides a GUI for installing various programs and programming languages:
    ```bash
    irm christitus.com/win | iex
    ```
5. **Important:** Avoid using this GUI to install programming languages if you plan to access them primarily through Linux environments. We will cover language installation on Linux in a later step.
6. Use the GUI to install your preferred web browser.
7. Navigate to the Tweaks tab within the GUI, and select the "Desktop Recommended Selections" for optimal system tweaks.
8. Additionally, select "Remove Cortana" from the tweaks list.
9. Apply the tweaks by clicking the "Run Tweaks" button.
10. Restart your computer to ensure all changes take effect.
11. **Optional:** Consider purchasing and installing [Start11](https://www.stardock.com/products/start11/) to enhance the Windows start menu with features like custom grouping for pinned programs.
12. **Optional:** Install [Rectifier11](https://github.com/Rectify11/Installer) to refine the aesthetics of the control panel and other legacy components of Windows 11. For the best dark mode experience, choose Micah Alt during setup.

## Prerequisites

Before diving into the setup process, ensure you meet the following prerequisites to ensure a smooth installation:

- **Windows Subsystem for Linux (WSL) and Virtual Machine Platform**: These features must be enabled to allow for Linux and virtualization support on Windows. To enable them:
  1. Open the Control Panel.
  2. Navigate to Programs > Turn Windows features on or off.
  3. Check the boxes next to **Windows Subsystem for Linux** and **Virtual Machine Platform**.

- **PowerShell**: Install the latest version of [PowerShell](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-core-on-windows?view=powershell-7.1) on Windows to ensure compatibility with modern scripts and tools.

- **Git for Windows**: Essential for version control and managing code repositories. Download and install from [Git for Windows](https://gitforwindows.org/).

- **Nerd Fonts**: Enhance your terminal's appearance with customizable fonts. JetBrainsMono Nerd Font is recommended, but any Nerd Font will do. Installation options include:
  - **Easiest Method**: Download your preferred font directly from the [Nerd Fonts Download Page](https://www.nerdfonts.com/font-downloads) and install it on your system.
  - **Via Git**: If you prefer to have access to a wide variety of fonts, clone the Nerd Fonts repository with the following command in PowerShell (run as administrator):
    ```bash
    git clone --filter=blob:none --sparse git@github.com:ryanoasis/nerd-fonts
    ```
  - For more options, visit the [Nerd Fonts GitHub Repository](https://github.com/ryanoasis/nerd-fonts).

- **Ubuntu and Windows Terminal**: Install both from the Microsoft Store to ensure a seamless development environment across Windows and Linux.
  - [Ubuntu for WSL](https://www.microsoft.com/store/productId/9NBLGGH4MSV6)
  - [Windows Terminal](https://www.microsoft.com/store/productId/9N0DX20HK701)

- **Visual Studio Code (VSCode)**: A powerful and versatile code editor that supports a wide range of programming languages and tools. Download and install from [VSCode's official site](https://code.visualstudio.com/).

- **VSCode Extensions**: Enhance your coding experience by installing the following extensions in VSCode:
  - [Remote - WSL](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-wsl) for seamless integration with WSL.
  - [GitLens](https://marketplace.visualstudio.com/items?itemName=eamodio.gitlens) for enhanced Git capabilities.
  - [Python](https://marketplace.visualstudio.com/items?itemName=ms-python.python) for comprehensive Python development support.

## Installation Steps

Follow the steps below to set up a new workstation:

### Programs
1. add WSL, Git, python extensions for VSCODE.
2. Replace JSON file in the Terminal applications settings with JSON content contained below

## Installation Steps

Follow these steps to efficiently set up your new workstation:

### Programs

1. Add WSL, Git, and Python extensions for VSCode.
2. Replace the JSON file in the Terminal application's settings with the JSON content provided below.

### Enhancing the Terminal

This section is divided into enhancements for PowerShell and WSL Terminal. These improvements include better formatting, autocomplete, and a customizable prompt, ensuring a more efficient and pleasant command-line experience.

#### PowerShell Enhancements

3. **Optional (For PowerShell users):** If you plan to use both PowerShell and WSL Terminal and wish to manage Conda environments in PowerShell, install Anaconda Navigator on Windows. Then, open `Anaconda Prompt` and initialize Conda for PowerShell:
    ```PowerShell
    conda init powershell
    ```
   This allows PowerShell to run all Conda commands, making `Anaconda Prompt` unnecessary for future use.

**Installing Starship in PowerShell:**

4. **Install Starship using Chocolatey:** If you've followed the earlier steps, you should already have Chocolatey installed. If not, install Chocolatey by following the instructions on Chocolatey's Installation Page. Once Chocolatey is installed, install Starship by running:
    ```PowerShell
    choco install starship
    ```
    
5. **Configure Starship in PowerShell:** To have Starship run automatically when you open PowerShell, you need to add its initialization script to your PowerShell profile.

    First, check if you have a profile set up by running:
    ```PowerShell
    Test-Path $PROFILE
    ```
  
    If this returns `False`, create a new profile by running:
    ```PowerShell
    New-Item -path $PROFILE -type file -force
    ```
    
    Next, open your profile for editing. You can do this with any text editor; for example, to open it with Notepad, run:
    ```PowerShell
    notepad $PROFILE
    ```

    Add the following line to the end of your PowerShell profile:
    ```PowerShell
    Invoke-Expression (&starship init powershell)
    ```

    **Note:** If you encounter an error stating that scripts cannot be run because the execution policy is restricted, you can change the execution policy to allow scripts to run by executing the following command in PowerShell as an administrator:
    ```PowerShell
    Set-ExecutionPolicy RemoteSigned
    ```

    This command allows scripts downloaded from the internet with a trusted signature to run on your system, as well as scripts created locally.
    
    Download the `starship.toml` from the `.config` folder of this GitHub repository and put it in `C:\Users\USERNAME\.julia\config\startup.jl`. This file sets up a bunch of the Starship configuration for you.
	To locate or create this directory, you can use File Explorer or run the following in a Command Prompt: 
    ```PowerShell
    cmd mkdir %USERPROFILE%\.starship
    ```

These steps will install Starship using Chocolatey and configure it to run automatically, enhancing your PowerShell prompt with Starship's features. Remember to restart your PowerShell terminal to see the changes take effect.
#### WSL Terminal Enhancements

The following steps are intended for setting up the WSL Terminal environment. They focus on installing Zsh, Oh My Zsh, plugins, and Starship for a rich terminal experience.

1. **Install Zsh (WSL Terminal):**
    ```bash
    sudo apt install zsh
    ```

2. **Retrieve and apply my dotfiles (WSL Terminal):**
    ```bash
    git clone https://github.com/JDLanctot/dotfiles.git
    cd dotfiles && mv {.,}* .. && cd ..
    rm -rf .git dotfiles
    ```

3. **Install Oh My Zsh (WSL Terminal):**
    ```bash
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    ```

4. **Install zsh-autosuggestions (WSL Terminal):**
    ```bash
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    ```

5. **Add `zsh-autosuggestions` to the plugins list in `.zshrc` (WSL Terminal).**

6. **Install zsh-completions (WSL Terminal):**
    ```bash
    git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions
    ```
    ```bash
    fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src
    ```

7. **Ensure `.zshrc` and `.zshenv` from my GitHub are correctly applied (WSL Terminal).** This setup allows for easy switching between `bash` and `zsh`, both customized. To switch, type `bash` or `zsh` accordingly. If aliases or settings don't work, source the configuration files:
    ```bash
    source ~/.bashrc # For bash
    source ~/.zshrc  # For zsh
    ```

8. **Install Starship for a customizable prompt (WSL Terminal):**
    ```bash
    curl -sS https://starship.rs/install.sh | sh
    ```

9. **Install Unzip, a utility for extracting compressed files (WSL Terminal):**
    ```bash
    sudo apt-get install unzip
    ```

10. **Install Exa, a modern replacement for 'ls' (WSL Terminal):**
    ```bash
    sudo apt-get update
    sudo apt-get -y install exa
    ```

### Python and Anaconda Environments

1. **Install Anaconda (WSL only).** This step is specific to WSL as Anaconda should already be installed and initialized in PowerShell from a previous step (`conda init powershell`). For WSL, follow the comprehensive guide by Kauffmanes [here](https://gist.github.com/kauffmanes/5e74916617f9993bc3479f401dfec7da) to install Anaconda.

2. **Setup for Python projects (Terminal Agnostic).** To start with a Python project, pull from a git repo or create a new directory and `cd` into it. Include a file named `environment.devenv.yml` with necessary dependencies. Here are two examples of what the contents might look like:
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

3. **Create and activate an environment (Terminal Agnostic).** Use the following commands to create and activate the specified environment:
    ```bash
    conda env create --name name --file=environment.devenv.yml
    conda activate name
    ```
   To view all available environments:
    ```bash
    conda env list
    ```

4. **Install the current folder as a package (Terminal Agnostic).** This allows for Python imports from scripts within the same directory:
    ```bash
    pip install -e .
    ```

5. **Run Python scripts (Terminal Agnostic).** Execute any script in the current directory using Python. If zsh configurations from my dotfiles are applied, `p` can be used as an alias for `python3`:
    ```bash
    python3 filename.py
    # Or using the alias:
    p filename.py
    ```

### Julia

**WSL Installation:**

1. **Install Julia on WSL** by downloading and extracting the binary:
    ```bash
    curl -O https://julialang-s3.julialang.org/bin/linux/x64/1.8/julia-1.8.5-linux-x86_64.tar.gz
    tar -xvzf julia-1.8.5-linux-x86_64.tar.gz
    ```
   Note: My dotfiles setup includes a `.julia/config/startup.jl` file which should now be in your home folder.

**Windows Installation:**

1. **Download Julia for Windows** from the [official Julia website](https://julialang.org/downloads/). Choose the Windows installer and follow the installation instructions.

2. **Configure `startup.jl` for Julia on Windows.** If you're setting up Julia on Windows, ensure the `.julia/config/startup.jl` file from my dotfiles is placed in `C:\Users\USERNAME\.julia\config\startup.jl`. This file enhances Julia's startup configuration for an optimized experience.

    To locate or create this directory, you can use File Explorer or run the following in a Command Prompt:
    ```cmd
    mkdir %USERPROFILE%\.julia\config
    ```
    Then, copy the `startup.jl` file into this directory.

### Neovim - Better Code Editing on the Command Line

**WSL Installation:**

1. **Install Neovim (version 0.9+):** This version is required for compatibility with LazyNvim. Ubuntu's stable repository might not have the latest version, so use the unstable PPA:
    ```bash
    sudo add-apt-repository ppa:neovim-ppa/unstable
    sudo apt-get update
    sudo apt-get install neovim
    nvim --version  # Check if the installed version is 0.9+
    ```

2. **Setup Neovim with LazyNvim:** Since the dotfiles now use LazyNvim, the previous step for installing Packer is obsolete. Proceed to configuring Neovim with the provided dotfiles:
    ```bash
    cd ~/.config/nvim
    # Assuming dotfiles have been cloned as per previous instructions
    ```

3. **Install Plugins with LazyNvim:** Open Neovim and execute `:Lazy` then press `Shift + I` to install all plugins based on the configuration files:
    ```bash
    nvim .
    ```

**PowerShell (Windows) Installation:**

1. **Install Neovim:** Ensure Chocolatey is installed (from the Chris Titus debloat tool run during the prerequisite steps), then install Neovim:
    ```powershell
    choco install neovim
    ```
   
2. **Add Neovim to your Path:** To ensure Neovim runs from any directory in PowerShell, add it to your system's Path variable:
    - Search for "Edit the system environment variables" in the Windows search bar.
    - Click "Environment Variables..."
    - In the "User Variables" section, select "Path" and click "Edit..."
    - Click "New" and add the path `C:\tools\neovim\Neovim\bin`
    - Confirm with "OK" and restart PowerShell if necessary.

3. **Configure Neovim for Windows:** Clone the dotfiles and set up Neovim to use them:
    ```powershell
    cd $env:LOCALAPPDATA
    git clone https://github.com/JDLanctot/dotfiles.git nvim
    cd nvim
    Move-Item .config/nvim/* .
    Remove-Item .config -Recurse -Force
    Remove-Item .zsh -Recurse -Force
    Remove-Item .bashrc -Force
    Remove-Item .zshrc -Force
    Remove-Item .zshenv -Force
    Remove-Item README.md -Force
    Remove-Item .git -Recurse -Force
    ```

4. **Install Plugins with LazyNvim:** Open Neovim, ignore any startup errors, and install the plugins:
    ```powershell
    nvim .
    # Inside nvim, run :Lazy followed by Shift + I
    ```

### Webdev with React and NextJs

**Setting up Node.js and pnpm on WSL:**

1. **Install Node.js on WSL:** For web development, including working with React and Next.js, Node.js is a prerequisite. Follow the comprehensive guide provided by Microsoft for [Installing Node.js on Windows Subsystem for Linux (WSL2)](https://learn.microsoft.com/en-us/windows/dev-environment/javascript/nodejs-on-wsl). This guide covers the installation process and ensures that Node.js runs smoothly within the WSL environment.

2. **Install pnpm:** After installing Node.js, it's recommended to use pnpm as your package manager. pnpm offers efficiency advantages over npm, particularly in how it handles node modules to prevent duplication across projects. Install pnpm globally using npm with the following command:
    ```bash
    npm install -g pnpm
    ```

**Why pnpm?**

- **Efficiency:** pnpm creates a single copy of a module for your system and then links it wherever it's needed. This approach saves disk space and speeds up the installation process compared to npm, which duplicates modules in each project's `node_modules` directory.
- **Performance:** By reducing the amount of data to copy during installations, pnpm not only speeds up the setup of new projects but also makes package installation faster and more reliable.

**Next Steps:**

- With Node.js and pnpm installed, you're now ready to start developing with React and Next.js. Create your first project by initializing a new Next.js app or cloning an existing repository.
- For a new Next.js project, you can use the following pnpm command to create a new application:
    ```bash
    pnpm create next-app your-nextjs-app
    ```
- Navigate into your project directory and start the development server to see your new Next.js application in action:
    ```bash
    cd your-nextjs-app
    pnpm run dev
    ```

This setup ensures you have a modern and efficient development environment for working on web projects using React and Next.js within the WSL environment.

## GitHub SSH Setup for PowerShell and WSL

This guide provides a step-by-step walkthrough for setting up SSH keys to securely access GitHub repositories from both PowerShell and WSL (Windows Subsystem for Linux).

### SSH Prerequisites
Before you begin, ensure you have:
- A GitHub account.
- PowerShell for Windows (run as Administrator).
- WSL installed for executing Linux commands.

### Common Steps

1. **Generate an SSH Key**:
    Generate a new SSH key pair using the following command. Replace `"your_email@example.com"` with your GitHub email address. This email will be associated with the SSH key, helping to identify the key's purpose.
    ```bash
    ssh-keygen -t ed25519 -C "your_email@example.com"
    ```
    - Follow the prompts to save the key to the default location (`~/.ssh/id_ed25519`).
    - When prompted, setting a passphrase is optional but recommended for added security.

2. **Add SSH Key to GitHub**:
    Display your new public SSH key and copy it to your clipboard:
    ```bash
    cat ~/.ssh/id_ed25519.pub
    ```
    - Navigate to your GitHub account settings.
    - Go to **SSH and GPG keys** → **New SSH key**.
    - Paste your copied key into the field and save it.

### For PowerShell

3. **Start and Configure ssh-agent**:
    In PowerShell (run as Administrator), set the `ssh-agent` service to start automatically, then start the service:
    ```powershell
    Set-Service -Name ssh-agent -StartupType Automatic
    Start-Service ssh-agent
    ```

4. **Add SSH Key to ssh-agent**:
    Add your new SSH key to the ssh-agent to manage your keys:
    ```powershell
    ssh-add ~/.ssh/id_ed25519
    ```

5. **Test SSH Connection**:
    Test your SSH connection to GitHub:
    ```powershell
    ssh -T git@github.com
    ```
    If successful, you'll receive a welcome message from GitHub.

### For WSL

3. **Start and Configure ssh-agent**:
    In your WSL terminal, start the ssh-agent:
    ```bash
    eval "$(ssh-agent -s)"
    ```

4. **Add SSH Key to ssh-agent**:
    Similarly, add your SSH key to the ssh-agent in WSL:
    ```bash
    ssh-add ~/.ssh/id_ed25519
    ```

5. **Test SSH Connection**:
    Test your connection to GitHub via SSH:
    ```bash
    ssh -T git@github.com
    ```
    Look for a welcome message from GitHub to confirm the connection is successful.

### Repository Configuration

For each Git repository you work with, ensure the remote URL is set to use SSH. This enables secure, key-based authentication for your Git operations:
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
## CLI Tools
### Silver Surfer
Could use ripgrep instead if you want, but I am using ag for searching.
#### Powershell
```powershell
choco install ag
```
#### Linux
```bash
apt-get install silversearcher-ag
```

### Bat
Cat replacement with syntax highlighting.
#### Powershell
```powershell
choco install bat
```
#### Linux
```bash
sudo apt install bat
```

### FZF
Fuzzy finding for files or for previous commands on command line.
#### Powershell
```powershell
choco install fzf
Install-Module -Name PSFzf
```
#### Linux
```bash
sudo apt install fzf
```

### Zoxide
Better cd command.
#### Powershell
```powershell
choco install zoxide
```
#### Linux
```bash
sudo apt install zoxide
```

## Problems When Upgrading Ubuntu
When upgrading Ubuntu:
```bash
sudo apt update && sudo apt full-upgrade && sudo do-release-upgrade
```
There can be some hanging issues when going from 22 to 24 on WSL2 so I made sure to remove snapd first by doing:
```bash
sudo apt remove snapd
```
This package can be added back after upgrade if needed.

Neovim unstable releases can be broken and make an error when trying to run `nvim .` after upgrading.
In my case it was due to having neovim installed from old (jammy) unstable PPA:
remove old repository list, but there may be others so likely better to remove all neovim-ppa ones with the file explorer: 
```bash
sudo rm /etc/apt/sources.list.d/neovim-ppa-unstable-jammy.list
```
add new repository list: 
```bash
sudo add-apt-repository ppa:neovim-ppa/unstable
```
upgrade neovim package: 
```bash
sudo apt update && sudo apt upgrade neovim
```

## Academic Resources
Other GitHub repos to help you with Academic Success.

### LaTex Template
Visit my LaTex Template repo for a template to start writing academic publications in LaTex quick: [LaTex Template](https://github.com/JDLanctot/latex_template). [[Latex Scientific Writing Template]]

### Scholarship Applications
Visit my Scholarship Applications repo for instructions templates for applying to Graduate Level Scholarships, such as NSERC: [Scholarship Applications](https://github.com/JDLanctot/Scholarship-Applications). [[Scholarship Applications]]

### Portfolio Website
Visit Portfolio Website repo for instructions and code to an easy Portfolio Website and host it for FREE using GitHub: [Portfolio Website](https://github.com/JDLanctot/jdlanctot.github.io)). [[J.D.Lanctot's Portfolio]]

## Contributing

If you have any suggestions or improvements for this template, feel free to open an issue or submit a pull request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE.md) file for details. [[LICENSE]]
