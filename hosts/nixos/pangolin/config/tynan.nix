# Tynan reverse proxy configuration
# Tynan uses Pangolin (Traefik) under the hood for reverse proxying
{
  config,
  lib,
  pkgs,
  ...
}:

{
  # TODO: Customize these values for your setup
  # Edit the domains and backend IPs to match your services

  services.pangolin = {
    enable = true;

    # Your base domain (edit this!)
    baseDomain = "yourdomain.com";
    dashboardDomain = "traefik.yourdomain.com";

    # ACME/Let's Encrypt email (edit this!)
    letsEncryptEmail = "admin@yourdomain.com";

    # DNS provider for DNS-01 challenge (edit this if not using Cloudflare!)
    # Supported: cloudflare, route53, digitalocean, etc.
    dnsProvider = "cloudflare";

    # Open firewall ports
    openFirewall = true;

    # Environment file for DNS provider credentials
    # Create /var/lib/pangolin/environment with provider-specific variables:
    #   For Cloudflare: CF_API_EMAIL=... CF_API_KEY=...
    #   For Route53: AWS_ACCESS_KEY_ID=... AWS_SECRET_ACCESS_KEY=...
    environmentFile = "/var/lib/pangolin/environment";
  };

  # Backend routing configuration
  # Edit this to add/remove services you want to proxy
  services.pangolin.settings = {
    # Entry points
    entryPoints = {
      web = {
        address = ":80";
        http.redirections.entryPoint = {
          to = "websecure";
          scheme = "https";
        };
      };
      websecure.address = ":443";
    };

    # Certificate resolver
    certificatesResolvers.letsencrypt.acme = {
      email = "admin@yourdomain.com"; # Edit this!
      storage = "/var/lib/pangolin/acme.json";
      dnsChallenge = {
        provider = "cloudflare"; # Edit this if using different DNS provider
        delayBeforeCheck = 0;
      };
    };

    # HTTP routers and services
    http = {
      routers = {
        # Nextcloud
        nextcloud = {
          rule = "Host(`cloud.yourdomain.com`)"; # Edit domain!
          service = "nextcloud";
          entryPoints = [ "websecure" ];
          tls.certResolver = "letsencrypt";
        };

        # Immich
        immich = {
          rule = "Host(`photos.yourdomain.com`)"; # Edit domain!
          service = "immich";
          entryPoints = [ "websecure" ];
          tls.certResolver = "letsencrypt";
        };

        # Jellyfin
        jellyfin = {
          rule = "Host(`media.yourdomain.com`)"; # Edit domain!
          service = "jellyfin";
          entryPoints = [ "websecure" ];
          tls.certResolver = "letsencrypt";
        };
      };

      services = {
        # Nextcloud backend
        nextcloud.loadBalancer.servers = [
          { url = "https://192.168.105.10:443"; } # Edit IP if needed!
        ];

        # Immich backend
        immich.loadBalancer.servers = [
          { url = "http://192.168.105.11:2283"; } # Edit IP if needed!
        ];

        # Jellyfin backend
        jellyfin.loadBalancer.servers = [
          { url = "http://192.168.105.12:8096"; } # Edit IP if needed!
        ];
      };
    };
  };
}
