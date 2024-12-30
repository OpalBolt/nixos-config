{config, vars, ...}:

{
  networking.hostName = vars.hostname;
  networking.networkmanager.enable = true;
}
