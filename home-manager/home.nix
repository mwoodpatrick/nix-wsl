{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "mwoodpatrick";
  home.homeDirectory = "/home/mwoodpatrick";

  # [Declarative GNOME configuration with NixOS](https://hoverbear.org/blog/declarative-gnome-configuration-in-nixos/)
  dconf.settings = {
        "org/virt-manager/virt-manager/connections" = {
            autoconnect = ["qemu:///system"];
            uris = ["qemu:///system"];
        };
  };

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
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    gh
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    hello
    atool 
    httpie

    # [AsciiDoc](https://asciidoc.org/)
    # Publish presentation-rich content from a concise and comprehensive authoring format.
    asciidoc-full-with-plugins

    # here is some command line tools I use frequently
    # feel free to add your own or remove some of them

    neofetch
    nnn # terminal file manager

    # archives
    zip
    xz
    unzip
    p7zip

    # utils
    ripgrep # recursively searches directories for a regex pattern
    jq # A lightweight and flexible command-line JSON processor
    yq-go # yaml processor https://github.com/mikefarah/yq
    eza # A modern replacement for ‘ls’
    fzf # A command-line fuzzy finder
    feh # [FEH - light-weight, configurable and versatile image viewer](https://feh.finalrewind.org/)
    tmux
    htop
    fortune

    # networking tools
    mtr # A network diagnostic tool
    iperf3
    dnsutils  # `dig` + `nslookup`
    ldns # replacement of `dig`, it provide the command `drill`
    aria2 # A lightweight multi-protocol & multi-source command-line download utility
    socat # replacement of openbsd-netcat
    nmap # A utility for network discovery and security auditing
    ipcalc  # it is a calculator for the IPv4/v6 addresses

    # misc
    cowsay
    lolcat
    file
    which
    tree
    gnused
    gnutar
    gawk
    zstd
    gnupg

    # productivity
    hugo # static site generator
    glow # markdown previewer in terminal

    btop  # replacement of htop/nmon
    iotop # io monitoring
    iftop # network monitoring

    # system call monitoring
    strace # system call monitoring
    ltrace # library call monitoring
    lsof # list open files

    # system tools
    sysstat
    lm_sensors # for `sensors` command
    ethtool
    pciutils # lspci
    usbutils # lsusb
    binutils # strings etc.

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
    libvirt
    virt-viewer

    # kubernetes related
    kubectl
    k3d
    minikube
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
    DIRENV_LOG_FORMAT=""; # disable direnv output
    # TODO: Check if running on WSL does not appear to work (check for some other env var) 
    WSL = if pkgs.hostPlatform.isWindows then "true" else "false";
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
        c  = "clear";
        h  = "history";
        hl = "history|less";
        ht = "history|tail -40";
        he = "home-manager edit";
        hs = "home-manager switch;source ~/.bashrc";
        myps = "ps -w -f -u $USER";
        ne = "nvim $HOME/config/nix/configuration.nix";
        ns = "sudo nixos-rebuild switch --flake $HOME/config/nix#nixos";
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

	# neovim.qt.enable = true;

    # [](https://wiki.nixos.org/wiki/Starship)
    # [starship](https://starship.rs) - an customizable prompt for any shell
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

    # [home-manager/modules/programs/vim.nix](https://github.com/nix-community/home-manager/blob/master/modules/programs/vim.nix)
    vim = {
     enable = true;
     plugins = with pkgs.vimPlugins; [ vim-airline ];
     settings = { ignorecase = true; };
     # See the Vim documentation for detailed descriptions of these
     # [vim documentation](https://www.vim.org/docs.php)
     extraConfig = ''
       set mouse=a
     '';
    };

    # basic configuration of git
    git = {
      enable = true;
      userName = "mwoodpatrick";
      userEmail = "mwoodpatrick@gmail.com";
    };

    # Let Home Manager install and manage itself.
    home-manager.enable = true;
  };
}
