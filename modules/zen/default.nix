{ username, ... }:

let
  zenSrc = "/etc/nixos/modules/zen/config";
  zenDst = "/home/${username}/.zen";
in {
  # Creates a bi-directionnal symlink between the config folders in /etc/nixos and /home
  systemd.services.zen-settings = {
    description = "Link Zen settings";
    after = ["multi-user.target"];
    wantedBy = ["multi-user.target"];
    
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };

    script = ''
      # Delete the folder if it's not a symlink (means it's the default one)
      if [ -e "${zenDst}" ] && [ ! -L "${zenDst}" ]; then
        rm -rf "${zenDst}" || rm -rf "${zenDst}" # Idk why only once doesn't work
      fi

      # Set the correct permissions
      if [ -e "${zenSrc}" ] && [ $(stat -c %U "${zenSrc}") != "${username}" ]; then
        chown -R ${username} "${zenSrc}"
      fi
  
      # Symlink the folder
      if [ ! -e "${zenDst}" ]; then
        ln -sf "${zenSrc}" "${zenDst}"
      fi
    '';
  };
}
