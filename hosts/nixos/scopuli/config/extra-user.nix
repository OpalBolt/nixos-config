{ config, lib, ... }:
let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in
{
  users.users.nadia = {
    isNormalUser = true;
    description = config.hostSpec.userFullName or "${config.hostSpec.name} (nadia)";
    #hashedPasswordFile = config.sops.secrets.hashedPassword.path;
    uid = 1001;

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
    home = "/home/nadia";
    createHome = true;
    homeMode = "0750";

    # Use the user's shell, defaulting to bash if not specified
    shell = config.hostSpec.shell;
  };
}
