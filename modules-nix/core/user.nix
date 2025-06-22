{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  userVars = config.userVars;
  systemVars = config.systemVars;
  username = config.userVars.userName;
  # Get user-specific secrets if they exist
  isMinimal = config.systemVars.isMinimal or false;
  # Debugging trace to print userVars
  _ = builtins.trace "User variables: ${builtins.toJSON userVars}" null;
in
{
  users.mutableUsers = false;
  
  # Define the user with the specified username
  users.users.${username} = {
    isNormalUser = true;
    description = userVars.fullName or "${userVars.name} (${username})";
    hashedPassword = userVars.hashedPassword;
    uid = 1000;
    extraGroups = [
      "wheel"
      "networkmanager"
      "audio"
      "input"
      "video"
      "docker"
      "optical"
      "storage"
      "libvirtd"
    ];

    # Set the home directory to a custom location if specified
    home = lib.mkDefault ("/home/${username}");
    createHome = true;
    homeMode = "0750";

    # Use the user's shell, defaulting to bash if not specified
    shell = userVars.shell;

    # Add any additional configuration needed for this user
  };
}
