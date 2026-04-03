{ pkgs, ... }:
{
  home.packages = [
    (pkgs.writeShellScriptBin "gotask" ''
      exec ${pkgs."go-task"}/bin/task "$@"
    '')
  ];
}
