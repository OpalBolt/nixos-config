{ lib, hostSpec, ... }: {
  imports = lib.flatten [
    (map lib.custom.relativeToRoot [
      "home/global/core"
      "home/users/defaults/laptop.nix"
      "home/global/common/comms/discord.nix"
      "home/global/common/comms/weechat.nix"
      "home/global/common/dev/git.nix"
      "home/global/common/editors/neovim.nix"
      "home/global/common/common.nix"
    ])
    ./core
  ];
}
