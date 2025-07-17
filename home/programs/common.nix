{ pkgs, zen-browser, ... }:

{
  # Packages commonly used accross different hosts
  home.packages = with pkgs; [
    bitwarden-desktop 
    zen-browser.packages."${system}".default # TODO remove when available baseline in NixOS
  ];
}
