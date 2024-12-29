# A Flake for installing & running NixOS on WSL-2

# Create GIT Repository
```
cd $GIT_ROOT
mkdir nix-wsl
cd !$
nix flake init -t github:misterio77/nix-starter-config#standard
echo "# nix-westie" >> README.md
git init
git add README.md
git commit -m "first commit"
git branch -M main
git remote add origin https://github.com/mwoodpatrick/nix-westie.git
git push -u origin main
nix flake check
```

# Install WSL Distro

```
cd /mnt/c/Users/mlwp/Distros/NixOS
wget https://github.com/nix-community/NixOS-WSL/releases/download/2405.5.4/nixos-wsl.tar.gz
wsl --import nix-wsl C:\Users\mlwp\Software\WSL\Distros\nix-wsl nixos-wsl.tar.gz --version 2
wsl -d nix-wsl
```

Ensure you're running the latest NixOS and NixOS-WSL versions

```
sudo nix-channel --update
sudo nixos-rebuild switch
```

# Configuring GitHub

Configure Git to remember my credentials (username and password) by saving them in plain text in a file located at ~/.git-credentials.

Specify that Git should merge changes to maintain the context of branch merges & show
a complete history.

```
git config --global user.name mwoodpatrick
git config --global user.email mwoodpatrick@gmail.com
git config --global credential.helper store
git config --global core.editor nvim
git config pull.rebase false
git config --list
```

# Switching to Flakes

```
cd /mnt/wsl/projects/git/nix-westie
nix-shell -p git
sudo nixos-rebuild switch --flake .#nix-wsl
home-manager --flake .#mwoodpatrick@nix-wsl switch
```
