{
  lib,
  hostSpec,
  ...
}:
{
  imports = lib.flatten [
    (map lib.custom.relativeToRoot [
      "home/global/core"
      "home/global/common/sys/complex-fonts.nix"
      "home/global/common/tools/bat.nix"
    ])

    ./core
  ];

}
