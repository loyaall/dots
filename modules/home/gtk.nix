{
  inputs,
  config,
  pkgs,
  ...
}:

{
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 16;
  };
  gtk = {
    enable = true;
    iconTheme = {
      package = pkgs.tela-circle-icon-theme;
      name = "Tela-circle-dark";
    };
  };
}
