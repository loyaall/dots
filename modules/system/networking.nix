{
  inputs,
  config,
  pkgs,
  ...
}:

{
  networking = {
    networkmanager.enable = true;
    networkmanager.dns = "systemd-resolved";
  };

  services.resolved = {
    enable = true;
    settings.Resolve = {
      DNS = [ "192.168.1.100" ];
      FallbackDNS = [ "1.1.1.1" ];
      DNSSEC = false;
    };
  };
}
