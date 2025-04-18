# Rebuild:
#
# cd /mnt/wsl/projects/git/nix-wsl/nixos/basic
# sudo nixos-rebuild switch --flake $PWD#nixos
{
  description = "A simple NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
  };

  outputs = { self, nixpkgs, nixos-wsl, ... }@inputs: {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        # Set all inputs parameters as special arguments for all submodules,
        # so you can directly use all dependencies in inputs in submodules
        specialArgs = { inherit inputs; };

        modules = [
          # This includes the options for the WSL specific settings.
          nixos-wsl.nixosModules.default

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
