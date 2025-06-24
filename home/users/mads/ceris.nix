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
          ])

    (lib.custom.relativeToRoot "home/global/core")
    ./core
  ];

}
