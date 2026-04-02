{
  inputs,
  config,
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [

    # Audio
    feishin
    pavucontrol

    # System
    gh
    pix
    swappy
    git
    lsd
    tldr
    xdg-utils
    btop
    wofi
    nautilus
    gnome-disk-utility
    keepassxc
    heroic

    # Social
    vesktop

    # Gaming
    lunar-client
    vulkan-tools

    # Coding
    antigravity
    kiro

    # Themes
    adw-gtk3

    # Filesystems
    gvfs
    udisks2
    udiskie
    udevil
    usbutils
    mtpfs
    libmtp
    fuse3
    ntfs3g
    exfatprogs
    dosfstools

    # Screenshot
    hyprshot

  ];

  # Every Evie
  programs.evie.enable = true;
  programs.eviefetch.enable = true;

  # Browser
  programs.zen-browser.enable = true;

  nixpkgs.config.allowUnfree = true;
}
