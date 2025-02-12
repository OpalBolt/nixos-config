{ pkgs, ... }:
{
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/about" = "firefox.desktop";
      "x-scheme-handler/unknown" = "firefox.desktop";
    };
  };
  xdg.desktopEntries.firefox = {
    name = "firefox";
    exec = "${pkgs.firefox}/bin/firefox %U";
    type = "Application";
  };
  # xdg.desktopEntries.chromium = {
  #   name = "chromium";
  #   exec = "${pkgs.ungoogled-chromium}/bin/chromium %U";
  #   type = "Application";
  # };
}
