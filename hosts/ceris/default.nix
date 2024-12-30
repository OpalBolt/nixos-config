{pkgs, inputs, vars, home-manager, ...}: 

{

  imports = [ ./hardware-configuration.nix ];

  boot.initrd.luks.devices."luks-a34dc261-c8a7-49ee-ac4e-6f10c3a84abe".device = "/dev/disk/by-uuid/a34dc261-c8a7-49ee-ac4e-6f10c3a84abe";

}
