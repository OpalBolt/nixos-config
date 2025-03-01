# This config has been stolen wholesale from: https://github.com/GGORG0/nix-config/blob/master/homeModules/hyprland/rofi.nix i do not have the skill nor time to try to figure out how to both configure nix AND rofi...

{
  inputs,
  pkgs,
  config,
  lib,
  ...
}:

{
  options = {
    feature.apps.rofi.enable = lib.mkEnableOption "Enables rofi";
  };

  config = lib.mkIf config.feature.apps.rofi.enable {
    programs.rofi = {
      enable = true;
      #package = inputs.nixpkgs.rofi-wayland;
      plugins = [
        pkgs.rofi-calc
        pkgs.rofi-power-menu
      ];
      font = "IosevkaTerm Nerd Font Mono 20";

      extraConfig = {
        show-icons = false;
        drun-display-format = "{icon} {name}";
        disable-history = false;
        hide-scrollbar = false;
        sidebar-mode = true;

        run-shell-command = "{terminal} --hold {cmd}";

        display-drun = "   Apps ";
        display-run = "   Run ";
        display-power-menu = "   Power ";

        modi = lib.strings.concatStringsSep "," [
          "run"
          "drun"

          "power-menu:${lib.getExe pkgs.rofi-power-menu}"
        ];
      };
      theme =
        let
          inherit (config.lib.formats.rasi) mkLiteral;
        in
        {
          "*" = {
            bg-col = mkLiteral "#1e1e2e";
            bg-col-light = mkLiteral "#1e1e2e";
            border-col = mkLiteral "#11111b";
            selected-col = mkLiteral "#181825";
            blue = mkLiteral "#89b4fa";
            fg-col = mkLiteral "#cdd6f4";
            fg-col2 = mkLiteral "#f38ba8";
            grey = mkLiteral "#6c7086";

            width = 1200;
          };

          "element-text, element-icon , mode-switcher" = {
            background-color = mkLiteral "inherit";
            text-color = mkLiteral "inherit";
          };

          window = {
            height = mkLiteral "720px";
            border = mkLiteral "3px";
            border-color = mkLiteral "@border-col";
            border-radius = mkLiteral "20px";
            background-color = mkLiteral "@bg-col";
          };

          mainbox = {
            background-color = mkLiteral "@bg-col";
          };

          inputbar = {
            children = [
              (mkLiteral "prompt")
              (mkLiteral "entry")
            ];
            background-color = mkLiteral "@bg-col";
            border-radius = mkLiteral "5px";
            padding = mkLiteral "2px";
          };

          prompt = {
            background-color = mkLiteral "@blue";
            padding = mkLiteral "6px";
            text-color = mkLiteral "@bg-col";
            border-radius = mkLiteral "3px";
            margin = mkLiteral "20px 0px 0px 20px";
          };

          textbox-prompt-colon = {
            expand = false;
            str = ":";
          };

          entry = {
            padding = mkLiteral "6px";
            margin = mkLiteral "20px 0px 0px 10px";
            text-color = mkLiteral "@fg-col";
            background-color = mkLiteral "@bg-col";
          };

          listview = {
            border = mkLiteral "0px 0px 0px";
            padding = mkLiteral "6px 0px 0px";
            margin = mkLiteral "10px 0px 0px 20px";
            columns = 2;
            lines = 5;
            background-color = mkLiteral "@bg-col";
          };

          element = {
            padding = mkLiteral "5px";
            background-color = mkLiteral "@bg-col";
            text-color = mkLiteral "@fg-col";
          };

          element-icon = {
            size = mkLiteral "25px";
          };

          "element selected" = {
            background-color = mkLiteral "@selected-col";
            text-color = mkLiteral "@fg-col2";
          };

          mode-switcher = {
            spacing = 0;
          };

          button = {
            padding = mkLiteral "10px";
            background-color = mkLiteral "@bg-col-light";
            text-color = mkLiteral "@grey";
            vertical-align = mkLiteral "0.5";
            horizontal-align = mkLiteral "0.5";
          };

          "button selected" = {
            background-color = mkLiteral "@bg-col";
            text-color = mkLiteral "@blue";
          };

          message = {
            background-color = mkLiteral "@bg-col-light";
            margin = mkLiteral "2px";
            padding = mkLiteral "2px";
            border-radius = mkLiteral "5px";
          };

          textbox = {
            padding = mkLiteral "6px";
            margin = mkLiteral "20px 0px 0px 20px";
            text-color = mkLiteral "@blue";
            background-color = mkLiteral "@bg-col-light";
          };
        };
    };
  };
}
