{
  inputs,
  config,
  pkgs,
  ...
}:

{
  # Enable CUPS to print documents
  services.printing.enable = false;

  # Filesystem Driver
  services.devmon.enable = true;
  services.gvfs.enable = true;

  # Editing in gtk
  programs.dconf.enable = true;

  # Battery
  services.upower.enable = true;
}
