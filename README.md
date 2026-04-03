# nixos-config — Den Rewrite

NixOS configuration for all personal/work machines, built on the
[Den](https://github.com/vic/den) aspect-oriented framework.

**Branch**: `den-migration` (active development — not yet on `main`)

---

## Structure

```
nixos-config/
  flake.nix                   # flake-parts + den + import-tree
  hardware/
    rosi.nix                  # Framework AMD AI 300 hardware config
  modules/
    den.nix                   # imports inputs.den.flakeModule
    schema.nix                # den.schema.host typed options (timezone, locale, etc.)
    hosts.nix                 # den.hosts declarations
    defaults.nix              # global defaults: stateVersions, overlays, HM extraSpecialArgs
    aspects/
      system/
        boot.nix              # systemd-boot, latest kernel
        nix-settings.nix      # nix config, nh, core packages + HM nix tools
        networking.nix        # NetworkManager, firewall
        localization.nix      # timezone, locale, keyboard (parametric) + HM keyboard
        containers.nix        # podman + docker
      security/
        security.nix          # polkit, keyring + HM gnome-keyring service
        hardening.nix         # kernel hardening, apparmor, fail2ban (servers)
        sops-base.nix         # sops-nix NixOS + HM base config
      hardware/
        bluetooth.nix
        laptop.nix            # power mgmt, hibernate
        libvirt.nix
        printing.nix
        qmk.nix
        solaar.nix            # Logitech wireless
      desktop/
        river-wm.nix          # ly, portals, wayland + HM: river, waybar, swaylock, fuzzel, mako, GTK
        fonts.nix             # system fonts + HM fontconfig
        audio.nix             # pipewire
        thunar.nix
        xdg.nix               # HM: mimetypes, userDirs, handlr-regex
        chromium-policies.nix # Brave + Chromium policies
        firefox.nix           # HM: full Firefox config, NUR extensions, userChrome
      shell/
        zsh.nix               # HM: oh-my-zsh, zplug, aliases
        shell-tools.nix       # HM: bat, eza, fzf, fd, ripgrep, direnv, zoxide, yazi, zellij, starship
        kitty.nix             # HM: kitty terminal, Kanagawa theme
        git.nix               # HM: git identity, delta, lazygit, includeIf work/personal
        neovim.nix            # HM: lazyvim with all extras
        devops.nix            # HM: kubectl, k9s, kubecolor, yamllint, pre-commit
      network/
        vpn.nix               # personal WireGuard
        work-vpn.nix          # work WireGuard (parametric)
        work-wifi.nix         # EAP-TLS wifi (parametric)
        ssh.nix               # openssh, known hosts (parametric)
      work/
        work.nix              # HM: slack, timewarrior, awscli2, lynis audit timer, rclone mount
      users/
        mads.nix              # user account + personal HM config (env, comms, productivity, fabric)
      hosts/
        rosi.nix              # Framework AMD AI 300 — all includes + host-specific NixOS
  dotfiles/                   # Static dotfiles referenced by aspects
```

Each aspect file is self-contained: NixOS config and Home Manager config live together in
one file via `den.aspects.<name>.nixos` and `den.aspects.<name>.homeManager` keys.

---

## Hosts

| Host | Hardware | Status | Notes |
|------|----------|--------|-------|
| rosi | Framework AMD AI 300 | ✅ Evaluates | Work + personal laptop, primary host |

To add a new host, see [Adding a Host](#adding-a-host) below.

---

## Verification

```bash
# Check the flake evaluates (fast)
nix flake show --no-update-lock-file

# Full build (slow — verifies entire closure)
nix build .#nixosConfigurations.rosi.config.system.build.toplevel

# Deploy (run ON the target machine)
nixos-rebuild switch --flake .#rosi
```

---

## Adding a Host

1. **Hardware config**: Add `hardware/<hostname>.nix` (generate with `nixos-generate-config` on the machine)
2. **Host aspect**: Create `modules/aspects/hosts/<hostname>.nix`:
   ```nix
   { den, inputs, ... }:
   {
     den.aspects.<hostname> = {
       includes = [
         den.aspects.boot
         den.aspects.nix-settings
         # ... other feature aspects
         den.aspects.mads           # if mads is a user on this host
         { nixos = inputs.hardware.nixosModules.<hardware-module>; }
       ];
       nixos = { config, lib, pkgs, ... }: {
         imports = [ ../../../hardware/<hostname>.nix ];
         # host-specific config
       };
     };
   }
   ```
3. **Host declaration**: Add to `modules/hosts.nix`:
   ```nix
   den.hosts.x86_64-linux.<hostname> = {
     hostName = "<hostname>";
     users.mads = {};
     # schema options:
     timezone = "Europe/Copenhagen";
     locale = "en_DK.UTF-8";
     isWork = false;
     primaryUser = "mads";
     flakePath = "/home/mads/git/Nix/nixos-config";
   };
   ```
4. Add sops secrets file: `nix-secrets/secrets/<hostname>.yaml` (in the private secrets repo)

---

## Den Framework — Critical Patterns

These are hard-won lessons from this rewrite. Breaking these causes infinite recursion
or evaluation failures.

### `inputs` in NixOS module functions

Den does **not** pass raw `inputs` as `specialArgs` to NixOS modules. Using
`inputs` as a NixOS module function argument causes infinite recursion.

```nix
# ❌ BROKEN — infinite recursion
den.aspects.foo.nixos = { inputs, ... }: {
  imports = [ inputs.sops-nix.nixosModules.sops ];
};

# ✅ CORRECT — capture inputs from the outer flake-parts module closure
{ inputs, ... }:
{
  den.aspects.foo.nixos = { ... }: {
    # inputs is captured from the outer function, not a NixOS module arg
  };
}
```

### Importing external NixOS modules (sops-nix, hardware modules)

Add them in the aspect's `includes` list at flake-parts evaluation time,
not inside a NixOS module `imports` list.

```nix
{ inputs, ... }:
{
  den.aspects.foo = {
    includes = [
      # Evaluated at flake-parts level — inputs available here, no circular dep
      { nixos = inputs.sops-nix.nixosModules.sops; }
      { nixos = inputs.hardware.nixosModules.framework-amd-ai-300-series; }
    ];
    nixos = { ... }: {
      # regular config — inputs via outer closure if needed
    };
  };
}
```

### `inputs` in Home Manager modules

HM modules CAN use `inputs` as a function argument because `defaults.nix` sets:
```nix
den.ctx.hm-host.nixos.home-manager.extraSpecialArgs = { inherit inputs; };
```
This makes `inputs` a proper `extraSpecialArg` (not `_module.args`), so it's
safe to use in HM module `imports`:
```nix
# ✅ Works in home/ modules
{ inputs, config, pkgs, ... }:
{
  imports = [ inputs.sops-nix.homeManagerModules.sops ];
}
```

### Parametric includes

For aspects that need per-host values (e.g., sops file paths, wifi SSID):
```nix
{ inputs, ... }:
{
  den.aspects.work-vpn.includes = [
    ({ host, ... }: {
      # host.name, host.isWork, etc. available here (flake-parts context)
      nixos = { config, ... }: {
        # config available here (NixOS module context)
        # inputs captured from outermost closure
        sops.secrets.my-secret.sopsFile =
          "${toString inputs.nix-secrets.outPath}/secrets/${host.name}-vpn.yaml";
      };
    })
  ];
}
```

### `provides.to-hosts` (user → host contributions)

Enabled by `den._.mutual-provider` in `den.default` includes (set in `defaults.nix`).
Used in `mads.nix` to push sops age key + SSH secrets to every host mads is on:
```nix
den.aspects.mads.provides.to-hosts.nixos = { ... }: {
  sops.age.keyFile = "/home/mads/.config/sops/age/keys.txt";
  # ...
};
```

---

## Schema Options (`den.schema.host`)

Defined in `modules/schema.nix`. Set per-host in `modules/hosts.nix`.

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `timezone` | string | `"Europe/Copenhagen"` | System timezone |
| `locale` | string | `"en_DK.UTF-8"` | Primary locale |
| `extraLocale` | string | `"en_US.UTF-8"` | Secondary locale |
| `kbdLayout` | string | `"us"` | X11 keyboard layout |
| `consoleKbdKeymap` | string | `"us"` | Console keyboard map |
| `isWork` | bool | `false` | Enables work-wifi, work-vpn aspects |
| `primaryUser` | string | `"mads"` | Used by libvirt group membership |
| `flakePath` | string | `"/home/mads/..."` | Path used by `nh` for rebuilds |
