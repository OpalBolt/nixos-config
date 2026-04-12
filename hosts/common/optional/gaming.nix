{ pkgs, ... }:
{
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };
  programs.gamemode.enable = true;

  # 32-bit graphics support required for Steam/Proton
  hardware.graphics.enable32Bit = true;

  environment.systemPackages = with pkgs; [
    mangohud # In-game performance overlay
    protonup # Manage Proton-GE versions
  ];

  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
  };

  # Favour performance on a dedicated gaming rig
  powerManagement.cpuFreqGovernor = "performance";
}
