{
  pkgs,
  ...
}:
{
  specialisation.ai = {
    inheritParentConfig = true;

    configuration = {
      home-manager.users.mads = {
        imports = [
          ../../home/global/common/ai/claude-cli.nix
        ];
      };
    };
  };
}
