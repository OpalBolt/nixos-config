{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:
{
  imports = lib.flatten [

    ./config
    ./hardware-configuration.nix # Handles Hardware configurations for this machine

    inputs.hardware.nixosModules.lenovo-thinkpad-t14s
    inputs.hardware.nixosModules.common-pc-laptop-ssd
    inputs.hardware.nixosModules.common-gpu-intel
    inputs.hardware.nixosModules.common-cpu-intel

    (map lib.custom.relativeToRoot [

      ## Required Configs ##
      "hosts/common/core"
      "hosts/common/optional/sys-services/audio.nix"
      "hosts/common/optional/sys-services/bluetooth.nix"
      "hosts/common/optional/sys-services/laptop.nix"
      "hosts/common/optional/sys-services/libvirt.nix"
      "hosts/common/optional/sys-services/openssh.nix"
      "hosts/common/optional/sys-services/printing.nix"

      ## Required Configs ##
      #"hosts/global/core"

      ## Optional Configs ##
      # "hosts/global/common/audio.nix" # pipewire and cli controls
    ])
  ];

  # Use hostSpec.hostname to set the system hostname
  networking.hostName = config.hostSpec.hostname;

  # Run unpatched dynamic binaries on NixOS
  programs.nix-ld.enable = true;
  system.stateVersion = "24.11"; # No touchy touchy
}
