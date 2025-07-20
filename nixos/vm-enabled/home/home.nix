{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "mwoodpatrick";
  home.homeDirectory = "/home/mwoodpatrick";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home# .username}!"
    # '')

    # utils

    # (15 rust cli tools that will make you abandon bash scripts forever)[https://medium.com/@devlink/15-rust-cli-tools-that-will-make-you-abandon-bash-scripts-forever-0120bbfe473c]
    ripgrep # recursively searches directories for a regex pattern
    fd # find
    bat # cat, but with syntax highlighting, line numbers, git diff
    eza # tree view, color coded, git status, Human-readable file sizes
    procs # Color-coded, Displays CPU & memory usage, PID, command, user, runtime, Supports JSON and YAML output
    dust # du with Visual bar charts for file/folder size, color coded
    # bottom # missing in nix? Real-time graphs for CPU, RAM, disk, network, and temperatures
    tokei # Lines of code vs comments vs blanks, Total files and code stats
    bandwhich # Shows real-time bandwidth usage per processes, Displays remote addresses, ports, and protocols
    gping # Terminal-based latency graphs
    hyperfine # measure execution times, gives mean, min, max, stddev, exporting results to JSON, Markdown, CSV
    zoxide # cd with memory, Supports fuzzy matching
    cargo # Rust's package manager
    just # Modern build system supports variables, conditionals, and shell settings
    nodejs_23

    jq # A lightweight and flexible command-line JSON processor
    yq-go # yaml processor https://github.com/mikefarah/yq
    fzf # A command-line fuzzy finder
    feh # [FEH - light-weight, configurable and versatile image viewer](https://feh.finalrewind.org/)
    git-lfs
    tmux
    htop
    fortune
    uv

    # archives
    zip
    xz
    unzip
    p7zip
  ];

  # [](https://wiki.nixos.org/wiki/Starship)
  # [starship](https://starship.rs) - an customizable prompt for any shell
  # [github:startship](https://github.com/spaceship-prompt/spaceship-prompt)

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/mwoodpatrick/etc/profile.d/hm-session-vars.sh
  #

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
  home.sessionVariables = {
    EDITOR = "nvim";
    GIT_ROOT = "/mnt/wsl/projects/git";
    KIND_EXPERIMENTAL_PROVIDER = "podman";
    LIBGL_ALWAYS_SOFTWARE = 1; # Need for Flutter since hardware render does not work on my laptops!
    NIX_CFG_DIR="$GIT_ROOT/nix-wsl";
    PATH = "$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin";
    UV_PYTHON_DOWNLOADS = "never"; # Normal python does not work in NixOS
    # PS1=''\u@\h:\w\ myenv$ ''; # Currently trying out starship
    DIRENV_LOG_FORMAT=""; # disable direnv output
    # TODO: Check if running on WSL does not appear to work (check for some other env var)
    WSL = if pkgs.hostPlatform.isWindows then "true" else "false";
  };
  # Let Home Manager install and manage itself.
  programs = {
    home-manager.enable = true;
    bash = {
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
        c  = "clear";
        h  = "history";
        hl = "history|less";
        ht = "history|tail -40";
        he = "nvim $NIXOS_CONFIG_ROOT/home/home.nix";
        hs = "home-manager switch --flake $NIXOS_CONFIG_ROOT/home;source ~/.bashrc";
        myps = "ps -w -f -u $USER";
        ncd = "cd $NIXOS_CONFIG_ROOT";
        ne = "nvim $NIXOS_CONFIG_ROOT/flake.nix";
        ns = "sudo nixos-rebuild switch --flake $NIXOS_CONFIG_ROOT#nixos";
        ngc = "nix-collect-garbage -d";
        j = "jobs";
        k = "kubectl";
        urldecode = "python3 -c 'import sys, urllib.parse as ul; print(ul.unquote_plus(sys.stdin.read()))'";
        urlencode = "python3 -c 'import sys, urllib.parse as ul; print(ul.quote_plus(sys.stdin.read()))'";
        wsl = "wsl.exe";
        wterm = "/mnt/c/Program\\ Files/WezTerm/wezterm.exe &";
      };
    };
#    vscode = {
#      enable = true;
#      extensions = with pkgs.vscode-extensions; [
#        dracula-theme.theme-dracula
#        vscodevim.vim
#        yzhang.markdown-all-in-one
#      ];
#    };
    # [nix-direnv](https://github.com/nix-community/nix-direnv)
    # [direnv](https://direnv.net/)
    # [Effortless dev environments with Nix and direnv](https://determinate.systems/posts/nix-direnv/)
    # [github:direnv](https://github.com/direnv/direnv)
    direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };
  # [Firefox](https://nixos.wiki/wiki/Firefox)
    firefox.enable = true;   

    # Enable the Git program configuration
    git = {
      enable = true;
      lfs.enable = true;

      # Global user settings
      userEmail = "mwoodpatrick@gmail.com"; # your email
      userName = "Mark L. Wood-Patrick"; # your name

      # Global Git options (equivalent to git config --global)
      extraConfig = {
        # Core settings
        core = {
          editor = "nvim"; # Your preferred Git editor (e.g., "vim", "code --wait", "nano")
          # autoCrlf = "input"; # For consistent line endings, especially on Windows/WSL
          # pager = "delta"; # If you use a custom pager like delta
        };
  
        # Aliases
        alias = {
          co = "checkout";
          br = "branch";
          ci = "commit";
          st = "status";
          lg = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
        };
  
        # Credential helper (important for GitHub/GitLab authentication)
        credential = {
          helper = "store"; # Or "cache", or a more secure helper if needed
          # store = {
          #   helper = "cache --timeout=3600"; # Cache credentials for 1 hour
          # };
        };
  
        # Include other files (useful for organizing per-host or sensitive configs)
        # include = {
        #   path = "~/path/to/my/other-git-config";
        # };
  
        # Protocol helpers (e.g., for GitHub CLI or specific protocols)
        # url."git@github.com:".insteadOf = "https://github.com/";
  
        # Push settings
        push = {
          default = "current"; # Pushes the current branch to the same-named remote branch
        };
  
        # Pull settings
        pull = {
          rebase = true; # Prefer rebase over merge for 'git pull'
        };
  
        # Diff settings (e.g., using diff-so-fancy or delta)
        # diff = {
        #   tool = "default-difftool";
        # };
        # difftool."default-difftool".cmd = "nvim -d \"$LOCAL\" \"$REMOTE\"";
  
        # Init template directory (for custom Git hooks or templates)
        # init = {
        #   templatedir = "~/.git_template";
        # };
  
        # Signing commits
        # commit = {
        #   gpgsign = true;
        # };
        # gpg.program = "gpg"; # Path to your GPG program
      };
  
      # Or you can use specific options for common configurations:
      # enableLfs = true; # To enable Git LFS support
      # ignores = [ ".DS_Store" "node_modules/" ]; # Global .gitignore entries
    };

    starship = {
      enable = true;
      # custom settings
      settings = {
        add_newline = true;
        command_timeout = 1300;
        scan_timeout = 50;
        format = "$all$nix_shell$nodejs$lua$golang$rust$php$git_branch$git_commit$git_state$git_status\n$username$hostname$directory";
        character = {
          success_symbol = "[](bold green) ";
          error_symbol = "[✗](bold red) ";
        };
        # aws.disabled = true;
        # gcloud.disabled = true;
        # line_break.disabled = true;
        direnv.disabled = false;
        hostname.ssh_only = false;
      };
    };
  };
}
