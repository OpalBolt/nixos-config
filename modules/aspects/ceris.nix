# ceris aspect — ThinkPad T14s, work laptop with River WM.
{ den, inputs, ... }:
{
  den.aspects.ceris = {
    includes = [
      den.aspects.core
      den.aspects.audio
      den.aspects.bluetooth
      den.aspects.containers
      den.aspects.chromium-policies
      den.aspects.fonts
      den.aspects.laptop
      den.aspects.networking
      den.aspects.printing
      den.aspects.qmk
      den.aspects.river
      den.aspects.solaar
      den.aspects.thunar
      den.aspects.vpn
      den.aspects.work-wifi
    ];

    nixos =
      { lib, ... }:
      {
        imports = [
          inputs.hardware.nixosModules.lenovo-thinkpad-t14s
          inputs.hardware.nixosModules.common-pc-laptop-ssd
          inputs.hardware.nixosModules.common-gpu-intel
          inputs.hardware.nixosModules.common-cpu-intel
          (lib.custom.relativeToRoot "hosts/nixos/ceris/hardware-configuration.nix")
          (lib.custom.relativeToRoot "hosts/nixos/ceris/config")
          # HM managed by legacy for now — migrated to den in Phase 4
          (lib.custom.relativeToRoot "hosts/common/optional/home-manager.nix")
        ];
        programs.nix-ld.enable = true;
        system.stateVersion = "24.11";
      };
  };
}
