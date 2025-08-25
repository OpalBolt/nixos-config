{
  pkgs,
  ...
}:
{
  programs = {
    tealdeer.enable = true;
    tealdeer.settings.updates.auto_update = true;
  };
}
