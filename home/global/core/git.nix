{
  inputs,
  hostSpec,
  ...
}:
{
  programs.lazygit.enable = true;
  programs.git = {
    enable = true;
    userName = hostSpec.handle; # use the username from hostSpec
    userEmail = inputs.nix-secrets.email.git; # use the email from nix-secrets

    ignores = [
      # Nix
      "result"
      "result-*"
      "*.drv"

      # Development tools
      ".direnv"
      ".envrc"
      ".csvignore"
    ];

    #signing = {
    # enabling this will sign both commits and tags,
    # which will have the side effect of creating 'annotated' tags
    # by default, which can be problematic for references on github
    # instead I explicitly enable commit signing below
    #signByDefault = false;
    # key = key comes here
    #};

    attributes = [
      "*.sh    text eol=lf"
      "*.nix   text eol=lf"
      ".envrc  text eol=lf"
    ];

  };
}
