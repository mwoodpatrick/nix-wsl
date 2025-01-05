# tmux # Terminal multiplexer
# [A Beginner’s Guide to tmux](https://medium.com/pragmatic-programmers/a-beginners-guide-to-tmux-7e6daa5c0154)
# [tmux wiki](https://github.com/tmux/tmux/wiki)
# [tmux plugins](https://github.com/tmux-plugins/list?tab=readme-ov-file#tmux-plugins)
# [Tmux](https://nixos.wiki/wiki/Tmux)
# [tmuxPlugins - nix](https://search.nixos.org/packages?channel=24.11&from=0&size=50&sort=relevance&type=packages&query=tmuxPlugins)
# [The Best of My Neovim Config 2024](https://levelup.gitconnected.com/the-best-of-my-neovim-config-2024-68ab2357efe7)
# [tmux Getting Started](https://github.com/tmux/tmux/wiki/Getting-Started?form=MG0AV3)
# [Render Images Inside Neovim and Tmux](https://levelup.gitconnected.com/render-images-inside-neovim-and-tmux-bd59381d0746)
# [tmux options](https://nixos.org/manual/nixos/stable/options#opt-programs.tmux.enable)
# [tmux.nix](https://github.com/NixOS/nixpkgs/blob/release-24.11/nixos/modules/programs/tmux.nix)
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
}: {
  programs.tmux = {
    enable = true;
    shortcut = "a"; # set tmux prefix, Ctrl following by this key is used as the main shortcut.
    # set-option -g mouse on # enable mouse
    clock24 = true; # Use 24 hour clock.

    # aggressiveResize = true; -- Disabled to be iTerm-friendly, Resize the window to the size of the smallest session for which it is the current window.
    baseIndex = 1; # start numbering windows and panes from 1
    newSession = true; # Automatically spawn a session if trying to attach and none are running.
    # Stop tmux+escape craziness.
    escapeTime = 0; # Time in milliseconds for which tmux waits after an escape is input.
    # Force tmux to use /tmp for sockets (WSL2 compat)
    secureSocket = false; # Store tmux socket under /run, which is more secure than /tmp, but as a downside it doesn't survive user logout

    terminal = "tmux-256color"; # Set the $TERM variable. Use tmux-direct if italics or 24bit true color
    historyLimit = 100000; # Maximum number of lines held in window history.
    # shell = "${pkgs.fish}/bin/fish";

    extraConfig = ''      # used for less common options, intelligently combines if defined in multiple places.
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

        # set colors for readability
        set -g status-bg cyan # Change the status bar background color.
        set -g window-status-style bg=yellow # Change inactive window color.
        set -g window-status-current-style bg=red,fg=white #  Change active window color
    '';

    plugins = with pkgs; [
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
        plugin = tmuxPlugins.logging;
        extraConfig = ''
        '';
      }
      {
        plugin = tmuxPlugins.tokyo-night-tmux;
        extraConfig = ''
        '';
      }
      {
        plugin = tmuxPlugins.tmux-thumbs;
        extraConfig = ''
        '';
      }
    ];
  };
  # let
  #   tmux-super-fingers =
  #     pkgs.tmuxPlugins.mkTmuxPlugin
  #     {
  #       pluginName = "tmux-super-fingers";
  #       version = "unstable-2023-01-06";
  #       src = pkgs.fetchFromGitHub {
  #         owner = "artemave";
  #         repo = "tmux_super_fingers";
  #         rev = "2c12044984124e74e21a5a87d00f844083e4bdf7";
  #         sha256 = "sha256-cPZCV8xk9QpU49/7H8iGhQYK6JwWjviL29eWabuqruc=";
  #       };
  #     };
  # in {
  #   programs = {
  #     tmux = {
  #       ...
  #       plugins = with pkgs; [
  #         # must be before continuum edits right status bar
  #         {
  #           plugin = tmuxPlugins.catppuccin;
  #           extraConfig = ''
  #             set -g @catppuccin_flavour 'frappe'
  #             set -g @catppuccin_window_tabs_enabled on
  #             set -g @catppuccin_date_time "%H:%M"
  #           '';
  #         }
  #         {
  #           plugin = tmux-super-fingers;
  #           extraConfig = "set -g @super-fingers-key f";
  #         }
  #         tmuxPlugins.better-mouse-mode
  #       ];
  #

  #     };
  #
  #     tmate = {
  #       enable = true;
  #       # FIXME: This causes tmate to hang.
  #       # extraConfig = config.xdg.configFile."tmux/tmux.conf".text;
  #     };
  #   };
  #
  #   home.packages = [
  #     # Open tmux for current project.
  #     (pkgs.writeShellApplication {
  #       name = "pux";
  #       runtimeInputs = [pkgs.tmux];
  #       text = ''
  #         PRJ="''$(zoxide query -i)"
  #         echo "Launching tmux for ''$PRJ"
  #         set -x
  #         cd "''$PRJ" && \
  #           exec tmux -S "''$PRJ".tmux attach
  #       '';
  #     })
  #   ];
}
