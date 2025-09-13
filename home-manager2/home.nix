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
  # IMPORTANT: Pin to when you started using HM
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # fonts.packages = with pkgs; [
  #   nerd-fonts.fira-code
  #   nerd-fonts.jetbrains-mono
  #   nerd-fonts.hack
  # ];

  # Packages that should be installed to the user profile.
  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
        # Adds the 'hello' command to your environment. It prints a friendly
        # "Hello, world!" when run.
        hello
        htop
        fortune
        git
        # neovim
        python3

      # Nix formatting
      nil
      alejandra
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
    NIX_CFG_DIR="$GIT_ROOT/nix-wsl";
    PATH = "$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin";
    # PS1=''\u@\h:\w\ myenv$ ''; # Currently trying out starship
    DIRENV_LOG_FORMAT=""; # disable direnv output
    # TODO: Check if running on WSL does not appear to work (check for some other env var)
    WSL = if pkgs.hostPlatform.isWindows then "true" else "false";
  };

      # For a more extensive setup, it's often better to manage your Neovim 
      # configuration as a separate directory and have Home Manager symlink it into your home folder. 
      # This allows you to use a separate file for your configuration and keep it organized.
      # Symlink your local nvim folder to the correct location
      home.file.".config/nvim".source = ./nvim;

  # Let Home Manager install and manage itself.
  # Ensure manpages work inside WSL2
  programs = {
      man.enable = true;

      home-manager.enable = true;

    neovim = {
        enable = true;
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
                  nvim-web-devicons
                  lualine-nvim
            ];
        };
  };
}
