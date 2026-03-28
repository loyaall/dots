{
  inputs,
  config,
  pkgs,
  ...
}:

{
  services.flatpak = {
    enable = true;
    packages = [ "org.vinegarhq.Sober" ];
    overrides = {
      "org.vinegarhq.Sober" = {
        Context = {
          devices = [ "input" ];
          filesystems = [
            "xdg-run/app/com.discordapp.Discord:create"
            "xdg-run/discord-ipc-0"
          ];
        };
      };
    };
  };
}
