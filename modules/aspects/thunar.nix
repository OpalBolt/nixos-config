{ ... }:
{
  den.aspects.thunar.nixos = { pkgs, ... }: {
    programs = {
      thunar = {
        enable = true;
        plugins = with pkgs.xfce; [
          thunar-archive-plugin
          thunar-media-tags-plugin
          thunar-volman
        ];
      };
      xfconf.enable = true;
    };
    services = {
      gvfs.enable = true;
      udisks2.enable = true;
      tumbler.enable = true;
    };
  };
}
