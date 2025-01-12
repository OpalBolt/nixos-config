{ lib, config, ... }:

{
  imports = [
    ./../../apps/rofi.nix
    ./../../apps/dunst.nix
    ./../../apps/waybar.nix
  ];

  options = {
    feature.desktop.river.enable = lib.mkEnableOption "Enable river and all required apps";
  };

  config = lib.mkIf config.feature.desktop.river.enable {
    feature.apps.rofi.enable = true;
    feature.apps.dunst.enable = true;
    feature.apps.waybar.enable = true;
    feature.apps.waybar.systemdTarget = "river-session.target";

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
        focus-follows-cursor = "always";

        # Defines how warp mode of the cursor is handled. - disabled|on-output-change|on-focus-change
        # Example could be that when focus is changed to a different window the cursor will be warped to the center of the window.
        set-cursor-warp = "on-focus-change";

        # Hides the cursor when typing. - when-typing enabled|disabled
        hide-cursor = "when-typing enabled";

        # 

      };
    };
  };
}
