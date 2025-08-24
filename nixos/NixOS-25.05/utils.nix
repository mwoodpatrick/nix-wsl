{ lib }:
let
  # Generic function: load all .nix files in a directory except excluded ones
  importAll = dir: exclude:
    let
      files = builtins.attrNames (builtins.readDir dir);
      nixFiles = builtins.filter (f: lib.hasSuffix ".nix" f && !(builtins.elem f exclude)) files;
    in
      map (f: dir + "/${f}") nixFiles;
in
{
  inherit importAll;
}
