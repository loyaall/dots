{
  inputs,
  config,
  pkgs,
  ...
}:

{
  services.blueman.enable = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        # Show battery percentage
        Experimental = true;
        # Device connect faster. More power usage
        FastConnectable = true;
      };
      Policy = {
        # Enable all controllers when they are found
        AutoEnable = true;
      };
    };
  };
}
