{ lib, pkgs, ... }:
{
  imports = [
    ./waybar.nix
    ./fuzzel.nix
    ./mako.nix
    ./swaylock.nix
    ./swayidle.nix
  ];

  wayland.windowManager.river = {
    enable = true;
    systemd.enable = true;
    settings = {
      default-layout = "wideriver";
      default-attach-mode = "top";
      focus-follows-cursor = "normal";
      set-cursor-warp = "on-focus-change";
      hide-cursor = "when-typing disabled";
      set-repeat = "25 600";
      background-color = "0x1F1F28";
      border-color-focused = "0x98BB6C";
      border-color-unfocused = "0x54546D";
      border-color-urgent = "0xFF5D62";
      rule-add = "ssd";

      # Keyboard layout (rosi uses dk)
      keyboard-layout = "dk";

      map = {
        normal = {
          Super = {
            Return = "spawn ${lib.getExe pkgs.kitty}";
            B = "spawn ${lib.getExe pkgs.firefox}";
            V = "spawn \"rofi-rbw --no-folder\"";
            D = "spawn fuzzel";
            J = "focus-view next";
            K = "focus-view previous";
            Period = "focus-output next";
            Comma = "focus-output previous";
            F = "toggle-fullscreen";
            up = "send-layout-cmd wideriver \"--layout monocle\"";
            down = "send-layout-cmd wideriver \"--layout wide --stack diminish --count 1 --ratio 0.4\"";
            left = "send-layout-cmd wideriver \"--layout left\"";
            right = "send-layout-cmd wideriver \"--layout right\"";
            Space = "send-layout-cmd wideriver \"--layout-toggle\"";
            plus = "send-layout-cmd wideriver \"--ratio +0.025\"";
            equal = "send-layout-cmd wideriver \"--ratio 0.35\"";
            minus = "send-layout-cmd wideriver \"--ratio -0.025\"";
          };
          "Super+Shift" = {
            X = "close";
            A = "close";
            J = "swap next";
            K = "swap previous";
            S = "toggle-float";
            Period = "send-to-output -current-tags next";
            Comma = "send-to-output -current-tags previous";
            F = "spawn \"bemoji -t\"";
            L = "spawn \"loginctl lock-session\"";
            B = "spawn ${lib.getExe pkgs.firefox}";
          };
          "Super+Shift+Control+Alt" = {
            Q = "exit";
          };
          None = {
            XF86AudioRaiseVolume = "spawn 'pamixer -i 5'";
            XF86AudioLowerVolume = "spawn 'pamixer -d 5'";
            XF86AudioMute = "spawn 'pamixer --toggle-mute'";
            XF86AudioMicMute = "spawn 'pamixer --default-source --toggle-mute'";
            XF86AudioMedia = "spawn 'playerctl play-pause'";
            XF86AudioPlay = "spawn 'playerctl play-pause'";
            XF86AudioPrev = "spawn 'playerctl previous'";
            XF86AudioNext = "spawn 'playerctl next'";
            XF86MonBrightnessUp = "spawn 'brightnessctl set +5%'";
            XF86MonBrightnessDown = "spawn 'brightnessctl set 5%-'";
          };
        };
      };

      map-pointer = {
        normal = {
          Super = {
            BTN_LEFT = "move-view";
            BTN_RIGHT = "resize-view";
            BTN_MIDDLE = "toggle-float";
          };
        };
      };

      spawn = [
        "\"${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1\""
        "\"dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=river\""
        "\"${pkgs.gnome-keyring}/bin/gnome-keyring-daemon --start --components=secrets\""
        "nm-applet"
        "mako"
        "\"swaybg -i ${../../dotfiles/bg.png} -m fill\""
      ];
    };

    extraConfig = ''
      riverctl map normal Super+Shift M spawn "riverctl keyboard-layout -variant altgr-intl -rules evdev -model evdev us"
      riverctl map normal Super+Shift N spawn "riverctl keyboard-layout dk"

      riverctl map normal Super+Shift D spawn "grim -g \"$(slurp)\" - | swappy -f -"

      all_tags=$(((1 << 32) - 1))
      riverctl map normal Super 0 set-focused-tags $all_tags
      riverctl map normal Super+Shift 0 set-view-tags $all_tags

      keys_alpha="qwertyuio"
      keys_num="123456789"

      for i in $(seq 1 9); do
          idx=$((i-1))
          tag=$((1 << idx))
          ka=''${keys_alpha:idx:1}
          kn=''${keys_num:idx:1}

          for key in "$ka" "$kn"; do
              riverctl map normal Super "$key" set-focused-tags $tag
              riverctl map normal Super+Shift "$key" set-view-tags $tag
              riverctl map normal Super+Control "$key" toggle-focused-tags $tag
              riverctl map normal Super+Shift+Control "$key" toggle-view-tags $tag
          done
      done

      wideriver \
          --layout left \
          --layout-alt monocle \
          --stack even \
          --count 1 \
          --ratio 0.5 \
          --no-smart-gaps \
          --inner-gaps 4 \
          --outer-gaps 4 &
    '';
  };
}
