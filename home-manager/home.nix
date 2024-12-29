# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
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
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  # Set your username
  home = {
    username = "mwoodpatrick";
    homeDirectory = "/home/mwoodpatrick";
  };

  # Add stuff for your user as you see fit:

  # [Declarative GNOME configuration with NixOS](https://hoverbear.org/blog/declarative-gnome-configuration-in-nixos/)
  # dconf.settings = {
  #   "org/virt-manager/virt-manager/connections" = {
  #     autoconnect = ["qemu:///system"];
  #     uris = ["qemu:///system"];
  #   };
  # };

  # link the configuration file in current directory to the specified location in home directory
  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  # link all files in `./scripts` to `~/.config/i3/scripts`
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;   # link recursively
  #   executable = true;  # make all files executable
  # };

  # encode the file content in nix configuration file directly
  # home.file.".xxx".text = ''
  #     xxx
  # '';

  # set cursor size and dpi for 4k monitor
  xresources.properties = {
    "Xcursor.size" = 16;
    "Xft.dpi" = 172;
  };

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.11";

  # The home.packages option allows you to install Nix packages into your
  # environment.
  # [Search packages](https://search.nixos.org/packages?channel=unstable)
  home.packages = with pkgs; [
    # neovim # Vim text editor fork focused on extensibility and agility
    neovim-qt # Neovim client library and GUI, in Qt5
    neovim-gtk # Gtk ui for neovim
    # [Obsidian for Vim users](https://tomdeneire.medium.com/obsidian-for-vim-users-5979d571f71e)
    obsidian # Powerful knowledge base that works on top of a local folder of plain text Markdown files
    gh # GitHub CLI tool
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    hello # Program that produces a familiar, friendly greeting
    atool # Archive command line helper
    httpie # Command line HTTP client whose goal is to make CLI human-friendly

    # [AsciiDoc](https://asciidoc.org/)
    # Publish presentation-rich content from a concise and comprehensive authoring format.
    asciidoc-full-with-plugins

    # here is some command line tools I use frequently
    # feel free to add your own or remove some of them

    neofetch # Fast, highly customizable system info script
    nnn # terminal file manager, Small ncurses-based file browser forked from noice

    # archives
    zip # Compressor/archiver for creating and modifying zipfiles
    unzip # Extraction utility for archives compressed in .zip format
    xz # General-purpose data compression software, successor of LZMA
    p7zip # New p7zip fork with additional codecs and improvements (forked from https://sourceforge.net/projects/p7zip/)

    # utils
    ripgrep # recursively searches directories for a regex pattern
    jq # A lightweight and flexible command-line JSON processor
    yq-go # yaml processor https://github.com/mikefarah/yq
    eza # A modern replacement for ΓÇÿlsΓÇÖ
    fzf # A command-line fuzzy finder
    feh # [FEH - light-weight, configurable and versatile image viewer](https://feh.finalrewind.org/)
    tmux # Terminal multiplexer
    htop # Interactive process viewer
    fortune # Program that displays a pseudorandom message from a database of quotations

    # networking tools
    mtr # A network diagnostic tool
    iperf3 # Tool to measure IP bandwidth using UDP or TCP
    dnsutils # `dig` + `nslookup`
    ldns # replacement of `dig`, it provide the command `drill`
    aria2 # A lightweight multi-protocol & multi-source command-line download utility
    socat # replacement of openbsd-netcat
    nmap # A utility for network discovery and security auditing
    ipcalc # it is a calculator for the IPv4/v6 addresses

    # misc
    cowsay # Program which generates ASCII pictures of a cow with a message
    ponysay # Cowsay reimplemention for ponies
    lolcat # Rainbow version of cat
    file # Program that shows the type of files
    which # Shows the full path of (shell) commands
    tree # Command to produce a depth indented directory listing
    gnused # GNU sed, a batch stream editor
    gnutar # GNU implementation of the `tar' archiver
    gawk # GNU implementation of the Awk programming language
    zstd # Zstandard real-time compression algorithm
    gnupg # Modern release of the GNU Privacy Guard, a GPL OpenPGP implementation

    # productivity
    hugo # static site generator
    glow # markdown previewer in terminal

    btop # replacement of htop/nmon
    iotop # io monitoring
    iftop # network monitoring

    # system call monitoring
    strace # system call monitoring
    ltrace # library call monitoring
    lsof # list open files

    # system tools
    sysstat # Collection of performance monitoring tools for Linux (such as sar, iostat and pidstat)
    lm_sensors # for `sensors` command
    ethtool # Utility for controlling network drivers and hardware
    pciutils # Collection of programs for inspecting and manipulating configuration of PCI devices including lspci
    usbutils # Tools for working with USB devices, such as lsusb
    binutils # Tools for manipulating binaries (linker, assembler, etc.) (wrapper script) including strings

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

    # VM related
    libvirt # Toolkit to interact with the virtualization capabilities of recent versions of Linux and other OSes
    virt-viewer # Viewer for remote virtual machines

    # kubernetes related
    kubectl # Kubernetes CLI
    k3d # Helper to run k3s (Lightweight Kubernetes. 5 less than k8s) in a docker container
    minikube # Tool that makes it easy to run Kubernetes locally
  ];

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
    LIBGL_ALWAYS_SOFTWARE = 1; # Need for Flutter since hardware render does not work on my laptops!
    PATH = "$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin";
    # PS1=''\u@\h:\w\ myenv$ ''; # Currently trying out starship
    DIRENV_LOG_FORMAT = ""; # disable direnv output
    # TODO: Check if running on WSL does not appear to work (check for some other env var)
    WSL =
      if pkgs.hostPlatform.isWindows
      then "true"
      else "false";
  };

  programs = {
    # [nix-direnv](https://github.com/nix-community/nix-direnv)
    # [direnv](https://direnv.net/)
    # [Effortless dev environments with Nix and direnv](https://determinate.systems/posts/nix-direnv/)
    # [github:direnv](https://github.com/direnv/direnv)
    direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };

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
        c = "clear";
        h = "history";
        hl = "history|less";
        ht = "history|tail -40";
        he = "home-manager -f $NIX_CFG_DIR/home-manager/home.nix edit";
        hs = "home-manager --flake ${NIX_CFG_DIR}${HM_CFG} switch;source ~/.bashrc";
        myps = "ps -w -f -u $USER";
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

    # [Firefox](https://nixos.wiki/wiki/Firefox)
    firefox.enable = true;

    neovim = {
      enable = true;

      # automatically add vi and vim aliases
      viAlias = true;
      vimAlias = true;

      # Define your Neovim plugins (optional)
      # [flake-awesome-neovim-plugins](https://github.com/m15a/flake-awesome-neovim-plugins)
      # [Awesome Neovim](https://github.com/rockerBOO/awesome-neovim)
      # [NixNeovimPlugins](https://github.com/NixNeovim/NixNeovimPlugins)

      # plugins = {
      # lualine.enable = true;
      # telescope.enable = true;
      # harpoon.enable = true;
      # pkgs.vimPlugins.nvim-tree-lua
      # {
      # plugin = pkgs.vimPlugins.vim-startify;
      # config = "let g:startify_change_to_vcs_root = 0";
      # }
      # };

      # The Home Manager module does not expose many configuration options.
      # Therefore, the easiest way to get started is to use the extraConfig option.
      # You can copy your old config or directly load your default Neovim config via:

      # extraConfig = ''
      #   lib.fileContents ./init.vim;
      #   augroup NixFiles
      #     autocmd!
      #     autocmd FileType nix setlocal tabstop=2 shiftwidth=2 expandtab
      #   augroup END
      # '';
    };

    # TODO: Fix presets
    # [](https://wiki.nixos.org/wiki/Starship)
    # [starship](https://starship.rs) - an customizable prompt for any shell
    # [Nix Starship options](https://search.nixos.org/options?channel=unstable&show=programs.starship.settings&from=0&size=50&sort=relevance&type=packages&query=starship)
    # [github:startship](https://github.com/spaceship-prompt/spaceship-prompt)
    starship = {
      enable = true;

      # custom settings

      settings = {
        add_newline = true;
        command_timeout = 1300;
        scan_timeout = 50;
        format = "$all$nix_shell$nodejs$lua$golang$rust$php$git_branch$git_commit$git_state$git_status\n$username$hostname$directory";
        character = {
          success_symbol = "[∩âÜ](bold green) ";
          error_symbol = "[Γ£ù](bold red) ";
        };
        # aws.disabled = true;
        # gcloud.disabled = true;
        # line_break.disabled = true;
        direnv.disabled = false;
        hostname.ssh_only = false;
      };

      # custom presets
      # error: The option `programs.starship.presets' does not exist
      # presets = [
      #   "nerd-font-symbols"
      # ];
    };

    # [home-manager/modules/programs/vim.nix](https://github.com/nix-community/home-manager/blob/master/modules/programs/vim.nix)
    vim = {
      enable = true;
      plugins = with pkgs.vimPlugins; [vim-airline];
      settings = {ignorecase = true;};
      # See the Vim documentation for detailed descriptions of these
      # [vim documentation](https://www.vim.org/docs.php)
      extraConfig = ''
        set mouse=a
      '';
    };

    # basic configuration of git
    # git = {
    #   enable = true;
    #   userName = "mwoodpatrick";
    #   userEmail = "mwoodpatrick@gmail.com";
    # };
  }; # programs

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
