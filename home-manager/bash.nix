{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: let
  GIT_ROOT = "/mnt/wsl/projects/git";
  NIX_CFG_DIR = "${GIT_ROOT}/nix-wsl";
  # NIX_CFG_DIR = builtins.trace "my hack NIX_CFG_DIR=${xx}" xx;
  HM_CFG = "#mwoodpatrick@nix-wsl";
in {
  programs.bash = {
    enable = true;
    enableCompletion = true;
    # Add your custom bashrc here
    bashrcExtra = ''
      # added from home.nix
      source ~/.nix-profile/etc/profile.d/hm-session-vars.sh
      #end, added from home.nix
    '';

    # set some aliases, feel free to add more or remove some
    shellAliases = {
      c = "clear";
      h = "history";
      hl = "history|less";
      ht = "history|tail -40";
      he = "home-manager -f $NIX_CFG_DIR/home-manager/home.nix edit";
      hf = "nix fmt $NIX_CFG_DIR/home-manager/home.nix";
      hs = "home-manager --flake ${NIX_CFG_DIR}${HM_CFG} switch;source ~/.bashrc";
      hsi = "home-manager --impure --flake ${NIX_CFG_DIR}${HM_CFG} switch;source ~/.bashrc";
      myps = "ps -w -f -u $USER";
      cdn = "cd $NIX_CFG_DIR";
      ne = "nvim $NIX_CFG_DIR/flake.nix";
      ns = "sudo nixos-rebuild switch --flake $NIX_CFG";
      ngc = "nix-collect-garbage -d";
      j = "jobs";
      k = "kubectl";
      urldecode = "python3 -c 'import sys, urllib.parse as ul; print(ul.unquote_plus(sys.stdin.read()))'";
      urlencode = "python3 -c 'import sys, urllib.parse as ul; print(ul.quote_plus(sys.stdin.read()))'";
      wsl = "wsl.exe";
      wterm = "/mnt/c/Program\\ Files/WezTerm/wezterm.exe &";
    };
  };
}
