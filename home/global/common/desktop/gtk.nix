{ pkgs, ... }:
{
  gtk = {
    enable = true;
    gtk3 = {
      extraConfig = {
        gtk-application-prefer-dark-theme = true;
      };
    };
    gtk4 = {
      extraConfig = {
        gtk-application-prefer-dark-theme = true;
      };
    };
    iconTheme = {
      name = "tela-circle-icon-theme";
      package = pkgs.tela-circle-icon-theme;
    };
    theme = {
      name = "Arc-Dark";
      package = pkgs.arc-theme;
    };
  };

  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };
  };
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    name = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;
    size = 16;
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk";
  };
}
