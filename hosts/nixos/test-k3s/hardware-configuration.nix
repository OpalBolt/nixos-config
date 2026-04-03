# hardware-configuration.nix — STUB
# TODO: Replace with output of `nixos-generate-config` on the actual test-k3s machine.
# Run: nixos-generate-config --show-hardware-config > hosts/nixos/test-k3s/hardware-configuration.nix
{ lib, modulesPath, ... }:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
  # Placeholder — actual hardware config must be generated on the machine.
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" ];
}
