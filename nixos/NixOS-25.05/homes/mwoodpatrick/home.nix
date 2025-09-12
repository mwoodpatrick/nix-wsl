{ config, pkgs, lib, ... }:
let
  utils = import ./utils.nix { inherit lib; };
  # Read all files in this directory
  files = builtins.attrNames (builtins.readDir ./.);
# Import every .nix file except home.nix itself
  otherModules = utils.importAll ./ ["home.nix"] 
in
{
  home-manager = {
    # It's good practice to set this to a recent version
    # stateVersion = "25.05";

    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.


    # Define a specific user for Home Manager to manage
    users.mwoodpatrick = { pkgs, ... }: {
      home = {
        username = "mwoodpatrick";
        homeDirectory = "/home/mwoodpatrick";
        stateVersion = "25.05";

        # Home Manager can also manage your environment variables through
        # 'home.sessionVariables'. These will be explicitly sourced when using a
        # shell provided by Home Manager. If you don't want to manage your shell
        # through Home Manager then you have to manually source 'hm-session-vars.sh'
        # located at either
        #
        #  /etc/profiles/per-user/mwoodpatrick/etc/profile.d/hm-session-vars.sh
        #
        # or
        #
        #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
        #
        # or
        #
        # Note these env vars are written to:
        #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
        sessionVariables = {
          EDITOR = "nvim";
          GIT_ROOT = "/mnt/wsl/projects/git";
          KIND_EXPERIMENTAL_PROVIDER = "podman";
          LIBGL_ALWAYS_SOFTWARE = 1; # Need for Flutter since hardware render does not work on my laptops!
          NIX_CFG_DIR = "$GIT_ROOT/nix-wsl";
          NIXOS_CONFIG_ROOT="$NIX_CFG_DIR/nixos/NixOS-25.05"
          PATH = "$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin";
          UV_PYTHON_DOWNLOADS = "never"; # Normal python does not work in NixOS
          # PS1=''\u@\h:\w\ myenv$ ''; # Currently trying out starship
          DIRENV_LOG_FORMAT = ""; # disable direnv output
          # TODO: Check if running on WSL does not appear to work (check for some other env var)
          WSL = if pkgs.hostPlatform.isWindows then "true" else "false";
        };

      };

      # [ nvf.homeManagerModules.default ] ++
      imports = map (f: ./. + "/${f}") otherModules;

      programs = {
        # Let Home Manager install and manage itself.
        home-manager.enable = true;
        ripgrep.enable =true;
        fd.enable =true;
      };
    };
  };
}
