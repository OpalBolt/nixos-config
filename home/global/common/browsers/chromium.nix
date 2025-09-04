{
  pkgs,
  lib,
  ...
}:

{
  programs.chromium = {
    enable = true;
    package = pkgs.ungoogled-chromium.override {
      #package = pkgs.chromium.override {
      enableWideVine = true;
      commandLineArgs = [
        "--enable-features=AcceleratedVideoEncoder,Vulkan,VulkanFromANGLE,DefaultANGLEVulkan"
        "--ignore-gpu-blocklist"
        "--force-dark-mode"
        "--enable-zero-copy"
      ];
    };
    extensions =
      let
        createChromiumExtensionFor =
          browserVersion:
          {
            id,
            sha256,
            version,
          }:
          {
            inherit id;
            crxPath = builtins.fetchurl {
              url = "https://clients2.google.com/service/update2/crx?response=redirect&acceptformat=crx2,crx3&prodversion=${browserVersion}&x=id%3D${id}%26installsource%3Dondemand%26uc";
              name = "${id}.crx";
              inherit sha256;
            };
            inherit version;
          };
        createChromiumExtension = createChromiumExtensionFor (
          lib.versions.major pkgs.ungoogled-chromium.version
        );
      in
      [
        (createChromiumExtension {
          # ublock origin
          id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";
          #sha256 = "sha256:0ycnkna72n969crgxfy2lc1qbndjqrj46b9gr5l9b7pgfxi5q0ll";
          sha256 = "sha256:168vr0p31sp5ffsqnrnarw6ab1m95yil4hph0xs6gjbfky7wygki";
          version = "1.65.0";
        })
        (createChromiumExtension {
          # bitwarden
          id = "nngceckbapebfimnlniiiahkandclblb";
          #sha256 = "sha256:0jxk3cqmgd5qj8hnw7s0k5s4bfrcmr0w0rckp3x0bmng07azw4gi";
          sha256 = "sha256:1y250l9z7cvs8fq7frm6jgxnbxry4bxmm2xzk5wri68zjabvw7j3";
          version = "2025.8.2";
        })
      ];
  };
}
