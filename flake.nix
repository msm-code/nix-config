{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.11";
    home-manager.url = "github:nix-community/home-manager";
    nur.url = "github:nix-community/NUR";
    secrets.url = "git+ssh://git@github.com/msm-code/nix-secrets";
  };

  outputs = { self, nixpkgs, home-manager, nur, secrets }: {
    nixosConfigurations.transient =
      nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit secrets; };
      modules = [
        ./configuration.nix
        ./borgbackup.nix
        home-manager.nixosModules.home-manager
        {
          nixpkgs.overlays = [
            nur.overlay
            (import ./tor-browser-fixup.nix)
          ];
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.msm = (import ./home.nix) secrets;
        }
      ];
    };
  };
}
