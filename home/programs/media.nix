{ pkgs, ... }:

{
  # Packages used to play media (movies, music...)
  home.packages = with pkgs; [
    stremio 
    jellyfin-media-player 
  ];
}
