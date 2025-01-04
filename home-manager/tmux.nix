# tmux # Terminal multiplexer
# [A Beginner’s Guide to tmux](https://medium.com/pragmatic-programmers/a-beginners-guide-to-tmux-7e6daa5c0154)
# [Tmux](https://nixos.wiki/wiki/Tmux)
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
      clock24 = true;
      extraConfig = ''        # used for less common options, intelligently combines if defined in multiple places.
           # ...
           set -g status-right '#[fg=black,bg=color15] #{cpu_percentage}  %H:%M '
           run-shell ${pkgs.tmuxPlugins.cpu}/share/tmux-plugins/cpu/cpu.tmux
      '';
    };
}
