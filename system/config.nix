{
  inputs,
  config,
  pkgs,
  ...
}:

{
  imports = [
    inputs.home-manager.nixosModules.default
    inputs.evie-greeter.nixosModules.evie-greeter
    inputs.nix-flatpak.nixosModules.nix-flatpak
    ./drives.nix
    ../modules/system/boot.nix
    ../modules/system/home-manager.nix
    ../modules/system/nvidia.nix
    ../modules/system/networking.nix
    ../modules/system/locale.nix
    ../modules/system/xorg.nix
    ../modules/system/console.nix
    ../modules/system/services.nix
    ../modules/system/pipewire.nix
    ../modules/system/users.nix
    ../modules/system/bluetooth.nix
    ../modules/system/fonts.nix
    ../modules/system/polkit.nix
    ../modules/system/greeter.nix
    ../modules/system/steam.nix
    ../modules/system/fastclicks.nix
    ../modules/system/brightness.nix
    ../modules/system/flatpak.nix
  ];

  # Hostname
  networking.hostName = "NixDesktop";

  # Accounts Service
  services.accounts-daemon.enable = true;

  # Nix Commands
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Support for shared system libraries
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      util-linux
      libatomic_ops
      fontconfig
      freetype
      stdenv.cc.cc
      glib
      nspr
      nss
      dbus
      atk
      at-spi2-atk
      cups
      libX11
      libXcomposite
      libXdamage
      libXext
      libXfixes
      libXrandr
      mesa
      libgbm
      expat
      libxcb
      libxkbcommon
      cairo
      pango
      systemd
      alsa-lib
      at-spi2-core
      vulkan-loader
      vulkan-validation-layers
      nvidia-vaapi-driver
      libGL
      curl
      openssl
      libwebsockets
      cacert
    ];
  };

  # XDG Desktop Portal GTK
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config = {
      hyprland = {
        default = [
          "hyprland"
          "gtk"
        ];
        "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
      };
      common = {
        default = [ "gtk" ];
      };
    };
  };

  # Zsh (configured in ../modules/home/zsh.nix)
  programs.zsh.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # System version
  system.stateVersion = "25.11";
}
