{ lib, ... }:

let
  # ---------------------
  # Base / shared policy
  # ---------------------
  defaultPolicies = {
    # "10-security.json" — base security / UX policies for all Chromium-based browsers
    "10-security.json" = {
      PasswordManagerEnabled = false; # boolean: disables built-in password manager UI and prompts; users won't be offered to save or autofill passwords from the browser store
      HomepageLocation = "https://search.local.skumnet.dk"; # string: the URL used as the browser's homepage when ShowHomeButton or homepage actions are invoked
      NewTabPageLocation = "https://search.local.skumnet.dk";
      ImportHomepage = false;
      ShowHomeButton = false; # boolean: controls whether the Home button is visible in the toolbar (false hides it)
      HomepageIsNewTabPage = true; # boolean: when true, opening a new tab will load the homepage URL instead of the default new-tab UX
      DefaultGeolocationSetting = 2; # integer enum: default geolocation behaviour for sites (0=ask, 1=block, 2=allow) — set per org policy needs
      NetworkPredictionOptions = 2; # integer enum: controls network prediction / prerender behaviour; affects prefetching and may impact privacy
      DnsOverHttpsMode = "off"; # string enum: controls Secure DNS (DNS over HTTPS) behaviour: "off" | "automatic" | "secure"; disabling may affect privacy
      GenAiDefaultSettings = 2; # integer/enum: default settings for GenAI features (keeps as integer per policy template; consult upstream if you change)
      DefaultSearchProviderEnabled = true; # boolean: enforces a default search provider for all users — ensures consistent search behavior across profiles
      DefaultSearchProviderName = "Searxng"; # string: a human-friendly name for the enforced default search provider — used by the UI to label the provider # !ATTENTION
      DefaultSearchProviderKeyword = "lsea"; # string: the keyword/shortcut for the provider (used in the omnibox as a shortcut) # !ATTENTION
      DefaultSearchProviderSearchURL = "https://search.local.skumnet.dk/search?q={searchTerms}"; # string: the templated search URL (must include {searchTerms}) used for queries from the address bar
      BrowserSignin = 0; # integer enum: controls browser sign-in behavior (0=disable sign-in, 1=enable, 2=force sign-in) — disabling prevents profile sync with Google
      BlockThirdPartyCookies = true; # boolean: prevents 3rd-party cookies (improves privacy; may break some embedded 3rd-party widgets) # !ATTENTION
      MetricsReportingEnabled = false; # boolean: ensure metrics/telemetry is disabled (double-check Brave-specific telemetry settings) # !ATTENTION
      ShowFullUrlsInAddressBar = true;
    };
  };

  # ---------------------
  # Brave-specific policies
  # ---------------------
  bravePolicies = defaultPolicies // {
    # "20-brave.json" — Brave feature toggles and Brave-specific services
    "20-brave.json" = {
      TorDisabled = true; # boolean: fully disables Brave's built-in Tor windows and Tor mode; prevents users from opening Tor sessions
      BraveRewardsDisabled = true; # boolean: disables Brave Rewards and ad/BAT flows so the rewards UI and ad-serving are inactive
      BraveWalletDisabled = true; # boolean: disables Brave's crypto wallet features and UI components associated with them
      BraveVPNDisabled = true; # boolean: disables Brave's integrated VPN offering so users cannot enable or access it
      BraveAIChatEnabled = false; # boolean: disables Brave's built-in AI chat assistant feature and any UI tied to it
      BraveNewsDisabled = true; # boolean: disables Brave News feed/panel and prevents it from appearing in the UI
      BraveTalkDisabled = false; # boolean: disables Brave's Talk/video-chat feature and CTA's related to it
      BraveSpeedreaderEnabled = false; # boolean: disables the Speedreader/reader-mode feature that simplifies article layouts
      BraveP3AEnabled = false; # boolean: disables P3A (privacy-preserving ad analytics) collection and related flows
      BraveStatsPingEnabled = false; # boolean: disables automatic usage / telemetry pings sent to Brave's stats endpoints
      BraveWebDiscoveryEnabled = false; # boolean: disables Web Discovery / discovery-related features that may surface content recommendations
      BravePlaylistEnabled = false; # boolean: disables the Playlist/media queue features exposed by Brave
    };
  };

  # ---------------------
  # Chromium-specific policies
  # ---------------------
  chromiumPolicies = defaultPolicies // {
    "20-chromium.json" = {
      HomepageLocation = "https://duckduckgo.com"; # string: set a different homepage for Chromium specifically
    };
  };

  # ---------------------
  # Helper: produce environment.etc mapping keys that place JSON under
  # "<browser>/policies/managed/<filename>" with proper JSON text
  # ---------------------
  mkEtcFor =
    browser: policies:
    let
      names = lib.attrNames policies;
    in
    lib.foldl' (
      acc: name:
      acc
      // {
        "${browser}/policies/managed/${name}" = {
          text = builtins.toJSON (policies.${name});
        };
      }
    ) { } names;
in
{
  config = {
    environment.etc = mkEtcFor "brave" bravePolicies // mkEtcFor "chromium" chromiumPolicies;
  };
}
