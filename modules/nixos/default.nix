{ ... }:
{
  imports = [
    ./system
    ./desktop
    ./common-pkgs.nix
    ./work-pkgs.nix
    ./apps
    ./user.nix
  ];
}
