{ inputs, ... }:
{
  den.aspects.git.homeManager =
    { inputs, config, pkgs, ... }:
    let
      publicGitEmail = inputs.nix-secrets.email.git;
      workEmail = inputs.nix-secrets.email.work;
      privateGitConfig = "${config.home.homeDirectory}/.config/git/gitconfig.private";
      workGitConfig = "${config.home.homeDirectory}/.config/git/gitconfig.work";
    in
    {
      home.packages = with pkgs; [ direnv act gh yq-go ];

      programs.lazygit.enable = true;

      programs.git = {
        enable = true;
        settings = {
          user.name = inputs.nix-secrets.handle;
          user.email = publicGitEmail;
          init.defaultBranch = "main";
          pull.rebase = true;
          color.ui = true;
          core.editor = "nvim";
          push.autoSetupRemote = true;
          includeIf."gitdir:${config.home.homeDirectory}/git/personal/".path = privateGitConfig;
          includeIf."gitdir:${config.home.homeDirectory}/nix/".path = privateGitConfig;
          includeIf."gitdir:${config.home.homeDirectory}/work/".path = workGitConfig;
          diff.tool = "delta";
          commit.gpgsign = false;
          aliases = {
            aliases = "!git config --list | grep 'alias\\.' | sed 's/alias\\.\\([^=]*\\)=\\(.*\\)/\\1\\ \t => \\2/' | sort";
            unstage = "reset HEAD --";
            cm = "commit -m";
            s = "status";
            p = "push";
            b = "branch -avv";
            g = "!git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %C(bold blue)<%an>%Creset %Cgreen(%cr)%Creset %s' --abbrev-commit --date=relative --all";
            l = "!git log --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %C(bold blue)<%an>%Creset %Cgreen(%cr)%Creset %s' --abbrev-commit --date=relative -n 10";
          };
        };
        ignores = [
          "result" "result-*" "*.drv" ".direnv" ".envrc" ".csvignore"
          "*.py?" "*.pyc" "__pycache__/" ".venv/" "venv/" ".env"
          ".pytest_cache/" "*.egg-info/" "dist/" "build/"
          ".vscode/" ".idea/" "*.swp" "*.swo" "*~" ".DS_Store"
          "Thumbs.db" "*.log" "*.tmp" ".cache/"
        ];
      };

      programs.delta = {
        enable = true;
        options = {
          side-by-side = true;
          navigate = true;
          light = false;
          line-numbers = true;
          commit-decoration = true;
          zero-style = "syntax dim";
          minus-style = "syntax bold auto";
        };
      };

      home.file."${privateGitConfig}".text = ''
        [user]
          name = "${inputs.nix-secrets.handle}"
          email = ${publicGitEmail}
      '';

      home.file."${workGitConfig}".text = ''
        [user]
          name = "Mads Kristiansen"
          email = "${workEmail}"
      '';
    };
}
