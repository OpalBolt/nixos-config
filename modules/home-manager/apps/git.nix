{ pkgs, ... }:
{
  programs.lazygit.enable = true;
  programs.git = {
    enable = true;
    userName = "Hexamo";
    userEmail = "git@skumnet.dk";

    #signing = {
    # enabling this will sign both commits and tags,
    # which will have the side effect of creating 'annotated' tags
    # by default, which can be problematic for references on github
    # instead I explicitly enable commit signing below
    #signByDefault = false;
    # key = key comes here
    #};

    extraConfig = {
      #commit.gpgSign = true;
      pull.rebase = true;
      push.autoSetupRemote = true;
      color.ui = true;
      core.editor = "nvim";

    };
    delta = {
      enable = true;
      options = {
        side-by-side = true;
        navigate = true;
        light = false;
        line-numbers = true;
        syntax-theme = "OneHalfDark";
        zero-style = "syntax dim";
        minus-style = "syntax bold auto";
      };
    };

    aliases = {
      # list aliases
      aliases = "!git config --list | grep 'alias\\.' | sed 's/alias\\.\\([^=]*\\)=\\(.*\\)/\\1\\ \t => \\2/' | sort";
      # Unstage changes from the index
      unstage = "reset HEAD --";
      # show git log history
      g = "!git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %C(bold blue)<%an>%Creset %Cgreen(%cr)%Creset %s' --abbrev-commit --date=relative --all";
      # small log output
      l = "!git log --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %C(bold blue)<%an>%Creset %Cgreen(%cr)%Creset %s' --abbrev-commit --date=relative -n 10";
      la = "!git log --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %C(bold blue)<%an>%Creset %Cgreen(%cr)%Creset %s' --abbrev-commit --date=relative -n 10 --all";
      lag = "!git log --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %C(bold blue)<%an>%Creset %Cgreen(%cr)%Creset %s' --abbrev-commit --date=relative -n 10 --all --graph";
      # commit with a message
      cm = "commit -m";
      # list all branches
      b = "branch -avv";
      # status
      s = "status";
      # push
      p = "push";
      # clean interactive
      ci = "clean -i";
    };

  };
}
