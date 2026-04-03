{ ... }:
{
  # Declare hosts. Each host auto-generates a den.aspects.<name> host aspect.
  # Add more hosts here as needed (desktops and servers follow the same pattern).
  den.hosts.x86_64-linux.rosi = {
    # Schema-typed options (see schema.nix)
    timezone = "Europe/Copenhagen";
    locale = "en_DK.UTF-8";
    extraLocale = "da_DK.UTF-8";
    kbdLayout = "dk";
    consoleKbdKeymap = "dk-latin1";
    isWork = true;
    primaryUser = "mads";
    flakePath = "/home/mads/git/Nix/nixos-config";

    # Users on this host
    users.mads = { };
  };
}
