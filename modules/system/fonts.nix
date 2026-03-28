{
  inputs,
  config,
  pkgs,
  ...
}:

{
  fonts.packages = with pkgs; [
    maple-mono.NF-CN
    material-symbols
    nunito
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    freetype
  ];
}
