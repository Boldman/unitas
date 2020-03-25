{config, lib, pkgs, ...}:

{
  # This value determines the NixOS release this system is
  networking = {
    hostName = "iroas";
    networkmanager.enable = true;
  };

  system = {
    stateVersion = "20.03";
    autoUpgrade = {
      enable = true;
      channel = "https://nixos.org/channels/nixos-20.03";
    };
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
    initrd.availableKernelModules = ["xhci_pci" "ahci" "ohci_pci" "ehci_pci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
    kernelModules = [ "kvm-amd" "wl" ];
    extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];
  };

  fileSystems = {
    "/" = {
     device = "/dev/disk/by-uuid/98ec6e2f-da3a-4a78-aa5a-4f45b0e0b109";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/DC05-788E";
      fsType = "vfat";
    };
    "/tmp" = {
      device = "tmpfs";
      fsType = "tmpfs";
    };
  };

  hardware.cpu.amd.updateMicrocode = true;

  users.users.root.openssh.authorizedKeys.keys = [
  (builtins.readFile ../users/jak/public_keys/id_ed25519.pub)
  ];

  unitas.jak = {
    dotfiles.headless = false;
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
