{ lib, hostSpec, ... }: {
  imports = lib.flatten [
    (map lib.custom.relativeToRoot [

      # Desktop Environment
      "home/global/common/desktop/gtk.nix"
      "home/global/common/desktop/river.nix"

      # Editors
      "home/global/common/editors/neovim.nix"
      "home/global/common/editors/vscode.nix"
      "home/global/common/editors/zed.nix"

    ])
  ];

}
