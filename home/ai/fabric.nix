{ inputs, config, pkgs, ... }:
let
  secretspath = toString inputs.nix-secrets.outPath;
in
{
  imports = [ inputs.sops-nix.homeManagerModules.sops ];
  sops.secrets."zai/fabrictoken".sopsFile = "${secretspath}/secrets/per-mads.yaml";
  programs.fabric-ai.enable = true;
  programs.zsh.initContent = ''
    if [ -f "${config.sops.secrets."zai/fabrictoken".path}" ]; then
      export OPENAI_API_KEY=$(cat ${config.sops.secrets."zai/fabrictoken".path})
      export OPENAI_API_BASE_URL="https://api.z.ai/v1"
    fi

    noglob_qq() {
      fabric --pattern=linux_commands --stream --thinking=low "$*"
    }
    alias '??'='noglob noglob_qq'
  '';
}
