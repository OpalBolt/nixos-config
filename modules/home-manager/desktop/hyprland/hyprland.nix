{ config, lib, pkgs, ... }:
{
  # options = {                                                                                                                    
  #   hm.desktop.hyprland.enable = lib.mkEnableOption "Enables the hyprland window manager";
  # };

  config = lib.mkIf config.hm.desktop.hyprland.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true; # This enables X11 application to run in a small X11 enviroment
      systemd.enable = true; # Enables some envorment variables to be imported to systemd before the system is started
      settings = let
        mod = "SUPER";
      in {
        input = {
          kb_layout = "dk";
          follow_mouse = 1;
        };
        general = {
          gaps_in = 2;
          gaps_out = 2;
          border_size = 2;
          "col.active_border" = "rgb(E6C384)";
          "col.inactive_border" = "rgba(54546D)";
          layout = "master";
        };
        decoration = {
          rounding = 10;
          blur = {
            enabled = true;
            size = 3;
            passes = 1;
          };
        };
        animations = {
          enabled = false;
        };
        misc = {
          disable_hyprland_logo = true; # hyprpaper covers it

          # just in case hypridle breaks... or something
          mouse_move_enables_dpms = true;
          key_press_enables_dpms = true;
        };
        bind =
        [
          # Power/logout
          "${mod}, O, exec, ${lib.getExe' pkgs.systemd "loginctl"} lock-session"
          
          # app shortcut"
          "${mod}, return, exec, ${lib.getExe pkgs.kitty} --single-instance"
          "${mod}, B, exec, ${lib.getExe pkgs.firefox}"

          # Rofi
          "${mod}, R, exec, ${lib.getExe config.programs.rofi.finalPackage} -show drun"
          "${mod}, escape, exec, ${lib.getExe config.programs.rofi.finalPackage} -show power-menu"

          # Screenshots
          ", Print, exec, ${lib.getExe pkgs.grimblast} --notify --freeze copysave area"
          "CTRL, Print, exec, ${lib.getExe pkgs.grimblast} --notify copysave screen"
          "SHIFT, Print, exec, ${lib.getExe pkgs.grimblast} --notify copysave output"
          "ALT, Print, exec, ${lib.getExe pkgs.grimblast} --notify copysave active"

          # Window actions (Dispatcher)
          "${mod}, Q, killactive,"
          "${mod}, F, togglefloating,"
          "${mod}, T, togglesplit," # toggle split direction
          "${mod}, M, fullscreen, 1" # maximize but keep panel and gaps
          "${mod} SHIFT, M, fullscreen, 0" # fullscreen (no panel or gaps)

          # Move focus with mod + vim keys
          "${mod}, H, movefocus, l"
          "${mod}, J, movefocus, d"
          "${mod}, K, movefocus, u"
          "${mod}, L, movefocus, r"

          # Move windows with mod + SHIFT + vim keys
          "${mod} SHIFT, H, movewindow, l"
          "${mod} SHIFT, J, movewindow, d"
          "${mod} SHIFT, K, movewindow, u"
          "${mod} SHIFT, L, movewindow, r"

          # Scroll through workspaces with mod + scroll
          "${mod}, mouse_down, workspace, +1"
          "${mod}, mouse_up, workspace, -1"

          # Scroll through workspaces with mod + ALT + h/l
          "${mod} ALT, L, workspace, +1"
          "${mod} ALT, H, workspace, -1"

          # The special workspace (overlay/scratchpad)
          "${mod}, grave, togglespecialworkspace,"
          "${mod} SHIFT, grave, movetoworkspace, special"
          
        ];
        # Move/resize windows with mod + LMB/RMB and dragging
        bindm = [
          "${mod}, mouse:272, movewindow"
          "${mod}, mouse:273, resizewindow"
        ];
        # Brightness and volume keys
        bindel = [
          # (e) Repeat when held down, (l) works on the lockscreen
          ", XF86MonBrightnessDown, exec, ${lib.getExe pkgs.brightnessctl} set 5%-"
          ", XF86MonBrightnessUp, exec, ${lib.getExe pkgs.brightnessctl} set 5%+"

          ", XF86AudioLowerVolume, exec, ${lib.getExe' pkgs.wireplumber "wpctl"} set-volume -l 0 @DEFAULT_AUDIO_SINK@ 5%-"
          ", XF86AudioRaiseVolume, exec, ${lib.getExe' pkgs.wireplumber "wpctl"} set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ];
        bindl = [
          ", XF86AudioMute, exec, ${lib.getExe' pkgs.wireplumber "wpctl"} set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ", XF86AudioMicMute, exec, ${lib.getExe' pkgs.wireplumber "wpctl"} set-mute @DEFAULT_AUDIO_SOURCE@ toggle"

          ", XF86AudioPlay, exec, ${lib.getExe pkgs.playerctl} play-pause"
          ", XF86AudioPause, exec, ${lib.getExe pkgs.playerctl} play-pause"
          ", XF86AudioNext, exec, ${lib.getExe pkgs.playerctl} next"
          ", XF86AudioPrev, exec, ${lib.getExe pkgs.playerctl} previous"

          "${mod} CTRL, escape, exec, ${lib.getExe' pkgs.systemd "systemctl"} suspend"
        ];
      };
    };
  # Fix for Electron apps
  home.sessionVariables."NIXOS_OZONE_WL" = "1";

  # Fix for Qt5 apps on wayland
  home.packages = [pkgs.qt5.qtwayland];
  };
}
