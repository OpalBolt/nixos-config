{ ... }:
{
  den.aspects.river-wm = {
    nixos = { pkgs, ... }: {
      services.displayManager.ly.enable = true;
      xdg.portal = {
        enable = true;
        xdgOpenUsePortal = true;
        extraPortals = [ pkgs.xdg-desktop-portal-wlr ];
        wlr.enable = true;
        config.common.default = [ "wlr" ];
      };
      environment.sessionVariables = {
        XDG_CURRENT_DESKTOP = "river";
        XDG_SESSION_DESKTOP = "river";
        XDG_SESSION_TYPE = "wayland";
        NIXOS_OZONE_WL = "1";
      };
      programs = {
        river-classic.enable = true;
        waybar.enable = true;
      };
      security.pam.services.swaylock = { };
      environment.systemPackages = with pkgs; [
        slurp
        grim
        swappy
        mako
        libnotify
        wideriver
        swayidle
        swaylock
        pavucontrol
        pamixer
        playerctl
        polkit_gnome
        brightnessctl
        wl-clipboard
        swaybg
        wlr-randr
        networkmanagerapplet
        fuzzel
      ];
    };

    homeManager = { lib, pkgs, config, ... }: {
      # River window manager
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

      # Waybar status bar
      programs.waybar = {
        enable = true;
        systemd.enable = true;
        systemd.target = "river-session.target";
        style = builtins.readFile ../../dotfiles/waybar/style.css;
        settings.mainBar = {
          layer = "top";
          position = "top";
          height = 0;
          spacing = 4;
          modules-left = [ "river/tags" "river/layout" ];
          modules-center = [ "clock" ];
          modules-right = [
            "pulseaudio" "network" "backlight"
            "battery#bat0" "battery#bat1"
            "idle_inhibitor" "custom/kernel" "tray"
          ];
          "custom/kernel".exec = "echo \"󱄅 $(uname -r)\"";
          idle_inhibitor = {
            format = "{icon}";
            format-icons = { activated = "󰅶"; deactivated = "󰛊"; };
          };
          tray.spacing = 10;
          clock = {
            tooltip-format = "<tt><small>{calendar}</small></tt>";
            format = "{:%H:%M 󰥔  %d/%m }";
          };
          backlight = {
            format = "{percent}% {icon}";
            format-icons = [ "" "" "" "" "" "" "" "" "" ];
          };
          "battery#bat0" = {
            bat = "BAT0";
            states = { warning = 30; critical = 15; };
            format = "󰄌 :{capacity}% {icon}";
            format-charging = "󰄌 :{capacity}% 󱐋";
            format-plugged = "󰄌 :{capacity}% ";
            format-alt = "󰄌 :{time} {icon}";
            format-icons = [ "" "" "" "" "" ];
          };
          "battery#bat1" = {
            bat = "BAT1";
            states = { warning = 30; critical = 15; };
            format = " :{capacity}% {icon}";
            format-charging = " :{capacity}% 󱐋";
            format-plugged = " :{capacity}% ";
            format-alt = " :{time} {icon}";
            format-icons = [ "" "" "" "" "" ];
          };
          network = {
            format-wifi = "{essid} ({signalStrength}%) ";
            format-ethernet = "{ipaddr}/{cidr} 󰈁";
            tooltip-format = "{gwaddr} via {ifname} 󰈀 ";
            format-linked = "{ifname} (No IP) 󰈂";
            format-disconnected = "Disconnected ⚠";
            format-alt = "{ifname}: {ipaddr}/{cidr}";
          };
          pulseaudio = {
            format = "{volume}% {icon} {format_source}";
            format-bluetooth = "{volume}% {icon}  {format_source}";
            format-bluetooth-muted = "󰖁 {icon}  {format_source}";
            format-muted = "󰖁 {format_source}";
            format-source = " {volume}% ";
            format-source-muted = "";
            format-icons = {
              headphone = "";
              hands-free = "hands-free";
              headset = "headset";
              phone = "";
              portable = "";
              car = "";
              default = [ " " " " " " ];
            };
            on-click = "pavucontrol";
          };
        };
      };

      # Lock screen
      programs.swaylock = {
        enable = true;
        settings = {
          show-failed-attempts = true;
          ignore-empty-password = true;
          font-size = 14;
          disable-caps-lock-text = true;
          indicator-caps-lock = true;
          indicator-radius = 50;
          indicator-thickness = 10;
          image = toString ../../dotfiles/bg.png;
          scaling = "fill";
        };
      };

      # Idle daemon
      services.swayidle = {
        enable = true;
        extraArgs = [ "-w" ];
        events = [
          { event = "lock"; command = "${pkgs.swaylock}/bin/swaylock -f"; }
          { event = "before-sleep"; command = "${pkgs.swaylock}/bin/swaylock -f"; }
        ];
        timeouts = [
          { timeout = 600; command = "loginctl lock-session"; }
        ];
      };

      # App launcher
      programs.fuzzel = {
        enable = true;
        settings = {
          main = {
            font = "IosevkaTerm Nerd Font Mono:size=12";
            icons-enabled = false;
            icon-theme = "tela-circle-icon-theme";
            terminal = "kitty";
            width = 50;
            horizontal-pad = 48;
            vertical-pad = 28;
            line-height = 15;
          };
          colors = {
            background = "0c0c0980";
            input = "DCD7BAff";
            text = "DCD7BAff";
            match = "7E9CD8FF";
            selection-text = "282c34ff";
            border = "9e948966";
          };
          border = { width = 2; radius = 5; };
        };
      };

      # Notifications
      services.mako = {
        enable = true;
        settings.default-timeout = 5000;
      };

      # GTK theme
      gtk = {
        enable = true;
        gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
        gtk4.extraConfig.gtk-application-prefer-dark-theme = true;
        iconTheme = {
          name = "tela-circle-icon-theme";
          package = pkgs.tela-circle-icon-theme;
        };
        theme = {
          name = "Arc-Dark";
          package = pkgs.arc-theme;
        };
      };
      dconf = {
        enable = true;
        settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
      };
      home.pointerCursor = {
        gtk.enable = true;
        x11.enable = true;
        name = "Bibata-Modern-Classic";
        package = pkgs.bibata-cursors;
        size = 16;
      };
      qt = {
        enable = true;
        platformTheme.name = "gtk";
      };
    };
  };
}
