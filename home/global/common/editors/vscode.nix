{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    package = pkgs.unstable.vscode-fhs;
    mutableExtensionsDir = true;
    profiles.default = {
      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;
      userSettings = {
        "[jsonc]" = {
          "editor.defaultFormatter" = "vscode.json-language-features";
        };
        "[shellscript]" = {
          "editor.defaultFormatter" = "mkhl.shfmt";
        };
        "[yaml]" = {
          "editor.defaultFormatter" = "redhat.vscode-yaml";
        };
      };
      extensions = with pkgs; [

        # General plugins
        open-vsx.mikestead.dotenv
        open-vsx.pflannery.vscode-versionlens
        vscode-marketplace.ms-vscode-remote.remote-containers

        # Nix related
        # vscode-marketplace.github.copilot
        # vscode-marketplace.github.copilot-chat
        open-vsx.jnoortheen.nix-ide
        #alvarosannas.nix

        # Bash
        open-vsx.timonwong.shellcheck
        open-vsx.mads-hartmann.bash-ide-vscode
        open-vsx.mkhl.shfmt
        open-vsx.rogalmic.bash-debug

        # Python
        open-vsx.ms-python.python

        # Formatting
        open-vsx.esbenp.prettier-vscode

        # YAML
        open-vsx.redhat.vscode-yaml

        # Markdown
        open-vsx.yzhang.markdown-all-in-one
        open-vsx.davidanson.vscode-markdownlint

        # Terraform
        open-vsx.hashicorp.terraform

        # Kubernetes
        open-vsx.ms-kubernetes-tools.vscode-kubernetes-tools
      ];
    };
  };
}
