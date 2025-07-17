# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, username, ... }:

{
  # === USER ===
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${username} = {
    isNormalUser = true;
    description = "tv";
    extraGroups = [ "networkmanager" "wheel" ];
  };
  security.sudo.wheelNeedsPassword = false;


  # === SYSTEM ===

  # Internationalization
  time.timeZone = "Europe/Paris";
  console.keyMap = "fr";
  i18n.defaultLocale = "fr_FR.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };

  # Enable networking
  networking.networkmanager.enable = true;
 
  # Enable CUPS to print documents.
  services.printing.enable = false;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };

  # Packages
  nixpkgs.config.allowUnfree = true;
  programs.firefox.enable = false;
  environment.systemPackages = with pkgs; [ # List packages installed in system profile.
    vim                                     # To search, run:
    wget                                    # $ nix search wget
    curl
    git    
    uutils-coreutils-noprefix
    fd
    eza
    fd
    zoxide
  ];

  # Configure Git
  programs.git = {
    enable = true;
    config = {
      user.name = "Valdum";
      user.email = "56064897+V4ldum@users.noreply.github.com";
    };
  };


  # === NIXOS ===
  documentation.nixos.enable=false;
  nix.settings.experimental-features = [ "nix-command" "flakes"  ];
  #nix.channel.enable = false;

  #system.autoUpgrade.enable = true;
  #system.autoUpgrade.allowReboot = false;

  # Limit the number of generations to keep
  boot.loader.systemd-boot.configurationLimit = 10;
  # boot.loader.grub.configurationLimit = 10;

  # Perform garbage collection weekly to maintain low disk usage
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 1w";
  };

  # Optimize storage
  # You can also manually optimize the store via:
  #    nix-store --optimise
  # Refer to the following link for more details:
  # https://nixos.org/manual/nix/stable/command-ref/conf-file.html#conf-auto-optimise-store
  nix.settings.auto-optimise-store = true;
}
