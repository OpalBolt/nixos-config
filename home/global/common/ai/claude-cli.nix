{
  inputs,
  config,
  hostSpec,
  pkgs,
  ...
}:
let
  secretspath = builtins.toString inputs.nix-secrets.outPath;
in
{

  programs.claude-code = {
    enable = true;
    package = pkgs.unstable.claude-code;
  };

}
