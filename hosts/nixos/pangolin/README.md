STDIN
# Pangolin - DMZ Reverse Proxy

Dedicated reverse proxy server running Pangolin (Traefik-based) in DMZ VLAN 30.

## Network Configuration

- **IP**: 192.168.106.10/24 (DMZ VLAN 30)
- **Gateway**: 192.168.106.1
- **Firewall**: SSH from LAN only, HTTP/HTTPS from internet

## Quick Setup

1. **Edit configuration**:
   - `config/vars.nix` - Update user details if needed
   - `config/pangolin.nix` - **Edit domains and backend IPs!**
   - `config/network.nix` - Adjust interface name if not `ens18`

2. **Create SOPS secrets** (in nix-secrets repo):
   ```yaml
   # secrets/pangolin.yaml
   hashedPassword: <your-hashed-password>
   rootHashedPassword: <your-root-hashed-password>
   ```

3. **Deploy**:
   ```bash
   nixos-rebuild switch --flake .#pangolin --target-host 192.168.106.10
   ```

4. **Create DNS provider credentials**:
   ```bash
   ssh mads@192.168.106.10
   sudo mkdir -p /var/lib/pangolin
   sudo nano /var/lib/pangolin/environment
   # Add: CF_API_EMAIL=... and CF_API_KEY=...
   sudo systemctl restart pangolin
   ```

## Services Proxied

Edit `config/pangolin.nix` to customize:
- Nextcloud: cloud.yourdomain.com → 192.168.105.10:443
- Immich: photos.yourdomain.com → 192.168.105.11:2283
- Jellyfin: media.yourdomain.com → 192.168.105.12:8096

## Security Features

- Fail2ban enabled (via `hosts/common/optional/hardening.nix`)
- Kernel hardening (sysctl parameters)
- AppArmor mandatory access control
- SSH restricted to LAN (192.168.104.0/24)
- Automatic security updates
