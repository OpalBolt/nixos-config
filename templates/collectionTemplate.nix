# collectionTemplate.nix
# A NixOS collection template for managing a set of modules under a common namespace.
# 
# Example usage:
# 
# let
#   collectionTemplate = import ./collectionTemplate.nix;
#   modulesDict = {
#     foo = ./foo-module.nix;
#     bar = ./bar-module.nix;
#   };
# in
#   collectionTemplate {
#     modulesDict = modulesDict;
#     systemName = "mySystem";
#     lib = pkgs.lib;
#     config = config;
#     ...
#   }
# 
# This will generate options such as `mySystem.enableFoo` and `mySystem.enableBar`
# for enabling or disabling the `foo` and `bar` modules, respectively.

{ modulesDict, systemName, lib, config, ... }:

let
  # Import each module from the provided dictionary
  importModules = lib.mapAttrs (name: path: import path) modulesDict;
in
{
  options = lib.mkMerge (
    lib.mapAttrsToList (name: _: 
      let
        fullName = "${systemName}.enable${lib.capitalize name}";
      in
      {
        ${fullName} = lib.mkEnableOption "Enable the ${name} module under ${systemName}.";
      }
    ) modulesDict
  );

  config = lib.mkMerge (
    lib.mapAttrsToList (name: module:
      let
        fullName = "${systemName}.enable${lib.capitalize name}";
      in
      lib.mkIf (config.${fullName}) module.config
    ) importModules
  );
}

