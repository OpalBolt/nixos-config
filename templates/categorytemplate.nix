{ pkgs, lib, ... }:

{
 imports = [
    ./module1
    ./module2
  ];

  module1.enable = true;

  moduel2.enable = true;
}
