{ ... }:
{
  # Start waybar
  wb = "systemctl --user restart waybar.service";

  # Set screens
  wlh = "bash ~/scripts/wlr/home.sh";
  wlw = "bash ~/scripts/wlr/work.sh";

  # Ensure -al is always used
  ls = "eza -mh1la --classify=always --icons=always --color=always --group-directories-first --git";

  # Dont use vim by mistake
  vim = "nvim";
  vi = "nvim";

  # use g instead of git
  g = "git";
  lg = "lazygit";

  # use zoxide over cd
  cd = "z";

  # add a newline before neofetch
  neofetch = "fastfetch";

  # runs the customer.sh script.
  cu = "bash ~/scripts/customers.sh";

  # uploads files to gdrive and add it to git
  cup = "bash ~/scripts/uploadcustdocument.sh";

  # Run git-leaks on current directory
  gle = "podman run --rm -v $\{\PWD}\:/path docker.io/zricethezav/gitleaks:latest git --verbose /path";
}
