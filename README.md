# dotfiles
Repo for all of my dotfiles

Typically I do the following when setting up a new workstation

1. Enable Windows Features: Windows Subsystem for Liniux, Virtual Machine Platform.
2. Install the newest Powershell on Windows.
3. Install VSCODE on Windows.
4. git my username and email on the command line.
5. add WSL, Git, python extensions for VSCODE.
6. Install Ubuntu and Terminal from the app store on Windows.
7. Install a Nerdfont on Windows.
8. Replace JSON with json content from my repo for the Terminal Settings.
9. From the Ubuntu Command Line install Zsh  
	```sudo apt install zsh```
10. Install ohmyzsh  
	```sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"```
11. Install zsh-autocompletions  
	```git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions  ```
12. Add it to the plugins list in .zshrc
13. Install zsh-completions  
	```git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions  ```
	```fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src```
14. Get my dotfiles for .zsh and update the one that ohmyzsh made and add the .zsh folder
15. Install Starship
	```curl -sS https://starship.rs/install.sh | sh```
16. Install Unzip
	```sudo apt-get install unzip```
17. Install Exa 
	```sudo apt-get update```
	```sudo apt-get -y install exa```
18. Install anaconda on Ubuntu 
19. Pull from a git repo
20. Create an env from the repo  
	```conda env create --name name --file=environment.devenv.yml```
21. cd into the folder and add the package itself  
	```pip install -e .```
22. Install Julia  
  	```curl -O https://julialang-s3.julialang.org/bin/linux/x64/1.8/julia-1.8.3-linux-x86_64.tar.gz```   
  	```tar -xvzf julia-1.8.3-linux-x86_64.tar.gz```
