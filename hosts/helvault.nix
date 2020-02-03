{ config, lib, pkgs, ... }:

{
  networking.hostname = "helvault";

  # This value determines the Nixos release this system is 
  system = {
    stateVersion = "19.03";
    autoUpgrade.channel = "https://nixos.org/channels/nixos-19.03";
  };
  nix.maxJobs = lib.mkDefault 8;
  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";

  imports =
    [ ../common.nix ];

  boot = {
    loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    };
    initrd.availableKernelModules = [ "xhci_pci" "ahci" "ohci_pci" "ehci_pci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
    kernelModules = [ "kvm-amd" "wl" ];
    extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];
  };

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/d923c5d4-3c1f-4ba1-82ed-172020c5d0ef";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/D168-E9A9";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/821ac616-1f9c-41d2-9de5-fc24ef54ac28"; }
    ];

    services.logind.lidswitch = true;
    unitas = {
      jak = {
        email.address = "boldman@linux.com";
        dotfiles.headless = true;
      };
    };

}

# vim:filetype=nix:foldmethod=marker:foldlevel=0:ts=2:sts=2:sw=2:nowrap
