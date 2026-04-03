{ ... }:
{
  # Parametric: reads primaryUser from host schema to grant libvirtd group membership.
  den.aspects.libvirt.includes = [
    ({ host, ... }: {
      nixos = { config, pkgs, ... }: {
        programs.dconf.enable = true;
        users.users.${host.primaryUser}.extraGroups = [ "libvirtd" ];
        environment.systemPackages = with pkgs; [
          virt-manager
          virt-viewer
          spice
          spice-gtk
          spice-protocol
          virtio-win
          win-spice
        ];
        virtualisation = {
          libvirtd = {
            enable = true;
            qemu = {
              swtpm.enable = true;
              vhostUserPackages = [ pkgs.virtiofsd ];
            };
          };
          spiceUSBRedirection.enable = true;
        };
        services.spice-vdagentd.enable = true;
        environment.etc = {
          "ovmf/edk2-x86_64-secure-code.fd".source =
            config.virtualisation.libvirtd.qemu.package
            + "/share/qemu/edk2-x86_64-secure-code.fd";
          "ovmf/edk2-i386-vars.fd".source =
            config.virtualisation.libvirtd.qemu.package + "/share/qemu/edk2-i386-vars.fd";
        };
      };
    })
  ];
}
