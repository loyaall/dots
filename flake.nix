{
  description = "Nixos Config Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    evie.url = "path:/home/heaven/Evie/Evie";

    evie-greeter.url = "github:EvieOrg/EvieGreeter";

    eviefetch.url = "github:EvieOrg/EvieFetch";

    zen-browser.url = "github:loyaall/zen-browser-nixos-flake";

    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    {
      nixosConfigurations = {
        NixDesktop = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            { nixpkgs.hostPlatform = "x86_64-linux"; }
            ./system/config.nix
          ];
        };
      };
    };
}
