{
  inputs,
  config,
  pkgs,
  ...
}:

{
  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "Maple Mono NF CN:size=14";
        pad = "20x20";
      };

      cursor = {
        style = "underline";
        underline-thickness = "2px";
        blink = "yes";
      };

      colors-dark = {
        alpha = "0.8";
        background = "0C0E0F";
      };
    };
  };
}
