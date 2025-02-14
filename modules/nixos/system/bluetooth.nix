{ pkgs, ... }:

{
  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings.general = {
        enable = "Source,Sink,Media,Socket";
        experimental = true;
      };
    };
    pulseaudio = {
      #enable = true;
      package = pkgs.pulseaudioFull;
    };
  };
  services.blueman.enable = true;
}
