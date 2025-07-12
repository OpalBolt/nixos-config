{
  lib,
  ...
}:

{
  programs.kitty = {
    enable = true;
    themeFile = "kanagawa";
    font = {
      name = "Iosevka NFM:style=Regular";
      size = 12;
    };
    keybindings = {
      "alt+shift++" = "send_key alt+?";
    };
    #shellIntegration = {
    #  enableZshIntegration = true;
    #  enableFishIntegration = true;
    #  enableBashIntegration = true;
    #  #mode = "enabled";
    #};
    settings = {
      background_opacity = 0.85;
      cursor_trail = 0;
      hide_window_decorations = true;
      window_border_width = 0;
      draw_minimal_borders = true;
      shell_integration = false;
      wheel_scroll_multiplier = 5.0;
      input_delay = 3;
      allow_remote_control = true;
      listen_on = "unix:@mykitty";
    };
  };
}
