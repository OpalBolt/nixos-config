{config, lib, vars, ... }:

{
  options = {
    kitty.enable =
      lib.mkEnableOption "Enables Gnome desktop enviroment";
  };

  config = lib.mkIf config.kitty.enable {
    enable = true;
    theme = "kanagawa";
    font = {
      name = "IosevkaTerm Nerd Font Mono";
      size = 15;
    };
    shellIntegration.enableZshIntegration = true;
    settings = {
      background_opacity = 0.9;
      cursor_trail = 1;
      hide_window_decorations = true;
      window_border_width = 0;
      draw_minimal_borders = true;
    };
  };
}
