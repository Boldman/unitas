{ config, lib, pkgs, ... }:

{
  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.03"; # Did you read the comment?
  nix.maxJobs = lib.mkDefault 8;

  imports = [ ../common.nix ];

  # Boot Loader {{{
  # ===========
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
  # }}}

  # Filesystems {{{
  # ===========
  fileSystems."/" =
    { device = "/dev/disk/by-uuid/15e4642b-713f-4e33-bb57-bccba586ca9d";
      fsType = "btrfs";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/54D5-DC0D";
      fsType = "vfat";
    };

  fileSystems."/data" =
    { device = "/dev/disk/by-uuid/f09ffaad-ce2e-479d-857c-7cd1605c51d3";
      fsType = "btrfs";
    };

  swapDevices = [ ];

  boot.initrd.luks.devices = [
    {
      name = "root";
      device = "/dev/nvme0n1p2";
      preLVM = true;
    }
  ];
  # }}}

  # Hardware {{{
  # ========
  boot.blacklistedKernelModules = [ "nouveau" ];
  boot.kernelParams = [ "nomodeset" "video=vesa:off" "vga=normal" ];
  boot.vesa = false;

  services.xserver.videoDrivers = [ "nvidia" ];
  # }}}

  # Kernel {{{
  # ======
  boot.kernelPackages = pkgs.linuxPackages_latest;
  # }}}

  # Microcode {{{
  # =========
  hardware.cpu.intel.updateMicrocode = true;
  # }}}

  # Networking {{{
  # ==========
  networking.hostName = "dtw-volkov";
  networking.wireless.enable = false;
  networking.useDHCP = true;
  # }}}

  # Startup Applications {{{
  # ====================
  environment.systemPackages = [
    (pkgs.makeAutostartItem { name = "alacritty"; package = pkgs.unstable.alacritty; })
    (pkgs.makeAutostartItem { name = "firefox"; package = pkgs.firefox; })
    (pkgs.makeAutostartItem { name = "franz"; package = pkgs.unstable.franz; })
  ];
  # }}}

  # Veritas {{{
  # ========
  veritas = {
    profiles = {
      desktop-environment.enable = true;
      virtualisation.enable = true;
    };
    david = {
      # Set the email address that should be used by the dotfiles in configuration files
      # (eg. `.gitconfig`).
      email.address = "david.wood@codeplay.com";
      dotfiles.headless = false;
    };
  };
  # }}}
}

# vim:foldmethod=marker:foldlevel=0:ts=2:sts=2:sw=2:nowrap
