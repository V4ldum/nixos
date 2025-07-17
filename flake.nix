{
  description = "A simple NixOS flake";

  inputs = {
    # NixOS 
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      # IMPORTANT: we're using "libgbm" and is only available in unstable so ensure
      # to have it up-to-date or simply don't specify the nixpkgs input
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Home Manager
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ { 
    nixpkgs, 
    nixpkgs-unstable, 
    home-manager, 
    zen-browser,
    ... 
  }: {
    nixosConfigurations = {
      tv = let
        username = "tv";
        specialArgs = { inherit username; inherit zen-browser;  };
      in
        nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          system = "x86_64-linux";
  
          modules = [
            ./hosts/tv
         
            # Home Manager settings
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.extraSpecialArgs = inputs // specialArgs;
              home-manager.users.${username} = import ./users/${username}.nix;
            }
          ];
        };
    };
  };
}
