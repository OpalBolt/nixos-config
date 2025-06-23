# Host-specific variable settings
{ config, lib, ... }:

{
  # Set the values for system variables
  systemVars = {
    hostname = "ceris";
    system = "x86_64-linux";
    timezone = "Europe/Copenhagen";
    locale = "en_DK.UTF-8";
    extraLocale = "da_DK.UTF-8";
    kbdLayout = "dk";
    consoleKbdKeymap = "dk-latin1";
    isMinimal = false;
  };
  
  # Set the values for user variables
  userVars = {
    userName = "mads";
    name = "Mads";
    hashedPassword = config.sops.secrets.hashedPassword.path;
    rootHashedPassword = config.sops.secrets.rootHashedPassword.path;
    fullName = "Mads Kristiansen";
    dotfilesDir = "~/.dotfiles";
    font = "IosevkaTerm Nerd Font Mono";
    editor = "nvim";
    fontSize = 10;
    email = builtins.readFile config.sops.secrets.personal-email.path;
  };
}
