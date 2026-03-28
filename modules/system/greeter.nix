{
  inputs,
  config,
  pkgs,
  ...
}:
{
  programs.evie-greeter = {
    enable = true;
    primaryMonitor = "DP-3";
  };

  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${config.programs.evie-greeter.package}/bin/evie-greeter-session";
      user = "greeter";
    };
  };
}
