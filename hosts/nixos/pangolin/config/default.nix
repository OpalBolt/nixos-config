# Import all configuration modules for Pangolin
{ lib, ... }:
{
  imports = lib.custom.scanPaths ./.;
}
