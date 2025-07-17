{ pkgs, ... }:

{
  # Install RustDesk
  environment.systemPackages = with pkgs; [
    rustdesk-flutter
  ];

  # Open the port
  networking.firewall.allowedTCPPorts = [ 21118 ];
}
