{
  lib,
  hostSpec,
  ...
}:
{
  imports = lib.flatten [
    (map lib.custom.relativeToRoot [
      "home/global/core"
      "home/global/users/defaults/laptop.nix"
      

      #"home/global/common/"
    ])

    ./core
  ];

}
