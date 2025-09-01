{ pkgs, ... }:

{
  programs.kubecolor = {
    enable = true;
    enableAlias = true;
  };
  programs.k9s.enable = true;

  ## Nix installed apps
  home.packages = with pkgs; [

    kubectl
    yamllint
    kubeconform
    #fluxcd

    #trivy
    #prettier
    #codeql
    markdownlint-cli
    pre-commit
    go-task

    #opentofu
    #tflint

    #talosctl

  ];
}
