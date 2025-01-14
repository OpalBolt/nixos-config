{ ... }:

{
  imports = [
    ./networking.nix
    ./displayManager
  ];

  # TODO: Into other module
  security.polkit.enable = true;
}
