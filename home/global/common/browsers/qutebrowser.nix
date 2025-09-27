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
  };
}
