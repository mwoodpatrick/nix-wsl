{ ... }:
{
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
      he = "nvim $NIXOS_CONFIG_ROOT/home/home.nix";
      hs = "home-manager switch --flake $NIXOS_CONFIG_ROOT/home;source ~/.bashrc";
      myps = "ps -w -f -u $USER";
      ncd = "cd $NIXOS_CONFIG_ROOT";
      ne = "nvim $NIXOS_CONFIG_ROOT/flake.nix";
      ns = "sudo nixos-rebuild switch --flake $NIXOS_CONFIG_ROOT#my-nix2505_wsl";
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
