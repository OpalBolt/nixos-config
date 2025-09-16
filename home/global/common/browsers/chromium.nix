{
  pkgs,
  lib,
  ...
}:

let
  features = [
    "VaapiVideoDecodeLinuxGL"
    "VaapiVideoEncoder"
    "Vulkan"
    "VulkanFromANGLE"
    "DefaultANGLEVulkan"
    "VaapiIgnoreDriverChecks"
    "VaapiVideoDecoder"
    "PlatformHEVCDecoderSupport"
    "UseMultiPlaneFormatForHardwareVideo"
  ];

  chromiumArgs = [
    "--password-store=detect"
    ("--enable-features=" + (lib.concatStringsSep "," features))
  ];
in
{
  programs.chromium = {
    enable = true;
    #package = pkgs.brave.override {
    package = pkgs.vivaldi.override {
      commandLineArgs = lib.concatStringsSep " " chromiumArgs;
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
        createChromiumExtension = createChromiumExtensionFor (lib.versions.major pkgs.chromium.version);
      in
      [
        (createChromiumExtension {
          # ublock origin
          id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";
          sha256 = "sha256:HFD1A9b9958FbtjJGjWl5FnsttsNZBTsdVyaE5N151A=";
          version = "1.66.0.0";
        })
        (createChromiumExtension {
          # Bitwarden
          id = "nngceckbapebfimnlniiiahkandclblb";
          sha256 = "sha256:Qx6+l5IfmZh5mb+LWvsiPvdl+5OmZnewQ3qz8xMFRfg=";
          version = "2025.8.2.0";
        })
        (createChromiumExtension {
          # Old reddit redirect
          id = "dneaehbmnbhcippjikoajpoabadpodje";
          sha256 = "sha256:26kMNZktrRomwltsAlQMEwiZ/MNv6Fw8GHoJ6GebsRE=";
          version = "2.0.9.0";
        })
        (createChromiumExtension {
          # Vimium
          id = "dbepggeogbaibhgnhhndojpepiihcmeb";
          sha256 = "sha256:3UUyo8UVd8s4OrFlwMTnF8UjMKpi31l6JG+EKycBzHw=";
          version = "2.3.0.0";
        })
        (createChromiumExtension {
          # Display Achnors
          id = "poahndpaaanbpbeafbkploiobpiiieko";
          sha256 = "sha256:Pbwu1OjYOg8+AJEVFllIhpKRZgmIuscRP7msAVf7zNg=";
          version = "1.5.0.0";
        })
        (createChromiumExtension {
          # I still dont care about cookies
          id = "edibdbjcniadpccecjdfdjjppcpchdlm";
          sha256 = "sha256:Ur/tOwmZNfU13ytsc4Pzgr7F3aJxEdpV/Eg7JVlnZ4Y=";
          version = "1.1.4.0";
        })
        (createChromiumExtension {
          # RSS finder
          id = "kfghpdldaipanmkhfpdcjglncmilendn";
          sha256 = "sha256:4QeGDV5zsdZpbb9B34+vkQr3yWiC0hsEbZNDyOa8IDE=";
          version = "3.1.1.0";
        })
        (createChromiumExtension {
          # RES
          id = "kbmfpngjjgdllneeigpgjifpgocmfgmb";
          sha256 = "sha256:wM2vceDp5M96hD7aPYEY0c9x1f/fK8Bz1UVokRTJyxg=";
          version = "5.24.8.0";
        })
      ];
  };
}
