# dotfiles
Repo for all of my dotfiles

Typically I do the following when setting up a new workstation

1. Enable Windows Features: Windows Subsystem for Liniux, Virtual Machine Platform.
2. Install the newest Powershell on Windows.
3. Install VSCODE on Windows.
4. git my username and email on the command line.
5. add WSL, Git, python extensions for VSCODE.
6. Install Ubuntu and Terminal from the app store on Windows.
7. Install a Nerdfont on Windows (POWERSHELL):
	```git clone --filter=blob:none --sparse git@github.com:ryanoasis/nerd-fonts```
8. Replace JSON with json content from my repo for the Terminal Settings.
9. From the Ubuntu Command Line install Zsh  
	```sudo apt install zsh```
10. Get my dotfiles
	```git clone https://github.com/JDLanctot/dotfiles.git```
	```mv dotfiles/{.,}* .```
	```rm -r .git```
	```rm -r dotfiles```
11. Install ohmyzsh  
	```sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"```
12. Install zsh-autocompletions  
	```git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions  ```
13. Add it to the plugins list in .zshrc
14. Install zsh-completions  
	```git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions  ```
	```fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src```
15. Get my dotfiles for .zsh and update the one that ohmyzsh made and add the .zsh folder
16. Install Starship
	```curl -sS https://starship.rs/install.sh | sh```
17. Install Unzip
	```sudo apt-get install unzip```
18. Install Exa 
	```sudo apt-get update```
	```sudo apt-get -y install exa```
19. Install anaconda on Ubuntu 
20. Pull from a git repo
21. Create an env from the repo  
	```conda env create --name name --file=environment.devenv.yml```
22. cd into the folder and add the package itself  
	```pip install -e .```
23. Install Julia  
  	```curl -O https://julialang-s3.julialang.org/bin/linux/x64/1.8/julia-1.8.5-linux-x86_64.tar.gz```   
  	```tar -xvzf julia-1.8.5-linux-x86_64.tar.gz```
24. Install version 0.9+ of Neovim (Here I use the unstable ppa because Ubuntu only has up to 0.6 in the stable repository but in the future /unstable will be sufficient. Last command here echos the version to check if you have installed a version that is 0.9+.)
	```sudo add-apt-repository ppa:neovim-ppa/unstable```
	```sudo apt-get update```
	```sudo apt-get install neovim```
	```nvim --version```
25. Install Packer
	```git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 	~/.local/share/nvim/site/pack/packer/start/packer.nvim```
26. Go to the nvim directory
	```cd .config/nvim```
27. Open this directory in Neovim
	```nvim .```
28. There will be a ton of errors. Navigate past them and navigate into the toofaeded folder in lua and open the packer.lua file.
29. Source it and synch the packages (you may also have to source the init.lua in the .config/nvim folder).
	```:so```
	```:PackerSync```
30. Quit nvim and restart it and all of the changes should be implemented.
