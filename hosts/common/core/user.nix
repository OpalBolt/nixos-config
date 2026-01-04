{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  # Use the new hostSpec variables
  username = config.hostSpec.username;
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

  # Define the user with the specified username
  users.users.${username} = {
    isNormalUser = true;
    description = config.hostSpec.userFullName or "${config.hostSpec.name} (${username})";
    uid = 1000;

    extraGroups = [
      "wheel"
    ]
    ++ ifTheyExist [
      "networkmanager"
      "audio"
      "input"
      "video"
      "docker"
      "optical"
      "storage"
      "libvirtd"
    ];

    home = lib.mkDefault config.hostSpec.home;
    createHome = true;
    homeMode = "0750";
    shell = config.hostSpec.shell;
  };

  ## Enable relevant services
  programs.git.enable = true;
  programs.zsh.enable = true;

  ## Set up ROOT user
  users.users.root = {
    shell = pkgs.bash;
  };
}
