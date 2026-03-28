{
  inputs,
  config,
  pkgs,
  ...
}:

{
  hardware.i2c.enable = true;
  users.users.heaven.extraGroups = [ "i2c" ];

  environment.systemPackages = [ pkgs.ddcutil-service ];

  systemd.user.services.ddcutil-service = {
    description = "DDCutil D-Bus service";
    after = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    wantedBy = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.ddcutil-service}/bin/ddcutil-service";
      Restart = "on-failure";
    };
  };
}
