{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";
    nixpkgs-latest.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-22.05";
    nur.url = "github:nix-community/NUR";
    secrets.url = "git+ssh://git@github.com/msm-code/nix-secrets";
    p4net.url = "github:Patient-Engineering/p4net-nix";
  };

  outputs = { self, nixpkgs, home-manager, nur, secrets, p4net, nixpkgs-latest }: {
    nixosConfigurations.transient = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit secrets; inherit nixpkgs-latest; };
      modules = [
        ./configuration.nix
        #./yubikey.nix
        ./borgbackup.nix
        ./iphone.nix
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
          home-manager.users.msm = (import ./home.nix);
        }
      ];
    };
  };
}
