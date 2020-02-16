{ config, pkgs, lib, ... }:

{
  imports = [ ../common.nix ];

  system = {
    stateVersion = "19.09";
    autoUpgrade.channel = "https://nixos.org/channels/nixos-unstable";
  };

  networking = {
    hostName = "lerna";
    networkmanager.enable = true;
  };
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
      initrd.availableKernelModules = [ "xhci_pci" "ahci" "ohci_pci" "ehci_pci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
      kernelModules = [ "kvm-amd" "wl"];
      extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/3784ba9e-f9f0-433a-ae57-4f759df3b8e1";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/D168-E9A9";
      fsType = "vfat";
    };
    "/tmp" = {
      device = "tmpfs";
      fsType = "tmpfs";
    };
  };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/821ac616-1f9c-41d2-9de5-fc24ef54ac28"; }
    ];

  nix.maxJobs = lib.mkDefault 4;
  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";


  services.logind.lidSwitch = "ignore";
  unitas.jak.dotfiles.headless = true;
  }


# vim:filetype=nix:foldmethod=marker:foldlevel=0:ts=2:sts=2:sw=2:nowrap
