{
  inputs,
  config,
  pkgs,
  ...
}:

{
  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "heaven" = import ../../system/home.nix;
    };
  };
}
