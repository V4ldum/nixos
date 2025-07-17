{ pkgs, zen-browser, system, ... }:

{
  imports = [
    ../home/core.nix

    # Programs
    ../home/programs/common.nix
    ../home/programs/media.nix
  ];
}
