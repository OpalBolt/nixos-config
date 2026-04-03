# Declare all hosts and their users.
# classes = [] means den does not manage home-manager for these users yet (Phase 1).
# HM is still set up by the legacy home-manager.nix NixOS module.
# Later phases will migrate classes to [ "homeManager" ] as HM is ported to den aspects.
#
# Host flags (isWork, isServer, etc.) correspond to den.schema.host options defined
# in modules/schema.nix. These will be read by den aspects in Phase 3+.
{
  # Laptop: ThinkPad T14s — work laptop, has HM (via legacy)
  den.hosts.x86_64-linux.ceris = {
    users.mads = { classes = [ ]; };
    isWork = true;
    useWindowManager = true; # River WM
  };

  # Laptop: Framework AMD AI 300 — work + personal, has HM (via legacy)
  den.hosts.x86_64-linux.rosi = {
    users.mads = { classes = [ ]; };
    isWork = true;
    useWindowManager = true; # River WM + ai specialization
  };

  # Laptop: Framework AMD AI 300 — personal, no HM currently
  den.hosts.x86_64-linux.scopuli = {
    users.mads = { classes = [ ]; };
    users.nadia = { classes = [ ]; };
    isWork = false;
    useWindowManager = true; # GNOME
  };

  # Server: Physical reverse proxy in DMZ — no HM, minimal
  den.hosts.x86_64-linux.pangolin = {
    isServer = true;
    isMinimal = true;
    useWindowManager = false;
    primaryUser = "mads";
  };

  # VM: K3s test environment
  den.hosts.x86_64-linux."test-k3s" = {
    isMinimal = true;
    useWindowManager = false;
    primaryUser = "opalbolt";
  };
}
