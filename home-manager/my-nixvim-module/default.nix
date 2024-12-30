# { config, pkgs, ... }:
{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
#   nixvim = import (builtins.fetchGit {
#     url = "https://github.com/nix-community/nixvim";
#     ref = "main";
#   });
  cfg = config.mynixvim;
in {
  imports = [
    # paths of other modules
    # nixvim.homeManagerModules.nixvim
  ];

  options = {
    # option declarations
    mynixvim = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable my custom service.";
      };
      message = mkOption {
        type = types.str;
        default = "Hello, world!";
        description = "A custom message for my service.";
      };
    };
  };

  # config = mkIf cfg.enable {
  config = mkIf cfg.enable {
    # option definitions
#     nixvim = {
#       enable = true;
#       colorschemes.catppuccin.enable = true;
#       plugins.lualine.enable = true;
#     };
  };
}
# {
#   options.services.  };
#
#     # home-manager --impure --flake /mnt/wsl/projects/git/nix-wsl#mwoodpatrick@nix-wsl switch
#     services.myService = {
#       description = "My Custom Service";
#       wantedBy = [ "multi-user.target" ];
#
#       serviceConfig = {
#         ExecStart = "${pkgs.coreutils}/bin/echo ${cfg.message}";
#       };
#     };
#   };
# }

