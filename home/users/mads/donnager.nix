{ lib, ... }:
{
  imports = lib.flatten [
    (map lib.custom.relativeToRoot [
      "home/users/defaults/general.nix"

      # Desktop environment
      "home/global/common/desktop/gtk.nix"
      "home/global/common/desktop/river.nix"

      # Communication
      "home/global/common/comms/discord.nix"
    ])

    # Sets home.username, home.homeDirectory, home.stateVersion, and global core
    ./core
  ];
}
