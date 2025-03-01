{
  pkgs,
  config,
  lib,
  ...
}:

{
  options = {
    feature.apps.waybar = {
      enable = lib.mkEnableOption "Enables waybar";
      systemdTarget = lib.mkOption {
        type = lib.types.str;
        #default = "graphical-session.target";
        default = "river-session.target";
        description = "The systemd target to start waybar";
      };
    };
  };

  config = lib.mkIf config.feature.apps.waybar.enable {
    programs.waybar = {
      enable = true;
      systemd.enable = true;
      #systemd.target = config.feature.apps.waybar.systemdTarget;
      #systemd.target = "river-session.target";
      systemd.target = "graphical-session.target";
      #package = pkgs-unstable.waybar;
      style = builtins.readFile ./waybar/style.css;
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
            #"battery#bat1"
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
            tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
            format = "{:%H:%M 󰥔 }";
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
            format = "BAT0:{capacity}% {icon}";
            format-charging = "BAT0:{capacity}% 󱐋";
            format-plugged = "BAT0:{capacity}% ";
            format-alt = "BAT0:{time} {icon}";
            format-icons = [
              ""
              ""
              ""
              ""
              ""
            ];
          };

          # "battery#bat1" = {
          #   bat = "BAT1";
          #   states = {
          #     warning = 30;
          #     critical = 15;
          #   };
          #   format = "BAT0:{capacity}% {icon}";
          #   format-charging = "BAT0:{capacity}% 󱐋";
          #   format-plugged = "BAT0:{capacity}% ";
          #   format-alt = "BAT0:{time} {icon}";
          #   format-icons = [
          #     ""
          #     ""
          #     ""
          #     ""
          #     ""
          #   ];
          # };

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
            format-bluetooth = "{volume}% {icon} {format_source}";
            format-bluetooth-muted = "󰖁 {icon} {format_source}";
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
  };
}
