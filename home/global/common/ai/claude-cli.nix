{
  inputs,
  config,
  hostSpec,
  pkgs,
  ...
}:
let
  customersPath =
    config.home.sessionVariables.CUSTOMERS_PATH or "${config.home.homeDirectory}/git/work/customers";
  secretspath = builtins.toString inputs.nix-secrets.outPath;
in
{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  sops.secrets = {
    "zai/claudetoken" = {
      sopsFile = "${secretspath}/secrets/per-mads.yaml";
    };
  };

  programs.claude-code = {
    enable = true;
    package = pkgs.unstable.claude-code;
  };
  home.sessionVariables = {
    ANTHROPIC_BASE_URL = "https://api.z.ai/api/anthropic";
    API_TIMEOUT_MS = "3000000";
  };
  
  programs.zsh.initContent = ''
     if [ -f "${config.sops.secrets."zai/claudetoken".path}" ]; then
       export ANTHROPIC_BASE_URL="https://api.z.ai/api/anthropic"
       export ANTHROPIC_AUTH_TOKEN=$(cat ${config.sops.secrets."zai/claudetoken".path})
       export API_TIMEOUT_MS="3000000"
     fi
   '';

}