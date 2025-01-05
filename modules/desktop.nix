let
  collectionTemplate = ./../templates/collectionTemplate.nix;
  modulesDict = {
    gnome = ./nixos/desktop/gnome;
    hyprland = ./home-manager/desktop/hyprland;
  };
  desktop = collectionTemplate {
    modulesDict = modulesDict;
    systemName = "desktop";
  };
in
  {
  imports = [ desktop ];
  
  desktop.enableGnome = true;
  desktop.enableHyprland = false;
}

