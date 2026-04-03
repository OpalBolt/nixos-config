{ ... }:
{
  den.aspects.xdg.homeManager = { pkgs, config, ... }:
    let
      browser = [ "firefox.desktop" ];
      editor = [ "nvim.desktop" ];
      media = [ "vlc.desktop" ];
      writer = [ "libreoffice-writer.desktop" ];
      spreadsheet = [ "libreoffice-calc.desktop" ];
      slidedeck = [ "libreoffice-impress.desktop" ];
      associations = {
        "text/*" = editor;
        "text/plain" = editor;
        "text/html" = browser;
        "application/x-zerosize" = editor;
        "application/x-shellscript" = editor;
        "application/x-perl" = editor;
        "application/json" = editor;
        "application/x-extension-htm" = browser;
        "application/x-extension-html" = browser;
        "application/xhtml+xml" = browser;
        "application/pdf" = browser;
        "application/mxf" = media;
        "application/sdp" = media;
        "x-scheme-handler/http" = browser;
        "x-scheme-handler/https" = browser;
        "audio/*" = media;
        "video/*" = media;
        "image/*" = browser;
        "x-scheme-handler/sgnl" = "signal-desktop.desktop";
        "application/vnd.jgraph.mxfile" = [ "drawio.desktop" ];
        "text/csv" = spreadsheet;
        "application/vnd.ms-excel" = spreadsheet;
        "application/vnd.ms-powerpoint" = slidedeck;
        "application/vnd.ms-word" = writer;
        "application/vnd.oasis.opendocument.presentation" = slidedeck;
        "application/vnd.oasis.opendocument.spreadsheet" = spreadsheet;
        "application/vnd.oasis.opendocument.text" = writer;
        "application/vnd.openxmlformats-officedocument.presentationml.presentation" = slidedeck;
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" = spreadsheet;
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = writer;
      };
    in
    {
      xdg.mime.enable = true;
      xdg.mimeApps.enable = true;
      xdg.mimeApps.defaultApplications = associations;
      xdg.mimeApps.associations.removed = {
        "application/vnd.oasis.opendocument.text" = [
          "calibre-ebook-viewer.desktop"
          "calibre-ebook-edit.desktop"
          "calibre-gui.desktop"
        ];
      };
      xdg.mimeApps.associations.added = associations;

      xdg.desktopEntries.firefox = {
        name = "firefox";
        exec = "${pkgs.firefox}/bin/firefox %U";
        type = "Application";
      };

      xdg = {
        enable = true;
        userDirs = {
          enable = true;
          createDirectories = true;
          desktop = "${config.home.homeDirectory}/.desktop";
          documents = "${config.home.homeDirectory}/doc";
          download = "${config.home.homeDirectory}/downloads";
          music = "${config.home.homeDirectory}/media/audio";
          pictures = "${config.home.homeDirectory}/media/images";
          videos = "${config.home.homeDirectory}/media/video";
          extraConfig = {
            XDG_PUBLICSHARE_DIR = "/var/empty";
            XDG_TEMPLATES_DIR = "/var/empty";
          };
        };
      };

      home.packages = [ pkgs.handlr-regex ];
    };
}
