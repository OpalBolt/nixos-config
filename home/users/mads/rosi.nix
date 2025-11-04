{ lib, hostSpec, ... }:
{
  imports = lib.flatten [
    (map lib.custom.relativeToRoot [
      "home/global/core"
      "home/users/defaults/laptop.nix"
      "home/users/defaults/work.nix"
      "home/global/common/comms/discord.nix"
      "home/global/common/comms/weechat.nix"
      "home/global/common/dev/git.nix"
      "home/global/common/editors/neovim.nix"
      "home/global/common/work/work-apps.nix"
      "home/global/common/work/time-helper.nix"
      "home/global/common/dev/devops.nix"
      "home/global/common/common.nix"
      "home/global/common/tools/csv.nix"
      "home/global/common/tools/go-task.nix"
      "home/global/common/shell/web-tools.nix"
      "home/global/common/editors/obsidian.nix"
      "home/global/common/productivity/taskmanager.nix"

    ])

    ./core
  ];

}
