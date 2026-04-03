# HM base aspect — sets up home-manager NixOS integration options.
# Included by hosts that have homeManager users (ceris, rosi).
# Den adds the home-manager NixOS module automatically when classes=["homeManager"],
# so we only need to configure the options here.
{ ... }:
{
  den.aspects.hm-base.nixos =
    { config, inputs, lib, ... }:
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "bak";
        # Pass hostSpec and inputs to all HM modules as special args.
        # lib.custom is inherited automatically (HM uses the NixOS lib).
        extraSpecialArgs = {
          inherit inputs;
          inherit (config) hostSpec;
        };
      };
    };
}
