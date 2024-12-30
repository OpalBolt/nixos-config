{config, vars, ...}:

{
  networking.hostname = vars.hostname;
  networking.networkmanager.enable = true;
}
