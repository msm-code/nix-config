{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.11";
    home-manager.url = "github:nix-community/home-manager";
    nur.url = "github:nix-community/NUR";
    secrets.url = "git+ssh://git@github.com/msm-code/nix-secrets";
    p4net.url = "github:Patient-Engineering/p4net-nix";
  };

  outputs = { self, nixpkgs, home-manager, nur, secrets, p4net }: {
    nixosConfigurations.transient =
      nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit secrets; };
      modules = [
        ./configuration.nix
        ./yubikey.nix
        ./borgbackup.nix
        ./iphone.nix
        p4net.nixosModule
        home-manager.nixosModules.home-manager
        {
          nixpkgs.overlays = [
            nur.overlay
          ];

          # Doubly extra special args, just for home-manager
          home-manager.extraSpecialArgs = { inherit secrets; };
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.msm = (import ./home.nix);
        }
      ];
    };
  };
}
