{
  config,
  lib,
  pkgs,
  ...
}:
let
  username = config.hostSpec.username;
in
{
  specialisation.ai = {
    inheritParentConfig = true;

    configuration = {
      home-manager.users.${username} = {
        imports = lib.flatten [
          (map lib.custom.relativeToRoot [
            "home/global/common/ai/claude-cli.nix"
            "home/global/common/ai/gemini-cli.nix"
          ])
        ];
      };
    };
  };
}
