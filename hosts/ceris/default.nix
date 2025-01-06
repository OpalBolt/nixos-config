{pkgs, inputs, vars, home-manager, ...}: 

{

  imports = [ 
    ./hardware-configuration.nix # Handles Hardware configurations for this machine
    ./../../modules/nixos
  ];
  networking.hostName = vars.hostname;

  nos = {
    system = {
      networking.enable = true;
    };
    #desktop.gnome.enable = true;
  };

  

}
