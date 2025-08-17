# Rebuild:
#
# cd /mnt/wsl/projects/git/nix-wsl/nixos/NixOS-25.05
# rebuild: sudo nixos-rebuild switch --flake $PWD#my-nix2505_wsl
# format:  nix fmt .
# outputs:  nix flake show
# checkers:
#	statix check -o json configuration.nix 2>&1 | tee statix_check.log
#	deadnix configuration.nix

# The `@{self, ...}@inputs` syntax in a Nix flake's `outputs` specification is a way to simultaneously **destructure an attribute set and bind the entire set to a single variable**.
#
# It combines two concepts:
# * **Destructuring:** The part inside the braces (`{self, nixpkgs, ...}`). This creates local variables with the same names as the attributes in the set. For example, `nixpkgs` becomes a variable you can use directly.
# * **Binding:** The `@inputs` part. This assigns the entire attribute set to a new variable named `inputs`. This is often called "at-binding."
#
# ### What it Does in Practice
#
# This syntax is extremely useful and common in Nix flakes because it gives you the best of both worlds:
#
# 1.  **Easy Access to Individual Inputs:** You can directly access the most important flake inputs as their own variables (e.g., `nixpkgs.lib.nixosSystem`, `nixos-wsl.nixosModules.default`). This makes your code more concise and readable.
#
# 2.  **Passes the Entire Set to Modules:** It creates a single variable (`inputs`) that contains all the flake inputs. You can then pass this entire set to your other modules using `specialArgs = { inherit inputs; };`. This is a crucial step that allows any module in your configuration to access all the flake's dependencies.
#
# In this `flake.nix` example, `@{self, nixpkgs, ...}@inputs` essentially says:
# "For all the outputs, please give me the individual flake inputs (like `nixpkgs` and `nixos-wsl`)
# as their own variables. Also, please give me a variable named `inputs` that contains the entire set
# of all the flake inputs, which I will pass to my NixOS configuration."

{
  description = "A basic NixOS flake for NixOS on WSL2";

  inputs = {
    # The NixOS package collection
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # The official NixOS-WSL project, which provides the necessary modules
    nixos-wsl.url = "github:nix-community/NixOS-WSL";

    # An optional input for managing user-specific configurations
    home-manager.url = "github:nix-community/home-manager";

    # Optional: Add other flakes here, like home-manager or nixos-wsl
  };

  outputs =
    {
      self,
      nixpkgs,
      nixos-wsl,
      home-manager,
      ...
    }@inputs:
    let
      # Use a specific system architecture
      system = "x86_64-linux";
      # Import nixpkgs with the correct system and config
      pkgs = import nixpkgs {
        inherit system;
      };
    in

    {
      checksxz.${system} = {
        fmt = pkgs.runCommand "fmt-check" { } ''
          echo "== Running nix fmt =="
          nix fmt -- --check ${self}
          touch $out
        '';

        statix = pkgs.runCommand "statix-check" { } ''
          echo "== Running statix =="
          statix check ${self}
          touch $out
        '';

        deadnix = pkgs.runCommand "deadnix-check" { } ''
          echo "== Running deadnix =="
          deadnix ${self}
          touch $out
        '';
      };
      checks.${system} = {
        # Run nixpkgs-fmt in check mode
        fmt = pkgs.runCommand "fmt-check" { buildInputs = [ pkgs.nixpkgs-fmt ]; } ''
          echo "== Running nixpkgs-fmt =="
          nixpkgs-fmt --check ${self}
          touch $out
        '';

        # Run statix (Nix anti-pattern linter)
        statix = pkgs.runCommand "statix-check" { buildInputs = [ pkgs.statix ]; } ''
          echo "== Running statix =="
          statix check ${self}
          touch $out
        '';

        # Run deadnix (detect unused code in Nix files)
        deadnix = pkgs.runCommand "deadnix-check" { buildInputs = [ pkgs.deadnix ]; } ''
          echo "== Running deadnix =="
          deadnix ${self}
          touch $out
        '';

        # Example: run prettier for JS/TS if present
        prettier = pkgs.runCommand "prettier-check" { buildInputs = [ pkgs.nodePackages.prettier ]; } ''
          echo "== Running prettier =="
          prettier --check .
          touch $out
        '';
      };
      # Define a check that runs all your linters and formatters
      xxchecks.${system} = pkgs.stdenv.mkDerivation {
        name = "my-flake-lint-check";
        src = self;
        buildInputs = [
          nixpkgs.statix
          nixpkgs.deadnix
          # ... other linters
        ];
        dontBuild = true;
        installPhase = ''
          statix check .
          deadnix .
          # etc.
          mkdir -p $out
        '';
      };

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-tree;
      nixosConfigurations.my-nix2505_wsl = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          # The core module from the nixos-wsl project
          nixos-wsl.nixosModules.default

          # Your main configuration file this is where you'll define your user, packages, and services.
          ./configuration.nix

          # Optional: The home-manager module for user-specific config
          home-manager.nixosModules.home-manager
        ];

        # This line is crucial. It passes all the flake inputs
        # as arguments to your modules, allowing you to access them.
        # This allows you to access `inputs.nixpkgs`, `inputs.home-manager`, etc.
        specialArgs = { inherit inputs; };
      };
    };
}
