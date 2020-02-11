{config, lib, pkgs, ...}:

{
  # This value determines the NixOS release this system is
  networking = {
    hostName = "iroas";
    networkmanager.enable = true;
  };

  system = {
    stateVersion = "19.09";
    autoUpgrade.channel = "https://nixos.org/channels/nixos-19.09";
  };
  nix.maxJobs = lib.mkDefault 16;
  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";

  imports = [ ../common.nix ];

  boot = {
    loader = {
      grub = {
        enable = true;
        version = 2;
        device = "/dev/sdb";
      };

     # systemd-boot.enable = true;
     # efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_latest;
    tmpOnTmpfs = true;
    initrd.availableKernelModules = ["xhci_pci" "ahci" "ohci_pci" "ehci_pci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
    kernelModules = [ "kvm-amd" "wl" ];
    extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];
  };

  fileSystems = {
    "/" = {
     device = "/dev/disk/by-uuid/87adf855-d0e4-4229-aa88-66141faa6498";
      fsType = "ext4";
    };
    "/tmp" = {
      device = "tmpfs";
      fsType = "tmpfs";
    };
  };
  swapDevices =
  [ { device = "/dev/disk/by-uuid/a6de4132-e848-48d2-b9aa-5dc50ee91b1b"; } ];

  hardware.cpu.amd.updateMicrocode = true;

  users.users.root.openssh.authorizedKeys.keys = [
  (builtins.readFile ../users/jak/public_keys/id_ed25519.pub)
  ];

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
