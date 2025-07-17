{ pkgs, ... }:

{
  # Enable SSH
  services.openssh.enable = true;

  # Open the port
  networking.firewall.allowedTCPPorts = [ 22 ];
}
