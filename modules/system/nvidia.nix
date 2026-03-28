{
  inputs,
  config,
  pkgs,
  ...
}:

{
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;
  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    open = true;
    modesetting.enable = true;
    nvidiaSettings = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
  };
}
