{
  description = "Nixos Config Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    evie.url = "path:/home/heaven/Evie";

    evie-greeter.url = "github:loyaall/evie-greeter";

    eviefetch.url = "github:loyaall/eviefetch";

    zen-browser.url = "github:loyaall/zen-browser-nixos-flake";

    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";

    nvf.url = "github:notashelf/nvf";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      evie,
      evie-greeter,
      eviefetch,
      zen-browser,
      nix-flatpak,
      nvf,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations = {
        NixDesktop = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            ./system/config.nix
          ];
        };
      };
    };
}
