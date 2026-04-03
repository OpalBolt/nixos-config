{ pkgs, ... }:
{
  programs.kubecolor = {
    enable = true;
    enableAlias = true;
  };
  programs.k9s.enable = true;
  home.packages = with pkgs; [
    kubectl
    yamllint
    kubeconform
    markdownlint-cli
    pre-commit
  ];
}
