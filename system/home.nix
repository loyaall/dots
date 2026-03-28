{
  inputs,
  config,
  pkgs,
  ...
}:

{

  imports = [
    inputs.zen-browser.homeManagerModules.default
    inputs.evie.homeManagerModules.evie
    inputs.eviefetch.homeManagerModules.eviefetch
    inputs.nvf.homeManagerModules.default
    ../modules/home/hyprland.nix
    ../modules/home/packages.nix
    ../modules/home/zsh.nix
    ../modules/home/env.nix
    ../modules/home/services.nix
    ../modules/home/foot.nix
    ../modules/home/gtk.nix
    ../modules/home/neovim.nix
  ];

  # Home Heaven
  home.username = "heaven";
  home.homeDirectory = "/home/heaven";
  home.stateVersion = "26.05";

  # Reload system units
  systemd.user.startServices = "sd-switch";

  # Let home manager install and manage itself
  programs.home-manager.enable = true;
}
