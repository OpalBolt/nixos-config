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
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
  secretspath = builtins.toString inputs.nix-secrets.outPath;
in
{
  sops.secrets = {
    hashedPassword = {
      sopsFile = "${secretspath}/secrets/${config.hostSpec.hostname}.yaml";
      key = "user/password";
      neededForUsers = true;
    };
    rootHashedPassword = {
      sopsFile = "${secretspath}/secrets/${config.hostSpec.hostname}.yaml";
      key = "user/rootPassword";
      neededForUsers = true;
    };
  };
  #users.mutableUsers = false;

  # Define the user with the specified username
  users.users.${username} = {
    isNormalUser = true;
    description = config.hostSpec.userFullName or "${config.hostSpec.name} (${username})";
    #hashedPasswordFile = config.sops.secrets.hashedPassword.path;
    uid = 1000;

    extraGroups = lib.flatten [
      "wheel"
      (ifTheyExist [
        "networkmanager"
        "audio"
        "input"
        "video"
        "docker"
        "optical"
        "storage"
        "libvirtd"
      ])
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
  programs.zsh.enable = true;

  ## Set up ROOT user
  users.users.root = {
    shell = pkgs.bash;
    #hashedPasswordFile = config.sops.secrets.rootHashedPassword.path;
    #openssh.authorizedKeys.keys = user.ssh.publicKeys or [ ];
  };

}
// lib.optionalAttrs (inputs ? "home-manager" && !isMinimal) {
  # Set up home-manager for the configured user
  # Disabled for minimal installations (servers, etc.)
  home-manager = {
    useGlobalPkgs = true;
    backupFileExtension = "bak";
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
              (lib.custom.relativeToRoot "home/users/${username}/${hostSpec.hostname}.nix")
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
