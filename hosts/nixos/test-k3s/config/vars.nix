# Host-specific variable settings
{ config, lib, pkgs, hostSpec, inputs, ... }: {
  # Set all values according to the hostSpec structure from default.nix
  hostSpec = {
    # System variables
    hostname = "scopuli";
    system = "x86_64-linux";
    timezone = "Europe/Copenhagen";
    locale = "en_DK.UTF-8";
    extraLocale = "da_DK.UTF-8";
    kbdLayout = "dk";
    consoleKbdKeymap = "dk-latin1";

    # User variables
    username = "opalbolt";
    name = "Mads";
    userFullName = "Mads Kristiansen";
    hashedPassword = config.sops.secrets.hashedPassword.path;
    rootHashedPassword = config.sops.secrets.rootHashedPassword.path;

    # Configuration flags
    isWork = false;
    isMinimail = true;
    useYubikey = false;
    useWindowManager = true;
    scaling = "1";
    handle = inputs.nix-secrets.handle;
  };
}
