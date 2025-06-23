# Host-specific variable settings
{ config, lib, pkgs, ... }:

{
  # Set all values according to the hostSpec structure from default.nix
  hostSpec = {
    # System variables
    hostname = "ceris";
    system = "x86_64-linux";
    timezone = "Europe/Copenhagen";
    locale = "en_DK.UTF-8";
    extraLocale = "da_DK.UTF-8";
    kbdLayout = "dk";
    consoleKbdKeymap = "dk-latin1";
    
    # User variables
    username = "mads";
    name = "Mads";
    userFullName = "Mads Kristiansen";
    email = builtins.readFile config.sops.secrets.personal-email.path;
    hashedPassword = config.sops.secrets.hashedPassword.path;
    rootHashedPassword = config.sops.secrets.rootHashedPassword.path;
    dotfilesDir = "~/.dotfiles";
    font = "IosevkaTerm Nerd Font Mono";
    editor = "nvim";
    fontSize = 10;
    shell = pkgs.zsh;
    
    # Configuration flags
    isMinimal = false;
    isMobile = false;
    isServer = false;
    isWork = false;
    useYubikey = false;
    useWindowManager = true;
    scaling = "1";
  };
}
