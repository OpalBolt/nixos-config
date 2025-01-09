# Config borrowed from: [link](https://gitlab.com/tien-vo/system-config/-/tree/nix/modules/user/app/web-browser/firefox?ref_type=heads)

{ pkgs, settings, ... }:
{
  config.programs.firefox = {
    enable = true;
    package = pkgs.firefox-esr;
    profiles.custom-profile = {
      name = "Custom profile";
      isDefault = true;
      userChrome = ''
        #TabsToolbar
        {
            visibility: collapse;
        }
        #sidebar-header
        {
            display: none;
        }
      '';

      extraConfig = ''
        user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
        user_pref("extensions.activeThemeID", "{f9be3857-6894-4d6e-90e0-64451bdf7655}");

        user_pref("browser.toolbars.bookmarks.visibility", "never");
        user_pref("browser.startup.homepage", "https://startpage.com");
        user_pref("browser.startup.page", 3);
        user_pref("browser.search.separatePrivateDefault", false);
        user_pref("browser.newtabpage.activity-stream.feeds.section.topstories", false);
        user_pref("browser.newtabpage.activity-stream.feeds.topsites", false);

        user_pref("signon.rememberSignons", false);

        user_pref("extensions.formautofill.addresses.enabled", false);
        user_pref("extensions.formautofill.creditCards.enabled", false);

        /** PASSWORDS ***/
        user_pref("signon.formlessCapture.enabled", false);
        user_pref("signon.privateBrowsingCapture.enabled", false);
        user_pref("network.auth.subresource-http-auth-allow", 1);
        user_pref("editor.truncate_user_pastes", false);

        /** Disable pocket **/
        user_pref("extensions.pocket.enabled", false);

        // PREF: disable Firefox Sync
        user_pref("identity.fxaccounts.enabled", false);

        // PREF: disable the Firefox View tour from popping up
        user_pref("browser.firefox-view.feature-tour", "{\"screen\":\"\",\"complete\":true}");

        // PREF: disable login manager
        user_pref("signon.rememberSignons", false);

        // PREF: disable address and credit card manager
        user_pref("extensions.formautofill.addresses.enabled", false);
        user_pref("extensions.formautofill.creditCards.enabled", false);

        // PREF: do not allow embedded tweets, Instagram, Reddit, and Tiktok posts
        user_pref("urlclassifier.trackingSkipURLs", "");
        user_pref("urlclassifier.features.socialtracking.skipURLs", "");

        user_pref("browser.sessionhistory.max_total_viewers", 4); // only remember # of pages in Back-Forward cache
        user_pref("devtools.accessibility.enabled", false); // removes un-needed "Inspect Accessibility Properties" on right-click
        user_pref("browser.newtabpage.activity-stream.showSponsoredTopSites", false); // Settings>Home>Firefox Home Content>Recent Activity>Shortcuts>Sponsored shortcuts
        user_pref("browser.newtabpage.activity-stream.showSponsored", false); // Settings>Home>Firefox Home Content>Recent Activity>Recommended by Pocket>Sponsored Stories
        user_pref("browser.newtabpage.activity-stream.section.highlights.includeBookmarks", false); // Settings>Home>Firefox Home Content>Recent Activity>Bookmarks
        user_pref("browser.newtabpage.activity-stream.section.highlights.includeDownloads", false); // Settings>Home>Firefox Home Content>Recent Activity>Most Recent Download
        user_pref("browser.newtabpage.activity-stream.section.highlights.includeVisited", false); // Settings>Home>Firefox Home Content>Recent Activity>Visited Pages
        user_pref("browser.newtabpage.activity-stream.section.highlights.includePocket", false); // Settings>Home>Firefox Home Content>Recent Activity>Pages Saved to Pocket
        user_pref("browser.startup.homepage_override.mstone", "ignore"); // What's New page after updates; master switch
        //user_pref("browser.urlbar.suggest.history", false); // Browsing history; hide URL bar dropdown suggestions
        user_pref("browser.urlbar.suggest.bookmark", false); // Bookmarks; hide URL bar dropdown suggestions
        user_pref("browser.urlbar.suggest.openpage", false); // Open tabs; hide URL bar dropdown suggestions
        user_pref("browser.urlbar.suggest.topsites", false); // Shortcuts; disable dropdown suggestions with empty query
        user_pref("browser.urlbar.suggest.engines", false); // Search engines; tab-to-search
        user_pref("browser.urlbar.quicksuggest.enabled", false); // hide Firefox Suggest UI in the settings
        user_pref("layout.word_select.eat_space_to_next_word", false); // do not select the space next to a word when selecting a word
        user_pref("browser.tabs.loadBookmarksInTabs", true); // force bookmarks to open in a new tab, not the current tab
        user_pref("ui.key.menuAccessKey", 0); // remove underlined characters from various settings
        //user_pref("general.autoScroll", false); // disable unintentional behavior for middle click
        user_pref("ui.SpellCheckerUnderlineStyle", 1); // dots for spell check errors
        user_pref("media.videocontrols.picture-in-picture.display-text-tracks.size", "small"); // PiP
        user_pref("media.videocontrols.picture-in-picture.urlbar-button.enabled", false); // PiP in address bar
        user_pref("reader.parse-on-load.enabled", false); // disable reader mode

        /** DELETE IF NOT LINUX LAPTOP ***/
        //user_pref("browser.download.folderList", 1); // 0=desktop, 1=downloads, 2=last used
        //user_pref(layers.acceleration.force-enable", true); // needed in 2024?
        //user_pref("gfx.webrender.software.opengl", true); // needed?
        user_pref("browser.low_commit_space_threshold_mb", 13107); // determine when tabs unload
        user_pref("browser.low_commit_space_threshold_percent", 20); // determine when tabs unload (percentage)
        //user_pref("middlemouse.contentLoadURL", false); // disable middle mouse click opening links from clipboard
        user_pref("network.trr.mode", 5); // enable TRR (with System fallback)
        user_pref("geo.provider.use_geoclue", false); // [LINUX]
        user_pref("pdfjs.defaultZoomValue", "page-width"); // PDF zoom level

      '';

    };

    policies = {
      DisableAppUpdate = true;
      DisableSystemAddonUpdate = true;
      DisableProfileImport = true;
      DisableFirefoxStudies = true;
      DisableTelemetry = true;
      DisableFeedbackCommands = true;
      DisablePocket = true;
      DisableDeveloperTools = false;
      FirefoxHome = {
        Search = true;
        TopSites = false;
        SponsoredTopSites = false;
        Highlights = false;
        Pocket = false;
        SponsoredPocket = false;
        Snippets = false;
        Locked = false;
      };
      FirefoxSuggest = {
        WebSuggestions = false;
        SponsoredSuggestions = false;
        ImproveSuggest = false;
      };
      NoDefaultBookmarks = true;
      OverrideFirstRunPage = "";
      WebsiteFilter = {
        Block = [
          "https://localhost/*"
        ];
        Exceptions = [
          "https://localhost/*"
        ];
      };
      Extensions = {
        Install = [
          "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi"
          "https://addons.mozilla.org/firefox/downloads/latest/sidebery/latest.xpi"
          "http://addons.mozilla.org/firefox/downloads/latest/multi-account-containers/latest.xpi"
          "http://addons.mozilla.org/firefox/downloads/latest/istilldontcareaboutcookies/latest.xpi"
          "http://addons.mozilla.org/firefox/downloads/latest/display-_anchors/latest.xpi"
          "http://addons.mozilla.org/firefox/downloads/latest/reddit-enhancement-suite/latest.xpi"
          "http://addons.mozilla.org/firefox/downloads/latest/save-webp-as-png-or-jpeg/latest.xpi"
          "http://addons.mozilla.org/firefox/downloads/latest/keepassxc-browser/latest.xpi"

        ];
        Uninstall = [
          "google@search.mozilla.org"
          "bing@search.mozilla.org"
          "amazondotcom@search.mozilla.org"
          "ebay@search.mozilla.org"
          "wikipedia@search.mozilla.org"
        ];
      };
      ExtensionSettings = {
        "google@search.mozilla.org".installation_mode = "blocked";
        "bing@search.mozilla.org".installation_mode = "blocked";
        "amazondotcom@search.mozilla.org".installation_mode = "blocked";
        "ebay@search.mozilla.org".installation_mode = "blocked";
        "wikipedia@search.mozilla.org".installation_mode = "blocked";
      };
      SearchEngines = {
        PreventInstalls = false;
        Remove = [
          "Google"
          "Bing"
          "Amazon.com"
          "eBay"
          "Wikipedia"
        ];
        Default = "StartPage";
        Add = [
          {
            Name = "StartPage";
            Description = "The world's most private search engine";
            Alias = "";
            Method = "GET";
            URLTemplate = "https://www.startpage.com/sp/search?query={searchTerms}&cat=web&pl=opensearch";
            IconURL = "https://www.startpage.com/favicon.ico";
          }
        ];
      };
    };

  };
  config.home.sessionVariables = {
    BROWSER = "${pkgs.firefox-esr}/bin/firefox-esr";
  };
}
