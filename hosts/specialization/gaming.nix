{
  pkgs,
  ...
}:
{
  specialisation.gaming = {
    inheritParentConfig = true;
    configuration = {
      # System-level gaming configuration
      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };
      services.xserver.videoDrivers = [ "amdgpu" ];

      programs.steam.enable = true;
      programs.steam.gamescopeSession.enable = true;
      programs.gamemode.enable = true;
      environment.systemPackages = with pkgs; [
        mangohud
        protonup
        nvtopPackages.amd
      ];
      environment.sessionVariables = {
        STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
      };
      powerManagement.cpuFreqGovernor = "performance";

    };
  };
}
