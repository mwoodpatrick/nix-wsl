# By default home manager module gets these input attributes:
# 
# config	The result of the entire configuration evaluation up to this point. 
# You usually refer to config attributes (like config.programs.git.enable) to set options 
# in one place and reuse them elsewhere.
# options	A reference to all possible Home Manager configuration options that can be set. This is used when defining new options (less common in home.nix).	Defines new configuration options.
# 
# pkgs: The complete set of Nix packages available to Home Manager. 
# This is the package set you passed in using inherit pkgs;.
#
# lib	The Nixpkgs library (pkgs.lib), which contains essential helper functions like mkIf, mkDefault, map, filter, and many others.	Access utility functions.
# pkgs	The complete set of Nix packages available to Home Manager. This is the package set you passed in using inherit pkgs;.	Install packages (e.g., pkgs.neovim).
#
# options: A reference to all possible Home Manager configuration options that can be set. 
# This is used when defining new options (less common in home.nix).
#
# lib: The Nixpkgs library (pkgs.lib), which contains essential helper functions like 
# mkIf, mkDefault, map, filter, and many others.
#
# Additional attributes specified in nextraSpecialArgs 


{ config, pkgs, inputs, ... }:
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "mwoodpatrick";
  home.homeDirectory = "/home/mwoodpatrick";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # IMPORTANT: Pin to when you started using HM
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  home.file.".config/luarocks/config.lua".text = ''
              rocks_trees = {
                { name = "user", root = home .. "/.luarocks" },
              }

              lua_interpreter = "lua5.1"
              variables = {
                LUA_DIR = "/nix/store",
              }
            '';

  # fonts.packages = with pkgs; [
  #   nerd-fonts.fira-code
  #   nerd-fonts.jetbrains-mono
  #   nerd-fonts.hack
  # ];

  # Packages that should be installed to the user profile.
  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    yaml-language-server
    typescript-language-server
    texlab # language server for LaTeX
    helm-ls
    shellcheck
    bash-language-server
    shfmt
    shellcheck
    gnumake # needed for make

    # 2. Install the Lua package manager itself.
    # We use lua5_1.luarocks for the Lua 5.1 version.
    # determine correct version for nvin
    # :lua = _VERSION
    # Include LuaJIT interpreter (commonly used)
    # luajit
    # lua
    # lua51Packages.luarocks
    # lua5_1
    (lua5_1.withPackages (ps: with ps; [
      luarocks
      luafilesystem
    ]))

    uv
    python313
    python313Packages.python-lsp-server
    python313Packages.pylsp-mypy
    python313Packages.python-lsp-ruff
    python313Packages.ruff
    python313Packages.black

    # Nix Language Server Nix formatting
    # neovide
    kitty
    ghostty
    xorg.xclock
    xorg.xcalc
    vim-full
    nil
    alejandra
    clang-tools
    lua-language-server
    tree # Command to produce a depth indented directory listing
    fd
    wget
    gcc_debug
    git-lfs
    libgcc
    unzip
    nodejs_24
    ripgrep # recursively searches directories for a regex pattern
    ripgrep-all
    tree-sitter

    # missing formatters

    go # includes gofmt
    gotools # includes goimports
    gopls
    rustup
    # rust-analyzer # includes rustfmt
    black
    isort
    prettier
    prettierd
    stylua
    nixfmt-rfc-style # https://github.com/NixOS/nixfmt

    # end of extra formatters

    # Adds the 'hello' command to your environment. It prints a friendly
    # "Hello, world!" when run.
    hello
    htop
    fortune
    gh
    git

    # TODO: compare nixpkgs-fmt
    nixpkgs-fmt

    # Nix Diagnostics
    statix
    deadnix

    # Nix docs + manpages
    nix-doc

    # Nerd Fonts (pick one or more)
    # (nerdfonts.override { fonts = [ "FiraCode" "Hack" "JetBrainsMono" ]; })

    # It is sometimes useful to fine-tune packages, for example, by applying
    # overrides. You can do that directly here, just don't forget the
    # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # fonts?
    # Nerd Fonts (pick one or more)
    # (nerdfonts.override { fonts = [ "FiraCode" "Hack" "JetBrainsMono" "FantasqueSansMono" ]; })
    # fonts.packages = [
    #    nerd-fonts._0xproto
    #    nerd-fonts.droid-sans-mono
    #  ]

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    (pkgs.writeShellScriptBin "my-hello" ''
      echo "Hello, ${config.home.username}!"
    '')


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
    just # Modern build system supports variables, conditionals, and shell settings

    jq # A lightweight and flexible command-line JSON processor
    yq-go # yaml processor https://github.com/mikefarah/yq
    fzf # A command-line fuzzy finder
    feh # [FEH - light-weight, configurable and versatile image viewer](https://feh.finalrewind.org/)
    git-lfs
    tmux
    fortune

    # archives
    zip
    xz
    unzip
    p7zip
  ];

  # Set Nerd Font as default terminal font if supported
  fonts.fontconfig.enable = true;

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
  home.file.".config/nvim".source = ./nvim;

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
  home.sessionVariables = {
    EDITOR = "nvim";
    GIT_ROOT = "/mnt/wsl/projects/git";
    LIBGL_ALWAYS_SOFTWARE = 1; # Need for Flutter since hardware render does not work on my laptops!
    NIX_CFG_DIR = "$GIT_ROOT/nix-wsl";
    PATH = "$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin";
    DIRENV_LOG_FORMAT = ""; # disable direnv output
    # TODO: Check if running on WSL does not appear to work (check for some other env var)
    WSL = if pkgs.hostPlatform.isWindows then "true" else "false";
    KIND_EXPERIMENTAL_PROVIDER = "podman";
    UV_PYTHON_DOWNLOADS = "never"; # Normal python does not work in NixOS
    LUAROCKS_CONFIG = "$HOME/.config/luarocks/config.lua";
    # PS1=''\u@\h:\w\ myenv$ ''; # Currently trying out starship
  };

  # Let Home Manager install and manage itself.
  # Ensure manpages work inside WSL2
  programs = {
    man.enable = true;

    home-manager.enable = true;

    bash = {
      enable = true;
      enableCompletion = true;
      # Add your custom bashrc here
      bashrcExtra = ''
        # added from home.nix
        source ~/.nix-profile/etc/profile.d/hm-session-vars.sh
        #end, added from home.nix

        # Bash function 'n' to launch the Windows Neovide executable 
        # with the --wsl flag and pass all arguments ($@).

        n() {
          # IMPORTANT: Verify this path is correct for your Windows installation!
          neovide.exe --wsl "$@" &
        }
      '';

      # set some aliases, feel free to add more or remove some
      shellAliases = {
        c  = "clear";
        h  = "history";
        hl = "history|less";
        ht = "history|tail -40";
        he = "n $GIT_ROOT/nix-wsl/home-manager3/home.nix";
				hs = "home-manager switch -v --flake $GIT_ROOT/nix-wsl/home-manager3;source ~/.bashrc";
        myps = "ps -w -f -u $USER";
        ncd = "cd $NIXOS_CONFIG_ROOT";
        ne = "n $NIXOS_CONFIG_ROOT/flake.nix";
        ns = "sudo nixos-rebuild switch --flake $NIXOS_CONFIG_ROOT#nixos";
        ngc = "nix-collect-garbage -d";
				nvd = "neovide.exe --wsl";
        j = "jobs";
        k = "kubectl";
        urldecode = "python3 -c 'import sys, urllib.parse as ul; print(ul.unquote_plus(sys.stdin.read()))'";
        urlencode = "python3 -c 'import sys, urllib.parse as ul; print(ul.quote_plus(sys.stdin.read()))'";
        vv = "NVIM_APPNAME=nvim-test nvim";
        wsl = "wsl.exe";
        wterm = "/mnt/c/Program\\ Files/WezTerm/wezterm.exe &";
      };
    };

    # [](https://wiki.nixos.org/wiki/Starship)
    # [starship](https://starship.rs) - an cust
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

    #  [nix-direnv](https://github.com/nix-community/nix-direnv)
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

    # For a more extensive setup, it's often better to manage your Neovim
    # configuration as a separate directory and have Home Manager symlink it into your home folder.
    # This allows you to use a separate file for your configuration and keep it organized.
    # Symlink your local nvim folder to the correct location
    # home.file.".config/nvim".source = ./nvim;

    neovim = {
      enable = true;
      # package = pkgs.neovim-nightly;  # latest master build
      package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;

      # Vimscript configuration:
      #     extraConfig = ''
      #        set number relativenumber
      #        set tabstop=2
      #        set shiftwidth=2
      #        set expandtab
      #      '';

      # Lua configuration
      # extraConfigLua = ''
      #    vim.o.number = true
      #    vim.cmd('syntax on')
      #    '';

      # We'll use lazy.nvim for plugin management
      plugins = with pkgs.vimPlugins; [
        lazy-nvim
        rocks-nvim
        nvim-web-devicons
        lualine-nvim
      ];
    };
  };
}
