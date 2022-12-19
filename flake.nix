{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";
    nixpkgs-latest.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-22.05";
    nur.url = "github:nix-community/NUR";
    secrets.url = "git+ssh://git@github.com/msm-code/nix-secrets";
    # p4net.url = "github:Patient-Engineering/p4net-nix";
    p4net.url = "git+file:///home/msm/Projects/p4net-nix";
  };

  outputs = { self, nixpkgs, home-manager, nur, secrets, p4net, nixpkgs-latest }: {
    nixosConfigurations.transient = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit secrets; inherit nixpkgs-latest; };
      modules = [
        # system configs
        ./modules/hardware-configuration.nix
        ./modules/configuration.nix
        # random features
        ./modules/p4net.nix
        #./modules/yubikey.nix
        ./modules/borgbackup.nix
        ./modules/iphone.nix
        ./modules/spotify.nix
        ./modules/sound.nix
        p4net.nixosModule
        home-manager.nixosModules.home-manager
        {
          nixpkgs.overlays = [
            nur.overlay
          ];

          # Doubly extra special args, just for home-manager
          home-manager.extraSpecialArgs = { inherit secrets; inherit nixpkgs-latest; };
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.msm = (import ./home-manager/home.nix);
        }
      ];
    };
  };
}
