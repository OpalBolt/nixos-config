{
  lib,
  hostSpec,
  pkgs,
  ...
}:

{
  imports = [
    ./waybar.nix
    ./fuzzel.nix
    ./mako.nix
    ./swaylock.nix
  ];

  wayland.windowManager.river = {
    enable = true;
    systemd.enable = true;
    settings = {
      # Nix creates the configuration file based on the content of the these settings
      # This is then symlinked to the user's home directory from the nix store.
      # This means that the settings are converted into riverctl commands from these dict items.

      # Example: foo = "bar"; becomes riverctl config foo bar;
      # Example2: foo = {
      #             bar = "baz";
      #             qux = "quux";
      #           };
      # becomes:
      # riverctl foo bar baz
      # riverctl foo qux quux

      # The settings are documented
      # river(1) riverctl(1) rivertile(1)

      ###############
      #   Actions   #
      ###############

      # Sets the default layout, the default is rivertile, but others can be added.
      # See a non exaustive list of layouts here: [link](https://codeberg.org/river/wiki/src/branch/master/pages/Community-Layouts.md)
      # Other layout engiens needs to be installed as a nix package.
      # See ./../../../nixos/desktop/river.nix
      default-layout = "wideriver";

      ######################
      #   Configurations   #
      ######################

      # Defines where new windows are placed. - top|bottom|above|below|after <N>
      # NOTE: Note that the deprecated attach-mode command is aliased to default-attach-mode for backwards compatibility.
      default-attach-mode = "top";

      # Defines how focus of mouse is handled. - disabled|normal|always
      focus-follows-cursor = "normal";

      # Defines how warp mode of the cursor is handled. - disabled|on-output-change|on-focus-change
      # Example could be that when focus is changed to a different window the cursor will be warped to the center of the window.
      set-cursor-warp = "on-focus-change";

      # Hides the cursor when typing. - when-typing enabled|disabled
      hide-cursor = "when-typing disabled";

      # Sets how fast keyboard repeats keystrokes in ms. - rate delay
      # Default is 25 600
      set-repeat = "25 600";

      # Sets colors for background and border
      background-color = "0x1F1F28";
      border-color-focused = "0x98BB6C";
      border-color-unfocused = "0x54546D";
      border-color-urgent = "0xFF5D62";

      ###########
      #  Rules  #
      ###########

      rule-add = "ssd";

      ##########################
      #  Input configurations  #
      ##########################

      keyboard-layout = hostSpec.kbdLayout;

      ##############
      #  Mappings  #
      ##############

      map = {
        normal = {
          Super = {
            # Spawn Terminal
            Return = "spawn ${lib.getExe pkgs.kitty}";
            print = "notify-send \"test\"";

            # Spawn Browser
            # B = "spawn \"qbpm choose --menu \'fuzzel --dmenu\'\"";
            B = "spawn ${lib.getExe pkgs.firefox}";
            V = "spawn \"rofi-rbw --no-folder\"";

            # Spawn app launcher
            #D = "spawn ${lib.getExe config.programs.rofi.finalPackage} -show drun";
            #D = "spawn rofi -show drun";
            D = "spawn fuzzel";

            # Super+J and Super+K to focus the next/previous view in the layout stack
            J = "focus-view next";
            K = "focus-view previous";

            # Super+Period and Super+Comma to focus the next/previous output
            # output == monitor
            Period = "focus-output next";
            Comma = "focus-output previous";

            # Super+F to toggle fullscreen
            F = "toggle-fullscreen";

            # wideriver
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
            # Close focused window
            X = "close";
            A = "close";

            # Move window up and down
            J = "swap next";
            K = "swap previous";

            # Toggle Floating
            S = "toggle-float";

            # Send the focused window to the different output
            Period = "send-to-output -current-tags next";
            Comma = "send-to-output -current-tags previous";

            F = "spawn \"bemoji -t\"";

            L = "spawn \"swaylock -F -e -i /home/mads/nix-dots/dotfiles/bg.png -l -s fill\"";

            B = "spawn ${lib.getExe pkgs.firefox}";

          };

          # Super+Shift+E to exit river
          "Super+Shift+Control+Alt" = {
            Q = "exit";
          };

          None = {
            # Control pulse audio volume with pamixer (https://github.com/cdemoulins/pamixer)
            XF86AudioRaiseVolume = "spawn 'pamixer -i 5'";
            XF86AudioLowerVolume = "spawn 'pamixer -d 5'";
            XF86AudioMute = "spawn 'pamixer --toggle-mute'";
            XF86AudioMicMute = "spawn 'pamixer --default-source --toggle-mute'";

            # Control MPRIS aware media players with playerctl (https://github.com/altdesktop/playerctl)
            XF86AudioMedia = "spawn 'playerctl play-pause'";
            XF86AudioPlay = "spawn 'playerctl play-pause'";
            XF86AudioPrev = "spawn 'playerctl previous'";
            XF86AudioNext = "spawn 'playerctl next'";

            # Control screen backlight brightness with light (https://github.com/haikarainen/light)
            XF86MonBrightnessUp = "spawn 'brightnessctl set +5%'";
            XF86MonBrightnessDown = "spawn 'brightnessctl set 5%-'";
          };
        };
      };

      # mouse bindings
      map-pointer = {
        normal = {
          Super = {
            # Super + Left Mouse Button to move views
            BTN_LEFT = "move-view";

            # Super + Right Mouse Button to resize views
            BTN_RIGHT = "resize-view";

            # Super + Middle Mouse Button to toggle float
            BTN_MIDDLE = "toggle-float";
          };
        };
      };

      spawn = [
        "\"dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=river\""
        "\"swayidle -w timeout 600 'swaylock' before-sleep 'swaylock'\"" # lock screen
        "nm-applet"
        "mako"
        #"waybar"
        #"systemctl --user restart waybar.service"
        #"nextcloud"
        "\"swaybg -i /home/mads/nix-dots/dotfiles/bg.png -m fill\""
      ];
    };

    extraConfig = ''
      # ===== keymaps =====
      #
      # switch keyboard layouts
      #riverctl map normal Super+Shift M spawn "riverctl keyboard-layout -options \"compose:lwin-altgr\" us"
      riverctl map normal Super+Shift M spawn "riverctl keyboard-layout -variant altgr-intl -rules evdev -model evdev us"
      #riverctl map normal Super+Shift M spawn "riverctl keyboard-layout us"
      riverctl map normal Super+Shift N spawn "riverctl keyboard-layout dk"


      riverctl map normal Super+Shift D spawn "grim -g \"\$(slurp)\" - | swappy -f -"

      # Super+0 to focus all tags
      # Super+Shift+0 to tag focused view with all tags
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

      # ===== start rivertile =====

      # start wideriver
      wideriver \
          --layout left \
          --layout-alt monocle \
          --stack even \
          --count-master 1 \
          --ratio-master 0.50 \
          --count-wide-left 0 \
          --ratio-wide 0.35 \
          --smart-gaps \
          --inner-gaps 5 \
          --outer-gaps 5 \
          --border-width 1 \
          --border-width-monocle 0 \
          --border-width-smart-gaps 0 \
          --border-color-focused "0x61afef" \
          --border-color-focused-monocle "0x5c6370" \
          --border-color-unfocused "0x5c6370" \
          --log-threshold info \
          >"/tmp/wideriver.log" 2>&1 &
    '';
  };
}
