{ ... }:

{
  imports = [
    ./audio.nix
    ./fonts.nix
    ./networking.nix
    ./displayManager
    ./services.nix
    ./virtualization.nix
    ./system.nix
    ./bluetooth.nix
    ./security.nix
    ./secrets.nix
    ./vpn.nix
  ];

}
