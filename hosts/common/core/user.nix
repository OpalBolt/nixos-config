{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  # Import the hostSpec from the configuration
  hostSpec = config.hostSpec;
  # Use the new hostSpec variables
  username = config.hostSpec.username;
  # Get user-specific flags
  isMinimal = config.hostSpec.isMinimal;
in
{
  users.mutableUsers = false;

  # Define the user with the specified username
  users.users.${username} = {
    isNormalUser = true;
    description = config.hostSpec.userFullName or "${config.hostSpec.name} (${username})";
    hashedPassword = config.hostSpec.hashedPassword;
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
    home = lib.mkDefault (config.hostSpec.home);
    createHome = true;
    homeMode = "0750";

    # Use the user's shell, defaulting to bash if not specified
    shell = config.hostSpec.shell;
  };

  ## Enable relevant services
  programs.git.enable = true;

  ## Set up ROOT user
  users.users.root = {
    shell = pkgs.bash;
    hashedPasswordFile = lib.mkForce config.hostSpec.rootHashedPassword;
    #openssh.authorizedKeys.keys = user.ssh.publicKeys or [ ];
  };

}
// lib.optionalAttrs (inputs ? "home-manager") {
  # Set up home-manager for the configured user
  home-manager = {
    extraSpecialArgs = {
      inherit pkgs inputs;
      hostSpec = config.hostSpec;
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
                  lib.custom.relativeToRoot "home/users/${username}/${hostSpec.hostname}.nix"
              )
              {
                inherit
                  config
                  hostSpec
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
