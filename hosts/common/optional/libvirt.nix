{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = [inputs.nixvirt.nixosModules.default];

  # configure for using virt-manager
  virtualisation = {
    libvirt.enable = true;
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        swtpm.enable = true;
        ovmf.enable = true;
        ovmf.packages = [pkgs.OVMFFull.fd];
      };
    };
    kvmgt.enable = true;

    # WARNING: defining this will wipe-out any existing libvirt connections (i.e. virt-manager VMs you manually created)
    libvirt.connections = {
      "qemu:///system" = {
        domains = [
          {
            definition = lib.custom.relativeToRoot "dotfiles/virt/domains/generic.xml";
            active = true;
          }
        ];
        pools = [
          {
            definition = lib.custom.relativeToRoot "dotfiles/virt/pools/pools.xml";
            active = true;
          }

        ];
      };
    };


  };

  hardware.ksm.enable = true; # enable kernel same-page merging

  programs.virt-manager.enable = true;

  environment.systemPackages = [
    # QEMU/KVM(HostCpuOnly), provides:
    #   qemu-storage-daemon qemu-edid qemu-ga
    #   qemu-pr-helper qemu-nbd elf2dmp qemu-img qemu-io
    #   qemu-kvm qemu-system-x86_64 qemu-system-aarch64 qemu-system-i386
    pkgs.qemu_kvm

    # Install QEMU(other architectures), provides:
    #   ......
    #   qemu-loongarch64 qemu-system-loongarch64
    #   qemu-riscv64 qemu-system-riscv64 qemu-riscv32  qemu-system-riscv32
    #   qemu-system-arm qemu-arm qemu-armeb qemu-system-aarch64 qemu-aarch64 qemu-aarch64_be
    #   qemu-system-xtensa qemu-xtensa qemu-system-xtensaeb qemu-xtensaeb
    #   ......
    pkgs.qemu
  ];

  users.users.${config.hostSpec.username} = {
    extraGroups = [ "libvirtd" ];
  };
}
