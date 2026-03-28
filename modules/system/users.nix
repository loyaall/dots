{
  inputs,
  config,
  pkgs,
  ...
}:

{
  users.users.heaven = {
    isNormalUser = true;
    description = "Heaven";
    shell = pkgs.zsh;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };
}
