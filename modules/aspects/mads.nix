# mads user aspect — per-host HM configuration via mutual providers.
# Uses den's mutual-provider pattern so each host can supply its specific
# HM config file for mads (home/users/mads/{host}.nix).
#
# Host → user direction: den.aspects.{host}.provides.mads.homeManager
#   gives mads's HM config for that specific host.
{ den, ... }:
{
  # Enable mutual providers so host aspects can provide user HM config
  den.ctx.user.includes = [ den._.mutual-provider ];

  # ceris: work laptop HM config
  den.aspects.ceris.provides.mads.homeManager =
    { lib, ... }:
    {
      imports = [ (lib.custom.relativeToRoot "home/users/mads/ceris.nix") ];
    };

  # rosi: work+personal laptop HM config
  den.aspects.rosi.provides.mads.homeManager =
    { lib, ... }:
    {
      imports = [ (lib.custom.relativeToRoot "home/users/mads/rosi.nix") ];
    };
}
