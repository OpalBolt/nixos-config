# Declare all hosts and their users.
# classes = [] means den does not manage home-manager for these users yet (Phase 1).
# HM is still set up by the legacy home-manager.nix NixOS module.
# Later phases will migrate classes to [ "homeManager" ] as HM is ported to den aspects.
{
  # Laptop: ThinkPad T14s — work laptop, has HM (via legacy)
  den.hosts.x86_64-linux.ceris.users.mads = { classes = [ ]; };

  # Laptop: Framework AMD AI 300 — work + personal, has HM (via legacy)
  den.hosts.x86_64-linux.rosi.users.mads = { classes = [ ]; };

  # Laptop: Framework AMD AI 300 — personal, no HM currently
  den.hosts.x86_64-linux.scopuli.users.mads = { classes = [ ]; };
  den.hosts.x86_64-linux.scopuli.users.nadia = { classes = [ ]; };

  # Server: Physical reverse proxy in DMZ — no HM, minimal
  den.hosts.x86_64-linux.pangolin = { };

  # VM: K3s test environment
  den.hosts.x86_64-linux."test-k3s" = { };
}
