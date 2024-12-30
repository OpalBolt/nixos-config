{pkgs, inputs, vars, ...}: 

{

  imports = [ ./hardware-configuration.nix ];

  home-manager.nixosModules.home-manager = 
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${vars.username} = import ./hosts/ceris/home.nix;
            };
}
