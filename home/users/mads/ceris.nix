{
  lib,
  hostSpec,
  ...
}:
{
  imports = lib.flatten [
    (map lib.custom.relativeToRoot [
      "home/global/core"
      "home/global/common/browsers/firefox.nix"
      "home/global/common/comms/discord.nix"
      "home/global/common/shell/kitty.nix"
      "home/global/common/sys/complex-fonts.nix"
      "home/global/common/tools/bat.nix"
      "home/global/common/tools/direnv.nix"
      "home/global/common/desktop/river.nix"
      

      #"home/global/common/"
    ])

    ./core
  ];

}
