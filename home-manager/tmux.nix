# tmux # Terminal multiplexer
# [A Beginner’s Guide to tmux](https://medium.com/pragmatic-programmers/a-beginners-guide-to-tmux-7e6daa5c0154)
# [Tmux](https://nixos.wiki/wiki/Tmux)
# [Setting Up Tmux With Nix Home Manager](https://haseebmajid.dev/posts/2023-07-10-setting-up-tmux-with-nix-home-manager/)
# [tmux - wiki.archlinux.org](https://wiki.archlinux.org/title/Tmux)
# [tmux - github](https://github.com/tmux/tmux)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: let
  tmux-super-fingers =
    pkgs.tmuxPlugins.mkTmuxPlugin
    {
      pluginName = "tmux-super-fingers";
      version = "unstable-2023-01-06";
      src = pkgs.fetchFromGitHub {
        owner = "artemave";
        repo = "tmux_super_fingers";
        rev = "2c12044984124e74e21a5a87d00f844083e4bdf7";
        sha256 = "sha256-cPZCV8xk9QpU49/7H8iGhQYK6JwWjviL29eWabuqruc=";
      };
    };
in {
  programs = {
    tmux = {
      enable = true;
      shortcut = "a";
      clock24 = true;

      # aggressiveResize = true; -- Disabled to be iTerm-friendly
      baseIndex = 1;
      newSession = true;
      # Stop tmux+escape craziness.
      escapeTime = 0;
      # Force tmux to use /tmp for sockets (WSL2 compat)
      secureSocket = false;

      terminal = "tmux-256color";
      historyLimit = 100000;
      shell = "${pkgs.fish}/bin/fish";

      plugins = with pkgs; [
        # must be before continuum edits right status bar
        {
          plugin = tmuxPlugins.catppuccin;
          extraConfig = ''
            set -g @catppuccin_flavour 'frappe'
            set -g @catppuccin_window_tabs_enabled on
            set -g @catppuccin_date_time "%H:%M"
          '';
        }
        {
          plugin = tmuxPlugins.resurrect;
          extraConfig = ''
            set -g @resurrect-strategy-vim 'session'
            set -g @resurrect-strategy-nvim 'session'
            set -g @resurrect-capture-pane-contents 'on'
          '';
        }
        {
          plugin = tmuxPlugins.continuum;
          extraConfig = ''
            set -g @continuum-restore 'on'
            set -g @continuum-boot 'on'
            set -g @continuum-save-interval '10'
          '';
        }
        {
          plugin = tmux-super-fingers;
          extraConfig = "set -g @super-fingers-key f";
        }
        tmuxPlugins.better-mouse-mode
      ];

      extraConfig = ''          # used for less common options, intelligently combines if defined in multiple places.
             # ...
             set -g status-right '#[fg=black,bg=color15] #{cpu_percentage}  %H:%M '
             run-shell ${pkgs.tmuxPlugins.cpu}/share/tmux-plugins/cpu/cpu.tmux
        # https://old.reddit.com/r/tmux/comments/mesrci/tmux_2_doesnt_seem_to_use_256_colors/
        set -g default-terminal "xterm-256color"
        set -ga terminal-overrides ",*256col*:Tc"
        set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q'
        set-environment -g COLORTERM "truecolor"

        # Mouse works as expected
        set-option -g mouse on
        # easy-to-remember split pane commands
        bind | split-window -h -c "#{pane_current_path}"
        bind - split-window -v -c "#{pane_current_path}"
        bind c new-window -c "#{pane_current_path}"
      '';
    };

    tmate = {
      enable = true;
      # FIXME: This causes tmate to hang.
      # extraConfig = config.xdg.configFile."tmux/tmux.conf".text;
    };
  };

  home.packages = [
    # Open tmux for current project.
    (pkgs.writeShellApplication {
      name = "pux";
      runtimeInputs = [pkgs.tmux];
      text = ''
        PRJ="''$(zoxide query -i)"
        echo "Launching tmux for ''$PRJ"
        set -x
        cd "''$PRJ" && \
          exec tmux -S "''$PRJ".tmux attach
      '';
    })
  ];
}
