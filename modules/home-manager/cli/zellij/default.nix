{config, lib, vars, ... }:

{
  options = {
    zellij.enable =
      lib.mkEnableOption "Enables Zellij";
  };

  config = lib.mkIf config.zellijj.enable {
    programs.zellij = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        pane_frames = false;
        tab_bar = false;
        default_layout = "compact";
        theme = "rose-pine";
        keybinds = {
          unbind = [
            "Ctrl p"
            "Ctrl n"
          ];
        };
        themes = {
          "rose-pine" = {
            bg = "#403d52";
            fg = "#e0def4";
            red = "#eb6f92";
            green = "#31748f";
            blue = "#9ccfd8";
            yellow = "#f6c177";
            magenta = "#c4a7e7";
            orange = "#fe640b";
            cyan = "#ebbcba";
            black = "#000000";
            white = "#e0def4";
          };
        };
      };
    };
  };
}
