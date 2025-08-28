{
  inputs,
  pkgs,
  ...
}:
{
  hardware.keyboard.qmk.enable = true;
  environment.systemPackages = with pkgs; [
    via
    qmk
  ];
  services.udev.packages = [
    pkgs.via
    pkgs.vial
  ];
}
