# rosi aspect — Framework AMD AI 300, work+personal laptop with River WM.
# Also includes: libvirt, hardening, work-vpn, ai specialization.
{ den, inputs, ... }:
{
  den.aspects.rosi = {
    includes = [
      den.aspects.core
      den.aspects.audio
      den.aspects.bluetooth
      den.aspects.chromium-policies
      den.aspects.containers
      den.aspects.fonts
      den.aspects.hardening
      den.aspects.laptop
      den.aspects.libvirt
      den.aspects.networking
      den.aspects.printing
      den.aspects.qmk
      den.aspects.river
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
          (lib.custom.relativeToRoot "hosts/nixos/rosi/hardware-configuration.nix")
          (lib.custom.relativeToRoot "hosts/nixos/rosi/config")
          # HM managed by legacy for now — migrated to den in Phase 4
          (lib.custom.relativeToRoot "hosts/common/optional/home-manager.nix")
          # NixOS specialization for AI tools (Phase 5: consider converting to aspect)
          (lib.custom.relativeToRoot "hosts/specialization/ai.nix")
        ];
        services.fwupd.enable = true;
        services.hardware.bolt.enable = true;
        programs.nix-ld.enable = true;
        services.fail2ban.enable = false;
        networking.hosts = { "192.168.60.10" = [ "test.plikki.com" ]; };
        system.stateVersion = "25.05";
      };
  };
}
