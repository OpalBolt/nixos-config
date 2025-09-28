{
  inputs,
  pkgs,
  ...
}:
{

  home.packages = [
    inputs.qbpm.packages.${pkgs.system}.qbpm
  ];
  programs.qutebrowser = {
    enable = true;
    searchEngines = {
      np = "https://search.nixos.org/packages?query={}";
      no = "https://search.nixos.org/options?query={}";
      nh = "https://home-manager-options.extranix.com/?query={}";
      DEFAULT = "https://search.local.skumnet.dk/search?q={}";
      go = "https://www.google.com/search?hl=en&q={}";
    };
    keyBindings = {
      normal = {
        ",p" = "spawn --userscript qute-bitwarden";
        "eb" = ":quickmark-del";
        "eB" = ":bookmark-del";
        "SB" = "bookmark-list --jump -t";
        "Sk" = "spawn --userscript qute-bitwarden";
      };
    };
    settings = {
      tabs.show = "multiple";
      tabs.position = "left";
      tabs.pinned.frozen = false;
      tabs.title.format = "[{aligned_index}] {audio}{current_title}";
      tabs.title.format_pinned = "[{aligned_index}] 📌{audio}{current_title}";
      tabs.mode_on_change = "restore";
      auto_save.session = true;
      colors.webpage.darkmode.enabled = true;
      colors.webpage.darkmode.algorithm = "lightness-cielab";
      colors.webpage.darkmode.policy.images = "never";
      tabs.width = "7%";
      content.blocking.enabled = true;
    };
    extraConfig = ''
      # Define color palette
      color0 = "#090618"
      color1 = "#C34043"
      color2 = "#76946A"
      color3 = "#C0A36E"
      color4 = "#7E9CD8"
      color5 = "#957FB8"
      color6 = "#6A9589"
      color7 = "#C8C093"
      color8 = "#727169"
      color9 = "#E82424"
      color10 = "#98BB6C"
      color11 = "#E6C384"
      color12 = "#7FB4CA"
      color13 = "#938AA9"
      color14 = "#7AA89F"
      color15 = "#DCD7BA"
      color16 = "#FFA066"
      color17 = "#FF5D62"

      # Special colors
      foreground = "#DCD7BA"
      background = "#1F1F28"
      cursor = "#C8C093"

      # Statusbar colors
      c.colors.statusbar.normal.bg = background
      c.colors.statusbar.command.bg = background
      c.colors.statusbar.command.fg = foreground
      c.colors.statusbar.normal.fg = color14
      c.colors.statusbar.passthrough.fg = color14
      c.colors.statusbar.url.fg = color13
      c.colors.statusbar.url.success.https.fg = color13
      c.colors.statusbar.url.hover.fg = color12

      # Tab colors
      c.colors.tabs.even.bg = background  # transparent tabs
      c.colors.tabs.odd.bg = background
      c.colors.tabs.bar.bg = background
      c.colors.tabs.even.fg = color13
      c.colors.tabs.odd.fg = color13
      c.colors.tabs.selected.even.bg = foreground
      c.colors.tabs.selected.odd.bg = foreground
      c.colors.tabs.selected.even.fg = background
      c.colors.tabs.selected.odd.fg = background

      # Hints colors
      c.colors.hints.bg = background
      c.colors.hints.fg = foreground

      # Tab settings
      c.tabs.show = "multiple"

      # Completion colors
      c.colors.completion.item.selected.match.fg = color6
      c.colors.completion.match.fg = color6
      c.colors.completion.odd.bg = background
      c.colors.completion.even.bg = background
      c.colors.completion.fg = foreground
      c.colors.completion.category.bg = background
      c.colors.completion.category.fg = foreground
      c.colors.completion.item.selected.bg = background
      c.colors.completion.item.selected.fg = foreground

      # Tab indicator colors
      c.colors.tabs.indicator.start = color10
      c.colors.tabs.indicator.stop = color8

      # Message colors
      c.colors.messages.info.bg = background
      c.colors.messages.info.fg = foreground
      c.colors.messages.error.bg = background
      c.colors.messages.error.fg = foreground

      # Download colors
      c.colors.downloads.error.bg = background
      c.colors.downloads.error.fg = foreground
      c.colors.downloads.bar.bg = background
      c.colors.downloads.start.bg = color10
      c.colors.downloads.start.fg = foreground
      c.colors.downloads.stop.bg = color8
      c.colors.downloads.stop.fg = foreground

      # Tooltip and webpage colors
      c.colors.tooltip.bg = background
      c.colors.webpage.bg = background
      c.hints.border = foreground
    '';
  };
}
