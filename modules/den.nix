# Import Den's flake-parts module to enable the den.* options
{ inputs, ... }: {
  imports = [ inputs.den.flakeModule ];
}
