{
  pkgs,
  config,
  lib,
  ...
}:

{
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    systemd.target = "river-session.target";
    style = (builtins.readFile (lib.custom.relativeToRoot "dotfiles/waybar/style.css"));
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 0; # set to zero for auto height
        spacing = 4;

        modules-left = [
          "river/tags"
          "river/layout"
        ];

        modules-center = [ "clock" ];

        modules-right = [
          "pulseaudio"
          "network"
          "backlight"
          "battery#bat0"
          "battery#bat1"
          "idle_inhibitor"
          "custom/kernel"
          "tray"
        ];

        "custom/hello-from-waybar" = {
          format = "hello {}";
          max-length = 40;
          interval = "once";
          exec = pkgs.writeShellScript "hello-from-waybar" ''
            echo "from within waybar"
          '';
        };

        "custom/kernel" = {
          exec = "echo \"󱄅 \$(uname -r)\"";
        };

        "idle_inhibitor" = {
          format = "{icon}";
          format-icons = {
            activated = "󰅶";
            deactivated = "󰛊";
          };
        };

        tray = {
          spacing = 10;
        };

        clock = {
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          format = "{:%H:%M 󰥔  %d/%m }";
        };

        backlight = {
          format = "{percent}% {icon}";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            ""
          ];
        };

        "battery#bat0" = {
          bat = "BAT0";
          states = {
            warning = 30;
            critical = 15;
          };
          format = "󰄌 :{capacity}% {icon}";
          format-charging = "󰄌 :{capacity}% 󱐋";
          format-plugged = "󰄌 :{capacity}% ";
          format-alt = "󰄌 :{time} {icon}";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
        };

        "battery#bat1" = {
          bat = "BAT1";
          states = {
            warning = 30;
            critical = 15;
          };
          format = " :{capacity}% {icon}";
          format-charging = " :{capacity}% 󱐋";
          format-plugged = " :{capacity}% ";
          format-alt = " :{time} {icon}";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
        };

        network = {
          format-wifi = "{essid} ({signalStrength}%) ";
          format-ethernet = "{ipaddr}/{cidr} 󰈁";
          tooltip-format = "{gwaddr} via {ifname} 󰈀 ";
          format-linked = "{ifname} (No IP) 󰈂";
          format-disconnected = "Disconnected ⚠";
          format-alt = "{ifname}: {ipaddr}/{cidr}";
        };

        pulseaudio = {
          format = "{volume}% {icon} {format_source}";
          format-bluetooth = "{volume}% {icon}  {format_source}";
          format-bluetooth-muted = "󰖁 {icon}  {format_source}";
          format-muted = "󰖁 {format_source}";
          format-source = " {volume}% ";
          format-source-muted = "";
          format-icons = {
            headphone = "";
            hands-free = "hands-free";
            headset = "headset";
            phone = "";
            portable = "";
            car = "";
            default = [
              " "
              " "
              " "
            ];
          };
          on-click = "pavucontrol";
        };
      };
    };
  };
}
