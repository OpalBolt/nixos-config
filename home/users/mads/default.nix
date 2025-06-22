{
  lib,
  userVars,
  systemVars,
  ...
}:
{
  imports = [
    (lib.custom.relativeToRoot "home/core")
  ];
  home.sessionVariables = {
    CUSTOMERS_PATH = "/home/mads/git/work/customers/";
  };

  home.file = {
    "scripts" = {
      source = lib.custom.relativeToRoot "dotfiles/scripts";
      recursive = true;
    };
  };
}
