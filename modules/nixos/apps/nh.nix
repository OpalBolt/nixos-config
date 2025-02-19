{ userVars, ... }:

{
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep 5";
    flake = "/home/" + userVars.userName + "/nix-dots";
  };
}
