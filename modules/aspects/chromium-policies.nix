{ ... }:
{
  den.aspects.chromium-policies.nixos = { lib, ... }: {
    config =
      let
        defaultPolicies = {
          "10-security.json" = {
            PasswordManagerEnabled = false;
            HomepageLocation = "https://search.local.skumnet.dk";
            NewTabPageLocation = "https://search.local.skumnet.dk";
            ImportHomepage = false;
            ShowHomeButton = false;
            HomepageIsNewTabPage = true;
            DefaultGeolocationSetting = 2;
            NetworkPredictionOptions = 2;
            DnsOverHttpsMode = "off";
            GenAiDefaultSettings = 2;
            DefaultSearchProviderEnabled = true;
            DefaultSearchProviderName = "Searxng";
            DefaultSearchProviderKeyword = "lsea";
            DefaultSearchProviderSearchURL = "https://search.local.skumnet.dk/search?q={searchTerms}";
            BrowserSignin = 0;
            BlockThirdPartyCookies = true;
            MetricsReportingEnabled = false;
            ShowFullUrlsInAddressBar = true;
          };
        };
        bravePolicies = defaultPolicies // {
          "20-brave.json" = {
            TorDisabled = true;
            BraveRewardsDisabled = true;
            BraveWalletDisabled = true;
            BraveVPNDisabled = true;
            BraveAIChatEnabled = false;
            BraveNewsDisabled = true;
            BraveTalkDisabled = false;
            BraveSpeedreaderEnabled = false;
            BraveP3AEnabled = false;
            BraveStatsPingEnabled = false;
            BraveWebDiscoveryEnabled = false;
            BravePlaylistEnabled = false;
          };
        };
        chromiumPolicies = defaultPolicies // {
          "20-chromium.json" = {
            HomepageLocation = "https://duckduckgo.com";
          };
        };
        mkEtcFor =
          browser: policies:
          lib.foldl' (
            acc: name:
            acc
            // {
              "${browser}/policies/managed/${name}" = {
                text = builtins.toJSON (policies.${name});
              };
            }
          ) { } (lib.attrNames policies);
      in
      {
        environment.etc = mkEtcFor "brave" bravePolicies // mkEtcFor "chromium" chromiumPolicies;
      };
  };
}
