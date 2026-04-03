{ ... }:
{
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
      border = {
        width = 2;
        radius = 5;
      };
    };
  };
}
