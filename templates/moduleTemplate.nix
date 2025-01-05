# File: moduleTemplate.nix
# Description: Reusable NixOS module template
#
# This file is a utility for streamlining the creation of NixOS modules. 
# It defines a template function that accepts the following parameters:
#
# - `name`: The unique name of the module.
# - `enableDescription`: A description for the `enable` option of the module.
# - `configContent`: The configuration to apply when the module is enabled.
#
# Example of how to use this template:
# 
#```
# let
#   moduleTemplate = import ./moduleTemplate.nix;
# in
#   moduleTemplate {
#     name = "exampleModule";
#     enableDescription = "Enable the example module";
#     configContent = {
#       # Your module-specific configuration here
#     };
#   }
# ```

{ name, enableDescription, configContent }: 

{ config, lib, ... }: 

{
  options = {
    ${name}.enable = lib.mkEnableOption enableDescription;
  };

  config = lib.mkIf config.${name}.enable configContent;
}