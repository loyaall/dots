{
  inputs,
  config,
  pkgs,
  ...
}:

{
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {

      monitorv2 = [
        {
          output = "DP-1";
          mode = "1920x1080@200";
          position = "0x0";
          scale = 1;
          transform = 0;
        }
        {
          output = "HDMI-A-1";
          mode = "1920x1080@144";
          position = "1920x-80";
          scale = 1;
          transform = 0;
        }
      ];

      workspace = [
        "1, monitor:DP-1, default:true"
        "2, monitor:HDMI-A-1, default:true"
      ];

      "$mod" = "SUPER";
      "$terminal" = "ghostty";
      "$fileManager" = "nautilus --new-window";
      "$menu" = "evie search";
      "$menuAlt" = "wofi --show drun";
      "$browser" = "zen";

      env = [
        "LIBVA_DRIVER_NAME,nvidia"
        "XDG_SESSION_TYPE,wayland"
        "GBM_BACKEND,nvidia-drm"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
        "XCURSOR_SIZE,16"
        "HYPRCURSOR_SIZE,16"
      ];

      cursor = {
        no_hardware_cursors = true;
      };

      exec-once = [
        "evie start &"
        "xdg-user-dirs-update &"
      ];

      general = {
        border_size = 0;
        gaps_in = 5;
        gaps_out = 10;
        allow_tearing = true;
        resize_on_border = true;
        "col.active_border" = "rgba(799fe0ff)";
        "col.inactive_border" = "rgba(595959aa)";
        layout = "dwindle";
      };

      decoration = {
        rounding = 10;
        active_opacity = 1.0;
        inactive_opacity = 1.0;
        blur = {
          enabled = true;
          size = 12;
          passes = 4;
          noise = 0.02;
          contrast = 0.9;
          brightness = 0.85;
          vibrancy = 0.25;
          vibrancy_darkness = 0.5;
          new_optimizations = true;
          xray = false;
          popups = true;
          popups_ignorealpha = 0.2;
        };
      };

      animations = {
        enabled = true;

        bezier = [
          "expo,   0.16, 1.0, 0.3, 1.0"
          "out,    0.0,  0.0, 0.2, 1.0"
          "in,     0.4,  0.0, 1.0, 1.0"
          "linear, 0.0,  0.0, 1.0, 1.0"
        ];

        animation = [
          "windowsIn,   1, 5, expo, slide"
          "windowsOut,  1, 4, in,   slide"
          "windowsMove, 1, 5, expo"

          "fade,    1, 5, out"
          "fadeIn,  1, 4, out"
          "fadeOut, 1, 3, in"
          "fadeDim, 1, 5, out"

          "border,      1, 5, out"
          "borderangle, 1, 180, linear, loop"

          "workspaces,       1, 6, expo, slide"
          "specialWorkspace, 1, 5, expo, slidevert"
        ];
      };

      input = {
        kb_layout = "it";
        follow_mouse = 1;
        sensitivity = 0;

        touchpad = {
          natural_scroll = false;
        };
      };

      device = {
        name = "epic-mouse-v1";
        sensitivity = -0.5;
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      master = {
        new_status = "master";
      };

      misc = {
        force_default_wallpaper = 1;
        disable_hyprland_logo = true;
      };

      bind = [
        "$mod, T, exec, $terminal"
        "$mod, Q, killactive,"
        "$mod SHIFT, Q, exec, command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch exit"
        "$mod, E, exec, $fileManager"
        "$mod, B, exec, $browser"
        "$mod, F, fullscreen,"
        "$mod, S, togglefloating,"
        "$mod, Space, exec, $menu"
        "$mod, O, exec, $menuAlt"
        "$mod, J, layoutmsg, togglesplit"
        "$mod SHIFT, S, exec, FILE=\"$HOME/Pictures/Screenshots/Screenshot took $(date '+%Y-%m-%d %H-%M-%S').png\" && hyprshot -m region --freeze -o \"$HOME/Pictures/Screenshots\" -f \"$(basename \"$FILE\")\" && gradia \"$FILE\""
        ", PRINT, exec, FILE=\"$HOME/Pictures/Screenshots/Screenshot took $(date '+%Y-%m-%d %H-%M-%S').png\" && hyprshot -m output --freeze -o \"$HOME/Pictures/Screenshots\" -f \"$(basename \"$FILE\")\" && gradia \"$FILE\""

        "$mod, P, exec, evie power"
        "$mod, D, exec, evie settings"

        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"

        "$mod SHIFT, left, movewindow, l"
        "$mod SHIFT, right, movewindow, r"
        "$mod SHIFT, up, movewindow, u"
        "$mod SHIFT, down, movewindow, d"

        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"

        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 10"

        "$mod, mouse_down, workspace, +1"
        "$mod, mouse_up, workspace, -1"
      ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      bindel = [
        ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ", XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+"
        ", XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-"
      ];

      bindl = [
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
      ];

      windowrule = [
        {
          name = "suppress-maximize-events";
          "match:class" = ".*";
          suppress_event = "maximize";
        }
        {
          name = "fix-xwayland-drags";
          "match:class" = "^$";
          "match:title" = "^$";
          "match:xwayland" = true;
          "match:float" = true;
          "match:fullscreen" = false;
          "match:pin" = false;

          no_focus = true;
        }
        {
          name = "feishin-trasparency";
          "match:class" = "feishin";
          opacity = 0.9;
        }
        {
          name = "floating-picker";
          "match:class" = "xdg-desktop-portal-gtk";
          float = true;
        }
        {
          name = "evie-settings-float";
          "match:class" = "org.evie_desktop.heaven";
          "match:title" = "Settings";
          float = true;
          size = "1000 700";
        }
      ];
    };
  };

  xdg = {
    portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };
    configFile."xdg-desktop-portal/hyprland-portals.conf".text = ''
      [preferred]
      default = hyprland;gtk
      org.freedesktop.impl.portal.FileChooser = gtk
    '';
  };
}
