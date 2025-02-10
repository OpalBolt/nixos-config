{ ... }:

{
  imports = [
    ./networking.nix
    ./displayManager
    ./services.nix
    ./virtualization.nix
    ./system.nix
  ];

}
