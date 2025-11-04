{ pkgs, ... }:
{
  home.packages = with pkgs; [
    (pkgs.writeShellScriptBin "gotask" ''
      exec ${pkgs."go-task"}/bin/task "$@"
    '')
  ];
}
