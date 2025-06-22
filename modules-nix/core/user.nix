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

    ## Enable relevant services
    services.git.enable = true;

    ## Set up ROOT user
    users.users.root = {
      shell = pkgs.bash;
      hashedPasswordFile = lib.mkForce userVars.rootHashedPassword;
      #openssh.authorizedKeys.keys = user.ssh.publicKeys or [ ];
    };

  };
}
// lib.optionalAttrs (inputs ? "home-manager") {
  # Set up home-manager for the configured user
  home-manager = {
    extraSpecialArgs = {
      inherit pkgs inputs;
      inherit (config) userVars systemVars;
    };
    users = {
      root.home.stateVersion = "24.05"; # Avoid error
      ${username} = {
        imports = [
          (
            { config, ... }:
            import
              (
                if isMinimal then
                  lib.custom.relativeToRoot "home/global/core"
                else
                  lib.custom.relativeToRoot "home/users/${username}"
              )
              {
                inherit
                  config
                  userVars
                  systemVars
                  inputs
                  lib
                  pkgs
                  ;
              }
          )
        ];
      };
    };
  };
}
