{config, lib, pkgs, ...}:

{
  # This value determines the NixOS release this system is
  system = {
    stateVersion = "19.09";
    autoUpgrade.channel = "https://nixos.org/channels/nixos-19.09";
  };
  nix.maxJobs = lib.mkDefault 16;
  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";

  imports = [ ../common.nix ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_latest;
    tmpOnTmpfs = true;
#    initrd.avaibleKernelModules = ["xhci_pci" "ahci" "ohci_pci" "ehci_pci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
    kernelModules = [ "kvm-amd" "wl" ];
    extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];
  };

  fileSystems = {
    "/" = {
     device = "/dev/disk/by-uuid/d923c5d4-3c1f-4ba1-82ed-172020c5d0ef";
      fsType = "ext4";
    };
    "/boot" =
    { device = "/dev/disk/by-uuid/D168-E9A9";
      fsType = "vfat";
    };
    "/tmp" = {
      device = "tmpfs";
      fsType = "tmpfs";
    };
  };
  swapDevices =
  [ { device = "/dev/disk/by-uuid/821ac616-1f9c-41d2-9de5-fc24ef54ac28"; } ];

  hardware.cpu.amd.updateMicrocode = true;

  unitas.jak = {
    dotfiles.headless = true;
  };

  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      corefonts
      vistafonts
      inconsolata
      terminus_font
      proggyfonts
      dejavu_fonts
      font-awesome-ttf
      ubuntu_font_family
      source-code-pro
      source-sans-pro
      source-serif-pro
    ];
  };
}
# vim:filetype=nix:foldmethod=marker:foldlevel=0:ts=2:sts=2:sw=2:nowrap
