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

    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-pc-ssd
    inputs.hardware.nixosModules.common-gpu-nvidia-nonprime

    (map lib.custom.relativeToRoot [

      ## Required Configs ##
      "hosts/common/core"
      "hosts/common/optional/home-manager.nix"
      "hosts/common/optional/audio.nix" # pipewire and cli controls
      "hosts/common/optional/bluetooth.nix" # bluetooth controls
      "hosts/common/optional/networking.nix" # networking controls
      "hosts/common/optional/river.nix" # river wayland compositor
      "hosts/common/optional/thunar.nix" # file manager
      "hosts/common/optional/fonts.nix" # font controls
      "hosts/common/optional/qmk.nix" # qmk keyboard firmware flashing
      "hosts/common/optional/solaar.nix" # logitech peripheral management
      "hosts/common/optional/chromiumPolicies.nix" # policies for chromium-based browsers
    ])
  ];

  networking.hostName = config.hostSpec.hostname;

  # Nvidia proprietary drivers - required for older Kepler/Maxwell/Pascal/Turing GPUs
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true; # Required for Wayland
    powerManagement.enable = false; # Desktop - no suspend/resume needed
    open = false; # Older cards require proprietary kernel module
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # 32-bit graphics support (required for Steam/Proton)
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Steam and gaming tools
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };
  programs.gamemode.enable = true;

  environment.systemPackages = with pkgs; [
    mangohud # In-game performance overlay
    protonup # Manage Proton-GE versions
    nvtopPackages.nvidia # GPU monitoring
    lm_sensors # CPU/motherboard temperature monitoring
  ];

  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
  };

  # Favour performance on a dedicated gaming rig
  powerManagement.cpuFreqGovernor = "performance";

  # Firmware updates
  services.fwupd.enable = true;

  # Run unpatched dynamic binaries on NixOS
  programs.nix-ld.enable = true;

  system.stateVersion = "25.05"; # No touchy touchy
}
