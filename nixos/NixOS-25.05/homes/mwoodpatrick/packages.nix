{ pkgs, ... }:
{
  home.packages = with pkgs; [
    bat
    fzf
    ripgrep
    tree
    jq
    gh
  ];
}
