# Development utilities I want across all systems
{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  publicGitEmail = config.hostSpec.email.git;
  sshFolder = "${config.home.homeDirectory}/.ssh";
  publicKey =
    if config.hostSpec.useYubikey then "${sshFolder}/id_yubikey.pub" else "${sshFolder}/id_ed25519.pub";
  privateGitConfig = "${config.home.homeDirectory}/.config/git/gitconfig.private";
  workEmail = inputs.nix-secrets.email.work;
  workGitConfig = "${config.home.homeDirectory}/.config/git/gitconfig.work";
in
{
  home.packages = lib.flatten [
    (builtins.attrValues {
      inherit (pkgs)
        # Development
        direnv
        delta # diffing
        act # github workflow runner
        gh # github cli
        yq-go # Parser for Yaml and Toml Files, that mirrors jq
        ;
    })
  ];

  #NOTE: Already enabled earlier, this is just extra config
  programs.git = {
    userName = config.hostSpec.handle;
    userEmail = publicGitEmail;

    # Enforce SSH to leverage yubikey
    extraConfig = {
      log.showSignature = "true";
      init.defaultBranch = "main";
      pull.rebase = "true";

      includeIf."gitdir:${config.home.homeDirectory}/git/personal/".path = privateGitConfig;
      includeIf."gitdir:${config.home.homeDirectory}/nix/".path = privateGitConfig;
      includeIf."gitdir:${config.home.homeDirectory}/work/".path = workGitConfig;
      diff.tool = "delta";

      commit.gpgsign = true;
      gpg.format = "ssh";
      # Signing key for non-yubikey hosts
      user.signingkey = "${publicKey}";
      # Taken from https://github.com/clemak27/homecfg/blob/16b86b04bac539a7c9eaf83e9fef4c813c7dce63/modules/git/ssh_signing.nix#L14
      gpg.ssh.allowedSignersFile = "${config.home.homeDirectory}/.ssh/allowed_signers";
    };
    signing = {
      signByDefault = true;
      key = publicKey;
    };
    ignores = [
      ".direnv"
      "result"
    ];
  };

  home.file.".ssh/allowed_signers".text = ''
    ${publicGitEmail} ${lib.fileContents (lib.custom.relativeToRoot config.hostSpec.networking.ssh.publicKeys.opalbolt)}
  '';

  home.file."${privateGitConfig}".text = ''
    [user]
      name = "${config.hostSpec.handle}"
      email = ${publicGitEmail}
  '';
  home.file."${workGitConfig}".text = ''
    [user]
      name = "${config.hostSpec.userFullName}"
      email = "${workEmail}"
  '';
}
