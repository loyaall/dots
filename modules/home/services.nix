{
  inputs,
  config,
  pkgs,
  ...
}:

{
  services.udiskie = {
    enable = true;
  };
}
