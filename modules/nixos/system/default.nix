{ ... }:

{
  imports = [
    ./networking.nix
    ./displayManager
    ./services.nix
  ];

  # TODO: Into other module
  security.polkit.enable = true;
}
