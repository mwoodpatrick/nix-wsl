# Rebuild:
#
# cd /mnt/wsl/projects/git/nix-wsl/nixos/basic
# sudo nixos-rebuild switch --flake $PWD#nixos
{
  description = "Flake for VM enabled NixOS";

  inputs = {
    # Nixpkgs
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    # You can access packages and modules from different nixpkgs revs
    # at the same time. Here's an working example:
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    # [NixOS-WSL](https://nix-community.github.io/NixOS-WSL/)
    # [NixOS-WSL](https://github.com/nix-community/NixOS-WSL)
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-ld.url = "github:Mic92/nix-ld";
    flake-utils.url = "github:numtide/flake-utils";
    # this line assume that you also have nixpkgs as an input
    nix-ld.inputs.nixpkgs.follows = "nixpkgs";

    # AI
    cursor.url = "github:omarcresp/cursor-flake/main";
    # claude-desktop.url = "github:k3d3/claude-desktop-linux-flake";
    # claude-desktop.inputs.nixpkgs.follows = "nixpkgs";
    # claude-desktop.inputs.flake-utils.follows = "flake-utils";
  };

  outputs = { 
    self, 
    nixpkgs, 
    nixos-wsl, 
    nix-ld, 
    cursor, 
    # nixvim,
    # microvm,
    # minecraft,
    ... }@inputs: {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        # Set all inputs parameters as special arguments for all submodules,
        # so you can directly use all dependencies in inputs in submodules
        specialArgs = { inherit inputs; };

        modules = [
          # This includes the options for the WSL specific settings.
          nixos-wsl.nixosModules.default
          # (Setup VSCode Remote)[https://nix-community.github.io/NixOS-WSL/how-to/vscode.html]
          # (nix-ld)[https://github.com/nix-community/nix-ld]
          # ... add this line to the rest of your configuration modules
          nix-ld.nixosModules.nix-ld

          # The module in this repository defines a new module under (programs.nix-ld.dev) instead of (programs.nix-ld)
          # to not collide with the nixpkgs version.
          { programs.nix-ld.dev.enable = true; }

          # host configuration
          ./configuration.nix

          # This module works the same as the `specialArgs` parameter we used above
          # choose one of the two methods to use
          # { _module.args = { inherit inputs; };}
        ];
      };
    };
  };
}
