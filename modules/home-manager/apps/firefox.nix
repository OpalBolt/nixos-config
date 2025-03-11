# this configuration has been stolen directly from:
# https://github.com/scientiac/scifox
# Archive: https://archivebox.local.skumnet.dk/archive/1736885954.677672/index.html
#
# Implementation in nix from: https://gitlab.com/scientiac/einstein.nixos/-/blob/main/home/graphical/firefox/userContent.css?ref_type=heads
# archive: https://archivebox.local.skumnet.dk/archive/1737319363.746278/index.html

{
  pkgs,
  inputs,
  vars,
  ...
}:
{
  programs.firefox = {
    enable = true;
    package = pkgs.wrapFirefox pkgs.firefox-esr-unwrapped {
      extraPolicies = {
        CaptivePortal = false;
        DisableFirefoxStudies = true;
        DisablePocket = true;
        DisableTelemetry = true;
        DisableFirefoxAccounts = false;
        NoDefaultBookmarks = true;
        OfferToSaveLogins = false;
        OfferToSaveLoginsDefault = false;
        PasswordManagerEnabled = false;
        FirefoxHome = {
          Search = true;
          Pocket = false;
          Snippets = false;
          TopSites = false;
          Highlights = false;
        };
        UserMessaging = {
          ExtensionRecommendations = false;
          SkipOnboarding = true;
        };
      };
    };

    profiles = {
      default = {
        id = 0;
        name = vars.username;
        isDefault = true;

        extensions = with inputs.nur.legacyPackages."${vars.system}".repos.rycee.firefox-addons; [
          ublock-origin
          display-_anchors
          reddit-enhancement-suite
          #save-webp-as-png-or-jpeg
          vimium
          sidebery
          i-dont-care-about-cookies
          adaptive-tab-bar-colour
          keepassxc-browser
          old-reddit-redirect
        ];
        # extensions = with nur.repos.rycee.firefox-addons; [
        #   "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi"
        #   "https://addons.mozilla.org/firefox/downloads/latest/sidebery/latest.xpi"
        #   "https://addons.mozilla.org/firefox/downloads/latest/istilldontcareaboutcookies/latest.xpi"
        #   "https://addons.mozilla.org/firefox/downloads/latest/display-_anchors/latest.xpi"
        #   "https://addons.mozilla.org/firefox/downloads/latest/reddit-enhancement-suite/latest.xpi"
        #   "https://addons.mozilla.org/firefox/downloads/latest/save-webp-as-png-or-jpeg/latest.xpi"
        #   "https://addons.mozilla.org/firefox/downloads/latest/keepassxc-browser/latest.xpi"
        #   "https://addons.mozilla.org/firefox/downloads/latest/vimium/latest.xpi"
        #   "https://addons.mozilla.org/firefox/downloads/latest/adaptive-tab-bar-colour/latest.xpi"
        # ];

        # http://kb.mozillazine.org/Category:Preferences
        settings = {
          "browser.search.defaultenginename" = "duckduckgo";
          "browser.shell.checkDefaultBrowser" = false;
          "browser.shell.defaultBrowserCheckCount" = 1;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
          "browser.newtabpage.activity-stream.improvesearch.handoffToAwesomebar" = false;
          "widget.use-xdg-desktop-portal.file-picker" = 1;
          "widget.use-xdg-desktop-portal.mime-handler" = 1;
          "browser.search.suggest.enabled" = false;
          "browser.search.suggest.enabled.private" = false;
          "browser.urlbar.suggest.searches" = false;
          "browser.urlbar.showSearchSuggestionsFirst" = false;
          "browser.sessionstore.enabled" = true;
          "browser.sessionstore.resume_from_crash" = true;
          "browser.sessionstore.resume_session_once" = true;
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "browser.tabs.drawInTitlebar" = true;
          "svg.context-properties.content.enabled" = true;
          "general.smoothScroll" = true;
          "uc.tweak.hide-tabs-bar" = true;
          "uc.tweak.hide-forward-button" = false;
          "uc.tweak.rounded-corners" = true;
          "uc.tweak.floating-tabs" = true;
          "layout.css.color-mix.enabled" = true;
          "layout.css.light-dark.enabled" = true;
          "layout.css.has-selector.enabled" = true;
          "media.ffmpeg.vaapi.enabled" = true;
          "media.rdd-vpx.enabled" = true;
          "browser.tabs.tabmanager.enabled" = false;
          "full-screen-api.ignore-widgets" = false;
          "browser.urlbar.suggest.engines" = false;
          "browser.urlbar.suggest.openpage" = false;
          "browser.urlbar.suggest.bookmark" = false;
          "browser.urlbar.suggest.addons" = false;
          "browser.urlbar.suggest.pocket" = false;
          "browser.urlbar.suggest.topsites" = false;
          "extensions.autoDisableScopes" = 0;
          "browser.newtabpage.pinned" = [
            {
              title = "youtube";
              url = "https://www.youtube.com/";
            }
            {
              title = "messenger";
              url = "https://www.messenger.com/";
            }
            {
              title = "search.nixos";
              url = "https://search.nixos.org/";
            }
            {
              title = "fosstodon";
              url = "https://fosstodon.org/";
            }
            {
              title = "github";
              url = "https://www.github.com/";
            }
            {
              title = "chatgpt";
              url = "https://chatgpt.com/";
            }
          ];
        };

        userChrome = (builtins.readFile ./../../../dotfiles/firefox/userChrome.css);
        userContent = (builtins.readFile ./../../../dotfiles/firefox/userContent.css);

      };

    };

  };
}
