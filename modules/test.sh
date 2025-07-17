    # Set the correct permissions
    if [ -d "/etc/nixos/modules/cosmic/config" ] && [ $(stat -c %U "/etc/nixos/modules/cosmic/config") != "tv" ]; then
      echo "perms"
      #chown -R ${username}:${username} "${cosmicSrc}"
    fi

    # Symlink the folder
    if [ ! -L "/home/tv/.config/cosmic_test" ]; then
      echo "link"
      #ln -sf "${cosmicSrc}" "${cosmicDst}“
    fi
