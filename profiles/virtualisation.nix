{ config, pkgs, options, lib, ... }:

# This profile installs virtualization daemons and tools.

with lib;
let
  cfg = config.veritas.profiles.virtualisation;
in
{
  options.veritas.profiles.virtualisation.enable =
    mkEnableOption "Enable virtualisation daemons and tools";

  config = mkIf cfg.enable {
    # Install KVM kernel modules for AMD and Intel.
    boot.kernelModules = [ "kvm-amd" "kvm-intel" ];

    environment.systemPackages = with pkgs; [
      # Interact with VM
      looking-glass-client
      # Receive audio from VM
      scream-receivers
      # Virtual machine manager
      virtmanager
    ];

    # Idempotently ensures the needed folders are there for LXC.
    system.activationScripts = {
      "lxc-folders" = {
        text = ''
          mkdir -p /var/cache/lxc
          mkdir -p /var/lib/lxc/rootfs
        '';
        deps = [];
      };
    };

    systemd = {
      tmpfiles.rules = [
        "f /dev/shm/looking-glass 0660 ${config.users.users.david.name} qemu-libvirtd -"
        "f /dev/shm/scream 0660 ${config.users.users.david.name} qemu-libvirtd -"
      ];
      user.services.scream-ivshmem = {
        enable = true;
        description = "Scream IVSHMEM";
        serviceConfig = {
          "ExecStart" = "${pkgs.scream-receivers}/bin/scream-ivshmem-pulse /dev/shm/scream";
          "Restart" = "always";
        };
        wantedBy = [ "multi-user.target" ];
        requires = [ "pulseaudio.service" ];
      };
    };

    virtualisation = {
      # Enable docker.
      docker = {
        autoPrune = {
          dates = "weekly";
          enable = true;
        };
        enable = true;
      };
      # Use libvirtd to manage virtual machines.
      libvirtd = {
        enable = true;
        qemuOvmf = true;
        qemuRunAsRoot = false;
        onBoot = "ignore";
        onShutdown = "shutdown";
      };
      # Allow LXC/LXD containers.
      lxc = {
        defaultConfig = ''
          # Network interface piggy-backed from libvirt.
          lxc.network.type = veth
          lxc.network.link = virbr0
          lxc.network.name = eth0
          lxc.network.flags = up

          # Don't limit LXC with apparmor.
          lxc.aa_profile = unconfined
        '';
        enable = true;
        lxcfs.enable = true;
        usernetConfig = ''
          ${config.users.users.david.name} veth lxcbr0 10
        '';
      };
      lxd.enable = true;
    };
  };
}

# vim:foldmethod=marker:foldlevel=0:ts=2:sts=2:sw=2:nowrap
