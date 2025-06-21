{
  vars,
  ...
}:

{

  imports = [
    ./hardware-configuration.nix # Handles Hardware configurations for this machine
    ./../../modules/nixos
    ./../../modules/nixos/efi
  ];
  networking.hostName = vars.hostname;

  feature = {
    networking.enable = true;
    networking.firewall.enable = true;
    work-pkgs.enable = true;
  };

  feature = {
    desktop.river.enable = true;
    desktop.hyprland.enable = false;
  };

  # nos = {
  #   system = {
  #     networking.enable = true;
  #   };
  #   work-pkgs.enable = true;
  #   #desktop.gnome.enable = true;
  #
  # };

}
