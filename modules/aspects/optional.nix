# Optional NixOS aspects — one per file in hosts/common/optional/.
# Each aspect wraps the legacy module so it can be individually included
# per host via den.aspects.{host}.includes.
{ ... }:
{
  den.aspects.audio.nixos.imports            = [ ../../hosts/common/optional/audio.nix ];
  den.aspects.bluetooth.nixos.imports        = [ ../../hosts/common/optional/bluetooth.nix ];
  den.aspects.containers.nixos.imports       = [ ../../hosts/common/optional/containers.nix ];
  den.aspects.fonts.nixos.imports            = [ ../../hosts/common/optional/fonts.nix ];
  den.aspects.gnome.nixos.imports            = [ ../../hosts/common/optional/gnome.nix ];
  den.aspects.hardening.nixos.imports        = [ ../../hosts/common/optional/hardening.nix ];
  den.aspects.laptop.nixos.imports           = [ ../../hosts/common/optional/laptop.nix ];
  den.aspects.libvirt.nixos.imports          = [ ../../hosts/common/optional/libvirt.nix ];
  den.aspects.networking.nixos.imports       = [ ../../hosts/common/optional/networking.nix ];
  den.aspects.openssh.nixos.imports          = [ ../../hosts/common/optional/openssh.nix ];
  den.aspects.printing.nixos.imports         = [ ../../hosts/common/optional/printing.nix ];
  den.aspects.qmk.nixos.imports              = [ ../../hosts/common/optional/qmk.nix ];
  den.aspects.river.nixos.imports            = [ ../../hosts/common/optional/river.nix ];
  den.aspects.solaar.nixos.imports           = [ ../../hosts/common/optional/solaar.nix ];
  den.aspects.thunar.nixos.imports           = [ ../../hosts/common/optional/thunar.nix ];
  den.aspects.vpn.nixos.imports              = [ ../../hosts/common/optional/vpn.nix ];
  den.aspects.work-vpn.nixos.imports         = [ ../../hosts/common/optional/work-vpn.nix ];
  den.aspects.work-wifi.nixos.imports        = [ ../../hosts/common/optional/work-wifi.nix ];
  den.aspects.chromium-policies.nixos.imports = [ ../../hosts/common/optional/chromiumPolicies.nix ];
}
