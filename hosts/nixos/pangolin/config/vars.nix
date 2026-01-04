# Host-specific variable settings for Pangolin reverse proxy server
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  # Only valid hostSpec fields from lib/vars/default.nix
  hostSpec = {
    # System variables
    hostname = "pangolin";
    system = "x86_64-linux";
    timezone = "Europe/Copenhagen";
    locale = "en_DK.UTF-8";
    extraLocale = "da_DK.UTF-8";
    kbdLayout = "dk";
    consoleKbdKeymap = "dk-latin1";
    isMinimal = true; # Server - minimal installation

    # User variables
    username = "mads";
    name = "Mads";
    userFullName = "Mads Kristiansen";
    hashedPassword = config.sops.secrets.hashedPassword.path;
    rootHashedPassword = config.sops.secrets.rootHashedPassword.path;
    shell = pkgs.bash; # Server uses bash for simplicity

    # Configuration flags
    isWork = false;
    useYubikey = false;
    useWindowManager = false; # Server - no GUI
    scaling = "1";
    handle = inputs.nix-secrets.handle;
  };
}
