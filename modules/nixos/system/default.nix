{ ... }:

{
  imports = [
    ./networking.nix
    ./displayManager
    ./services.nix
    ./virtualization.nix
  ];

  # TODO: Into other module
  security.polkit.enable = true;
}
