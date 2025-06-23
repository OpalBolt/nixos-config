{
  lib,
  hostSpec,
  ...
}:
{
  imports = [
    (lib.custom.relativeToRoot "home/global/core")
    ./core
  ];

}
