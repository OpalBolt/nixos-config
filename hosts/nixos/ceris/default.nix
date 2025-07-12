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
      "hosts/common/optional/audio.nix" # pipewire and cli controls
      "hosts/common/optional/bluetooth.nix" # bluetooth controls
      "hosts/common/optional/containers.nix" # podman and docker controls
      "hosts/common/optional/laptop.nix" # laptop controls
      #"hosts/common/optional/libvirt.nix" # libvirt controls
      #"hosts/common/optional/neovim.nix" # neovim controls
      "hosts/common/optional/networking.nix" # networking controls
      "hosts/common/optional/printing.nix" # printing controls
      "hosts/common/optional/river.nix" # river controls
      "hosts/common/optional/thunar.nix" # thunar controls
      "hosts/common/optional/vpn.nix" # vpn controls
      "hosts/common/optional/work-wifi.nix" # work wifi controls
      "hosts/common/optional/fonts.nix" # font controls
      "hosts/common/optional/solaar.nix" # solaar controls

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
