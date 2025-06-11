{ pkgs, ... }:

{
  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      input = {
        General = {
          UserspaceHID = true;
        };
      };

      settings.general = {
        enable = "Source,Sink,Media,Socket";
        experimental = true;
      };
    };
  };
  services.blueman.enable = true;
  services.pulseaudio = {
    #enable = true;
    package = pkgs.pulseaudioFull;
  };

  environment.systemPackages = with pkgs; [
    bluez
  ];

}
