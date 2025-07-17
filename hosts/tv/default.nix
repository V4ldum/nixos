# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

# TODO dégager pkgs après avoir vérifier les systemd.services
{ config, pkgs, zen-browser, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix

      # Default NixOS config
      ../../modules/system.nix

      # Cosmic Desktop Environment
      ../../modules/cosmic
      # Fish shell
      ../../modules/fish.nix
      # Zen Browser config for the host's user
      ../../modules/zen # This is not that clean but I don't know how to do it otherwise

      # Enable SSH
      ../../modules/ssh.nix
      # Enable RustDesk
      #../../modules/rust-desk.nix
    ];

  # Bootloader.
  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
  };

  networking.hostName = "tv"; # Define your hostname.
  hardware.bluetooth.enable = false;

  # Disable wifi
  networking.wireless.enable = false;
  systemd.services.disable-wifi = {
    description = "Disable Wi-Fi at boot";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" "NetworkManager.service" ];
    serviceConfig = {
      ExecStart = "${pkgs.networkmanager}/bin/nmcli radio wifi off";
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };

  # Enable firewall
  networking.firewall.enable = true;

  # Power Settings
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;

  # This service will set performance mode after power-profiles-daemon starts
  systemd.services.set-power-profile = {
    description = "Set performance power profile";
    after = ["power-profiles-daemon.service"];
    wants = ["power-profiles-daemon.service"];
    wantedBy = ["multi-user.target"];
    
    serviceConfig = {
      ExecStart = "${pkgs.power-profiles-daemon}/bin/powerprofilesctl set performance";
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };

  # Enable automatic login for the user.
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "tv";


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
