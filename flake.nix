# Get latest nix info & downloads
# https://nixos.org/
# https://nixos.org/download/
# Use nix flake update to update to latest version of packages
# Use nix flake metadata to get last modified date and dependencies
# Use nix fmt <path>.nix to format x nix file
# For sources of inspiration see:
# [Rebuilding my NixOS config - Part 0: ≡ƒöº NixOS Flakes & Git Basics: Everything You Need to Know](https://www.youtube.com/watch?v=43VvFgPsPtY)
# [m3tam3re/nixcfg](https://code.m3tam3re.com/m3tam3re/nixcfg.git)
# [YouTube/](https://www.youtube.com/@m3tam3re)
#
# based on:
# [Misterio77/nix-starter-configs](https://github.com/Misterio77/nix-starter-configs)
# [standard/flake.nix](https://github.com/Misterio77/nix-starter-configs/blob/main/standard/flake.nix)
# [Misterio77nix-config](https://github.com/Misterio77/nix-config)
#
# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL
# https://nix-community.github.io/NixOS-WSL/
# https://nix-community.github.io/NixOS-WSL/install.html
# https://nix-community.github.io/NixOS-WSL/options.html
# https://nix-community.github.io/NixOS-WSL/how-to/nix-flakes.html
# https://nix-community.github.io/NixOS-WSL/how-to/vscode.html
# https://wiki.nixos.org/wiki/WSL
#
# [Wombat’s Book of Nix](https://mhwombat.codeberg.page/nix-book/)
# [nix-book](https://github.com/mwoodpatrick/nix-book)
# [NixOS & Flakes Book](https://nixos-and-flakes.thiscute.world/)
# [nixos-and-flakes-book](https://github.com/mwoodpatrick/nixos-and-flakes-book)
{
  description = "My WSL-2 Flake based NixOS configuration";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    # You can access packages and modules from different nixpkgs revs
    # at the same time. Here's an working example:
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # Also see the 'unstable-packages' overlay at 'overlays/default.nix'.

    # [NixOS-WSL](https://nix-community.github.io/NixOS-WSL/)
    # [NixOS-WSL](https://github.com/nix-community/NixOS-WSL)
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Home manager
    # [Questions about system-level flake on a multi-user setup - Help - NixOS Discourse](
    #  https://discourse.nixos.org/t/questions-about-system-level-flake-on-a-multi-user-setup/27562)
    # Allow each user to control their own home-manager flake so they own their own files.
    # [Workstation set-up with multiple users](https://www.reddit.com/r/NixOS/comments/1arf373/workstation_setup_with_multiple_users/?rdt=59466)

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # [nixvim](https://nix-community.github.io/nixvim/user-guide/install.html)
    # install nixvim using home-manager
    # nixvim = {
      # url = "github:nix-community/nixvim"; # unstable channel
      # If using a stable channel you can use `url = "github:nix-community/nixvim/nixos-<version>"`
    #   url = "github:nix-community/nixvim/nixos-24.11";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # [microvm.nix docs](https://astro.github.io/microvm.nix/)
    # [microvm.nix my fork](https://github.com/mwoodpatrick/microvm.nix)
    # [microvm.nix upstream repo](https://github.com/astro/microvm.nix)
    # [microvm-examples](https://github.com/Soikr/microvm-examples/tree/main)
    # microvm = {
      # url = "github:mwoodpatrick/microvm.nix";
    #  url = "github:astro/microvm.nix";
    #  inputs.nixpkgs.follows = "nixpkgs";
    # };

    # [nix-minecraft](https://github.com/Infinidoge/nix-minecraft)
    # minecraft = {
    #   url = "github:Infinidoge/nix-minecraft";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs = {
    self,
    nixpkgs,
    nixos-wsl,
    home-manager,
    nixvim,
    # microvm,
    # minecraft,
    ...
  } @ inputs: let
    inherit (self) outputs inputs;
    # Supported systems for your flake packages, shell, etc.
    systems = [
      # "aarch64-linux"
      # "i686-linux"
      "x86_64-linux"
      # "aarch64-darwin"
      # "x86_64-darwin"
    ];
    # This is a function that generates an attribute by calling a function you
    # pass to it, with each system as an argument
    forAllSystems = nixpkgs.lib.genAttrs systems;
    system = "x86_64-linux";
    user = "mwoodpatrick";
    hostname = "nix-wsl";
  in {
    # Your custom packages
    # Accessible through 'nix build', 'nix shell', etc
    packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
    # Formatter for your nix files, available through 'nix fmt'
    # Other options beside 'alejandra' include 'nixpkgs-fmt'
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    # Your custom packages and modifications, exported as overlays
    overlays = import ./overlays {inherit inputs;};
    # Reusable nixos modules you might want to export
    # These are usually stuff you would upstream into nixpkgs
    nixosModules = import ./modules/nixos;
    # Reusable home-manager modules you might want to export
    # These are usually stuff you would upstream into home-manager
    homeManagerModules = import ./modules/home-manager;

    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    # TODO: nixpkgs.hostPlatform versus the legacy option nixpkgs.system
    nixosConfigurations = {
      # your hostname
      ${hostname} = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit self inputs outputs user hostname;};
        modules = [
          # NixOS-WSL.nixosModules.wsl
          nixos-wsl.nixosModules.default
          {
            system.stateVersion = nixpkgs.lib.mkForce "24.11";
            wsl.enable = true;
          }
          # > Our main nixos configuration file <
          ./nixos/configuration.nix
          # [Preparing a NixOS host for declarative MicroVMs](https://astro.github.io/microvm.nix/host.html)
          # microvm.nixosModules.host
          # ./vms
        ];
      };

      # Example = nixpkgs.lib.nixosSystem {
      #   inherit system;
      #   modules = [
      #     microvm.nixosModules.microvm
      #     ./vms/Example
      #   ];
      # };

      # Minecraft = nixpkgs.lib.nixosSystem {
      #   inherit system;
      #   specialArgs = {inherit inputs user minecraft;};

      #   modules = [
      #     microvm.nixosModules.microvm
      #     minecraft.nixosModules.minecraft-servers
      #     ./vms/Minecraft
      #   ];
      # };
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations = {
      # replace with your username@hostname
      "${user}@${hostname}" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [
          # > Our main home-manager configuration file <
          ./home-manager/home.nix
        ];
      };
    };
  };
}
