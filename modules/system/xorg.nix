{
  inputs,
  config,
  pkgs,
  ...
}:

{
  # Enable the X11 windowing system
  services.xserver.enable = false;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "it";
    variant = "intl";
  };

  # Enable touchpad support
  # services.xserver.libinput.enable = true;
}
