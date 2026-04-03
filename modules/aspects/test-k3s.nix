# test-k3s aspect — K3s VM test environment.
{ den, inputs, ... }:
{
  den.aspects."test-k3s" = {
    includes = [
      den.aspects.core
      den.aspects.audio
      den.aspects.bluetooth
      den.aspects.chromium-policies
      den.aspects.containers
      den.aspects.fonts
      den.aspects.gnome
      den.aspects.laptop
      den.aspects.networking
      den.aspects.printing
      den.aspects.qmk
      den.aspects.solaar
      den.aspects.thunar
      den.aspects.vpn
      den.aspects.work-vpn
      den.aspects.work-wifi
    ];

    nixos =
      { lib, ... }:
      {
        imports = [
          inputs.hardware.nixosModules.framework-amd-ai-300-series
          inputs.hardware.nixosModules.common-pc-laptop-ssd
          inputs.hardware.nixosModules.common-gpu-amd
          inputs.hardware.nixosModules.common-cpu-amd
          (lib.custom.relativeToRoot "hosts/nixos/test-k3s/hardware-configuration.nix")
          (lib.custom.relativeToRoot "hosts/nixos/test-k3s/config")
        ];
        services.fwupd.enable = true;
        services.hardware.bolt.enable = true;
        programs.nix-ld.enable = true;
        system.stateVersion = "25.05";
      };
  };
}
