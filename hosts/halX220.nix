{config, lib, pkgs, ...}:

{
  # This value determines the NixOS release this system is
  networking = {
    hostName = "HalX220";
    hostId = "44825cad";
  };
  system = {
    stateVersion = "19.09";
    autoUpgrade.channel = "https://nixos.org/channels/nixos-unstable";
  };
  nix.maxJobs = lib.mkDefault 1;
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  imports = [ ../common.nix ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_latest;
    initrd.availableKernelModules = [ "ehci_pci" "ahci" "sd_mod" "sdhci_pci"];
    kernelModules = [ "kvm-intel" ];
    supportedFilesystems = [ "xfs" "ext4" "zfs"];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/754c12bf-cabc-4fa2-b73c-1e8cc494a9a9";
      fsType = "xfs";
    };
    "/home" = {
      device = "/dev/disk/by-uuid/b953f985-7765-4010-8a7b-eb416bacb213";
      fsType = "xfs";
    };
  };

  swapDevices = [ ];

  hardware = {
    cpu.intel.updateMicrocode = true;
    trackpoint.emulateWheel = true;
  };

  services = {
    fprintd.enable = true;
    tlp.enable = true;
    upower.enable = true;
    gnome3.gnome-keyring.enable = true;
  };

  security = {
    sudo.wheelNeedsPassword = true;
    pam.services = {
      login.fprintAuth = true;
      xscreensaver.fprintAuth = true;
      jak.fprintAuth = true;
    };
  };

  unitas = {
    jak = {
      email.address = "boldman@linux.com";
      dotfiles.headless = false;
    };
  };
}

# vim:filetype=nix:foldmethod=marker:foldlevel=0:ts=2:sts=2:sw=2:nowrap
