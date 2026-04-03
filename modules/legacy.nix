# Phase 1 — Legacy module loading.
# Each host aspect loads its existing default.nix directly.
# The legacy modules continue to use lib.custom.* and hostSpec as before.
# This file is TRANSIENT: it will be replaced as aspects are extracted in later phases.
{ ... }:
{
  den.aspects.ceris.nixos.imports = [ ../hosts/nixos/ceris/default.nix ];
  den.aspects.rosi.nixos.imports = [ ../hosts/nixos/rosi/default.nix ];
  den.aspects.scopuli.nixos.imports = [ ../hosts/nixos/scopuli/default.nix ];
  den.aspects.pangolin.nixos.imports = [ ../hosts/nixos/pangolin/default.nix ];
  den.aspects."test-k3s".nixos.imports = [ ../hosts/nixos/test-k3s/default.nix ];
}
