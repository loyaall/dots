{
  inputs,
  config,
  pkgs,
  ...
}:

{
  home.sessionVariables = {
    EDITOR = "nvim";
    BROWSER = "zen";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };
}
