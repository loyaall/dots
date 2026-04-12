{
  inputs,
  config,
  pkgs,
  ...
}:

{
  programs.ghostty = {
    enable = true;
    settings = {
      font-family = "Maple Mono NF CN";
      font-size = 14;
      window-padding-x = 20;
      window-padding-y = 20;

      cursor-style = "underline";
      cursor-style-blink = true;

      background-opacity = 0.8;
      background = "0C0E0F";
    };
  };
}
