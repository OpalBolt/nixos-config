{
  lib,
  hostSpec,
  ...
}:
{
  imports = lib.flatten [
    (map lib.custom.relativeToRoot [
      # Browsers
      "home/global/common/browsers/firefox.nix"
      "home/global/common/browsers/chromium.nix"

      # Entertainment
      "home/global/common/entertainment/music.nix"

      # Desktop Environment
      "home/global/common/desktop/gtk.nix"
      "home/global/common/desktop/river.nix"

      # Editors
      "home/global/common/editors/neovim.nix"

      # Office
      "home/global/common/productivity/libreoffice.nix"
      "home/global/common/productivity/nextcloud.nix"
      "home/global/common/productivity/thunderbird.nix"

      # Shell Apps
      "home/global/common/shell/common-tools.nix"
      "home/global/common/shell/kitty.nix"
      "home/global/common/shell/starship.nix"
      "home/global/common/shell/tealdeer.nix"
      "home/global/common/shell/yazi.nix"
      "home/global/common/shell/zellij.nix"
      #"home/global/common/shell/zsh.nix"

      # System and General Purpose Tools
      "home/global/common/sys/complex-fonts.nix"
      "home/global/common/sys/xdg.nix"

      # Tools
      "home/global/common/tools/bitwarden.nix"
      "home/global/common/tools/nix-related.nix"
    ])
  ];

}
