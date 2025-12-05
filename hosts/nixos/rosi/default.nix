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

    inputs.hardware.nixosModules.framework-amd-ai-300-series
    inputs.hardware.nixosModules.common-pc-laptop-ssd
    inputs.hardware.nixosModules.common-gpu-amd
    inputs.hardware.nixosModules.common-cpu-amd

    (map lib.custom.relativeToRoot [

      ## Required Configs ##
      "hosts/common/core"
      "hosts/common/optional/audio.nix" # pipewire and cli controls
      "hosts/common/optional/bluetooth.nix" # bluetooth controls
      "hosts/common/optional/containers.nix" # podman and docker controls
      "hosts/common/optional/laptop.nix" # laptop controls
      "hosts/common/optional/libvirt.nix" # libvirt controls
      #"hosts/common/optional/neovim.nix" # neovim controls
      "hosts/common/optional/qmk.nix"
      "hosts/common/optional/networking.nix" # networking controls
      "hosts/common/optional/printing.nix" # printing controls
      "hosts/common/optional/river.nix" # river controls
      "hosts/common/optional/thunar.nix" # thunar controls
      "hosts/common/optional/vpn.nix" # vpn controls
      #"hosts/common/optional/work-backup.nix" # work backup
      "hosts/common/optional/work-wifi.nix" # work wifi controls
      "hosts/common/optional/work-vpn.nix" # VPN file for Work
      "hosts/common/optional/fonts.nix" # font controls
      "hosts/common/optional/solaar.nix" # solaar controls
      "hosts/common/optional/chromiumPolicies.nix" # policies for chromium like browsers

      "hosts/specialization/ai.nix"

      ## Required Configs ##
      #"hosts/global/core"

      ## Optional Configs ##
      # "hosts/global/common/audio.nix" # pipewire and cli controls
    ])
  ];

  # Use hostSpec.hostname to set the system hostname
  networking.hostName = config.hostSpec.hostname;
  networking.hosts = {
    "192.168.60.10" = [ "test.plikki.com" ];
  };
  # Tmp enable ssh
  #services.openssh.enable = true;

  # Firmware update manager
  services.fwupd.enable = true;

  # Enable of Thunderbolt communication
  services.hardware.bolt.enable = true;

  # Run unpatched dynamic binaries on NixOS
  programs.nix-ld.enable = true;
  system.stateVersion = "25.05"; # No touchy touchy
}
