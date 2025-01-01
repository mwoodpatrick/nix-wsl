# autocommands (autocmd) allow you to execute commands automatically based on events, 
# such as opening a file of a specific type
#
# [autoCmd](https://nix-community.github.io/nixvim/NeovimOptions/autoCmd/index.html)
# [autocommands.nix](https://github.com/bkp5190/Home-Manager-Configs/blob/main/autocommands.nix)
{
  programs.nixvim.autoCmd = [
    # Vertically center document when entering insert mode
    {
      event = "InsertEnter";
      command = "norm zz";
    }

    # Open help in a vertical split
    {
      event = "FileType";
      pattern = "help";
      command = "wincmd L";
    }

    # Enable spellcheck for some filetypes
    {
      event = "FileType";
      pattern = [
        "markdown"
      ];
      command = "setlocal spell spelllang=en";
    }
  ];
}
