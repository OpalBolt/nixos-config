# Config borrowed from: https://codeberg.org/tobiaisu/hyprland-dotfiles/src/commit/1bf5de1c23929da2ad83017be3eface294a246bd/.config/foot/foot.ini

{ lib, config, ... }:
{
  options = {
    feature.apps.fuzzel.enable = lib.mkEnableOption "Enables fuzzel" // {
      default = true;
    };
  };

  config = lib.mkIf config.feature.apps.fuzzel.enable {
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
          #text = "eae5e1ff";
          text = "DCD7BAff";
          match = "7E9CD8FF";
          #selection = "61afefff";
          selection-text = "282c34ff";
          #selection-match = "282c34ff";
          border = "9e948966";
        };

        border = {
          width = 2;
          radius = 5;
        };
      };
    };
  };
}
