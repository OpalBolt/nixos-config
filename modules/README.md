# modules/ — Den Configuration

This directory contains the den-based NixOS configuration for all hosts.
It is loaded via `import-tree` from `flake.nix`.

## File Structure

```
modules/
  den.nix           — Imports den's flake-parts module
  hosts.nix         — Declares all hosts + users + den.schema flags
  defaults.nix      — Global defaults: lib.custom injection, overlays,
                      solaar/determinate modules, stateVersion defaults
  schema.nix        — den.schema.host options (isWork, isServer, etc.)
  legacy.nix        — Placeholder (empty); kept for future incremental migration
  misc.nix          — formatter, devShells, overlays flake output

  aspects/
    core.nix        — den.aspects.core: wraps hosts/common/core/ + sets hostName
    optional.nix    — One aspect per hosts/common/optional/*.nix module
    hm.nix          — den.aspects.hm-base: home-manager NixOS integration options
    mads.nix        — den.aspects.mads: per-host HM config via mutual providers
    ceris.nix       — den.aspects.ceris: ThinkPad T14s — hardware + includes
    rosi.nix        — den.aspects.rosi: Framework AMD (work) — hardware + includes
    scopuli.nix     — den.aspects.scopuli: Framework AMD (personal) — hardware + includes
    pangolin.nix    — den.aspects.pangolin: server — core + openssh + hardening
    test-k3s.nix    — den.aspects.test-k3s: K3s VM test environment
```

## Aspect Composition

Each host aspect declares:
- `includes = [ ... ]` — which optional aspects to include (audio, bluetooth, etc.)
- `nixos = { ... }` — hardware modules + host-specific NixOS config

The context pipeline automatically creates `nixosConfigurations.<name>` for each
declared host in `den.hosts`.

## Home Manager

HM is enabled per-user via `classes = ["homeManager"]` in `hosts.nix`.
`den.aspects.hm-base` sets the NixOS HM options (useGlobalPkgs, extraSpecialArgs).
Per-host HM config is supplied via mutual providers in `aspects/mads.nix`.

## Adding a New Host

1. Add `den.hosts.x86_64-linux.<name> = { users.mads = { classes = ["homeManager"]; }; ... };` to `hosts.nix`
2. Create `modules/aspects/<name>.nix` with hardware + includes
3. Add `den.aspects.<name>.provides.mads.homeManager = { lib, ... }: { imports = [...]; };` to `aspects/mads.nix` if HM is needed
4. Create `hosts/nixos/<name>/` with `hardware-configuration.nix` and `config/vars.nix`
