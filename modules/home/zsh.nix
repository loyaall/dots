{
  inputs,
  config,
  pkgs,
  ...
}:

{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = false;

      format = "$os$directory$character";

      os = {
        disabled = false;
        symbols.NixOS = "  ";
        style = "bold #ff00ff";
      };

      directory = {
        style = "bold #ff66ff";
        format = "[$path]($style) ";
        truncation_length = 3;
      };

      character = {
        success_symbol = "[](bold #ff99ff) ";
        error_symbol = "[](bold red) ";
      };
    };
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    initContent = ''
      # Commit Alias
      function NixCommit() {
        cd ~/dots
        git add .
        git commit -m "$1"
      }

      function precmd() {
        echo -ne '\e[4 q'
      }

      echo -ne '\e[4 q'

      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
      zstyle ':completion:*' menu select

      export XDG_DATA_DIRS="${"\${XDG_DATA_DIRS:+$XDG_DATA_DIRS:}"}/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share"
    '';

    shellAliases = {
      Rebuild = "sudo nixos-rebuild switch --flake ~/dots#NixDesktop";
      Config = "nvim ~/dots/system/config.nix";
      Home = "nvim ~/dots/system/home.nix";
      Packages = "nvim ~/dots/modules/home/packages.nix";
      Flake = "nvim ~/dots/flake.nix";
      Update = "cd ~/dots && sudo nix flake update && sudo nixos-rebuild switch --flake ~/dots#NixDesktop";
      Clean = "sudo nix-collect-garbage -d";
      NixPush = "cd ~/dots && git push -u origin main";
      ls = "lsd";
    };
  };
}
