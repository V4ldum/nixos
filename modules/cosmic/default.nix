{ pkgs, username, ... }:

let
  cosmicSrc = "/etc/nixos/modules/cosmic/config";
  cosmicDst = "/home/${username}/.config/cosmic";
in {

  # Enable the COSMIC Desktop Environment.
  services.desktopManager.cosmic.enable = true;
  services.displayManager.cosmic-greeter.enable = true;
  services.desktopManager.cosmic.xwayland.enable = true;

  # TODO needs 25.11
  #environment.cosmic.excludePackages = with pkgs; [
  #  cosmic-edit
  #  cosmic-files
  #  cosmic-screenshot
  #  cosmic-player
  #];

  # Creates a bi-directionnal symlink between the config folders in /etc/nixos and /home
  systemd.services.cosmic-settings = {
    description = "Link Cosmic settings";
    after = ["multi-user.target"];
    wantedBy = ["multi-user.target"];
    
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };

    script = ''
      # Delete the folder if it's not a symlink (means it's the default one)
      if [ -e "${cosmicDst}" ] && [ ! -L "${cosmicDst}" ]; then
        rm -rf "${cosmicDst}" || rm -rf "${cosmicDst}" # Idk why only once doesn't work
      fi

      # Set the correct permissions
      if [ -e "${cosmicSrc}" ] && [ $(stat -c %U "${cosmicSrc}") != "${username}" ]; then
        chown -R ${username} "${cosmicSrc}"
      fi
  
      # Symlink the folder
      if [ ! -e "${cosmicDst}" ]; then
        ln -sf "${cosmicSrc}" "${cosmicDst}"
      fi
    '';
  };
}
