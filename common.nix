{ config, pkgs, options, lib, ... }:

# This file contains common configuration shared amongst all hosts.
let
  sources = import ./nix/sources.nix;
in
{
  boot = {
    # Enable running aarch64 binaries using qemu.
    binfmt.emulatedSystems = [ "aarch64-linux" ];

    # Clean temporary directory on boot.
    cleanTmpDir = true;

    # Make memtest available as a boot option.
    loader = {
      grub.memtest86.enable = true;
      systemd-boot.memtest86.enable = true;
    };

    # Enable support for nfs and ntfs.
    supportedFilesystems = [ "cifs" "ntfs" "nfs" ];
  };

  console = {
    font = "Lat2-Terminus16";
    keyMap = "uk";
  };

  environment = {
    pathsToLink = [ "/share/fish" "/share" ];
    systemPackages = with pkgs; [
      # Logitech Devices
      solaar
      ltunify

      # Steam Controller
      steamcontroller

      # YubiKey
      yubikey-personalization
      yubikey-manager
    ];
  };

  hardware = {
    pulseaudio = lib.mkIf (!config.veritas.david.dotfiles.headless) {
      enable = true;
      support32Bit = true;
      package = pkgs.pulseaudioFull;
    };

    opengl = {
      driSupport32Bit = true;
      enable = true;
      extraPackages = with pkgs; [
        # OpenCL
        intel-openclrt
        unstable.intel-compute-runtime
        # VDPAU (hardware acceleration)
        vaapiIntel
        vaapiVdpau
        libvdpau-va-gl
        intel-media-driver
      ];
    };
  };

  i18n = {
    defaultLocale = "en_GB.UTF-8";
  };

  imports = with sources; [
    <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    # Always create my user account and dotfiles.
    ./users/david
    # Import custom modules and profiles.
    ./modules
    ./profiles
    # Enable home-manager.
    "${home-manager}/nixos"
    # Enable dwarffs.
    "${dwarffs}/module.nix"
    # Enable Wooting support from unstable.
    "${nixpkgs}/nixos/modules/hardware/wooting.nix"
  ];

  networking = {
    firewall = {
      allowPing = true;
      enable = true;
      pingLimit = "--limit 1/minute --limit-burst 5";
    };
    networkmanager.enable = false;
    # Add dnsmasq's listen address as a nameserver.
    nameservers = [ "127.0.0.2" ];
    timeServers = options.networking.timeServers.default ++ [
      "0.uk.pool.ntp.org"
      "1.uk.pool.ntp.org"
      "2.uk.pool.ntp.org"
      "3.uk.pool.ntp.org"
    ];
    # Must be set per-interface.
    useDHCP = false;
    # Prefer networkd on all hosts.
    useNetworkd = true;
    wireless.networks = {
      "The Ubiqitous Chip" = lib.mkIf (builtins.pathExists ./secrets/wifi/ubiqitous_chip.password) {
        priority = 10;
        psk = "${lib.removeSuffix "\n" (builtins.readFile ./secrets/wifi/ubiqitous_chip.password)}";
      };
    };
  };

  nix = {
    # Automatically optimise the Nix store.
    autoOptimiseStore = true;
    # Enable serving packages over SSH when authenticated by the same keys as the `david` user.
    sshServe = {
      enable = true;
      keys = config.users.users.david.openssh.authorizedKeys.keys;
    };
  };

  # This configuration only applies to the NixOS configuration! Not home-manager or nix-shell, etc.
  nixpkgs = {
    config = import ./nix/config.nix;
    overlays =
      let
        unstable = import sources.nixpkgs { config = config.nixpkgs.config; };
      in
      [
        (_: _: { inherit unstable; })
        (_: _: { inherit (unstable) wootility wooting-udev-rules; })
        (
          _: super: {
            intel-openclrt = super.callPackage ./packages/intel-openclrt.nix { };
          }
        )
      ];
  };

  programs = {
    adb.enable = true;
    ccache.enable = true;
    bcc.enable = true;
    mosh = {
      enable = true;
      withUtempter = true;
    };
    nano.syntaxHighlight = true;
    wireshark = {
      enable = true;
      package = pkgs.wireshark;
    };
  };

  # Add insults to sudo.
  security.sudo.extraConfig = ''
    Defaults insults
  '';

  services = {
    cron.enable = true;

    dbus = {
      socketActivated = true;
      packages = with pkgs; [ gnome3.dconf ];
    };

    # Run dnsmasq on another interface so as not to interfere with `systemd-resolved`.
    dnsmasq = {
      # Need to `mkForce` to override the options set by `services.nixops-dns`.
      extraConfig = lib.mkForce ''
        bind-interfaces
        listen-address=127.0.0.2
      '';
      resolveLocalQueries = lib.mkForce false;
    };

    gnome3 = lib.mkIf (!config.veritas.david.dotfiles.headless) {
      core-os-services.enable = true;
      core-utilities.enable = true;
    };

    keybase.enable = true;

    locate.enable = true;

    logind.extraConfig = ''
      RuntimeDirectorySize=20%
    '';

    # Run a DNS server that dynamically maps `<hostname>.nixops` to running NixOps
    # machines.
    nixops-dns = {
      dnsmasq = true;
      domain = "nixops";
      enable = true;
    };

    openssh = {
      enable = true;
      extraConfig = ''
        # Required for GPG forwarding.
        StreamLocalBindUnlink yes

        Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com
        MACs hmac-sha2-512-etm@openssh.com
        KexAlgorithms curve25519-sha256@libssh.org,diffie-hellman-group-exchange-sha256
        RekeyLimit 256M
      '';
      forwardX11 = true;
      openFirewall = true;
      passwordAuthentication = false;
      permitRootLogin = "no";
    };

    # Required to let smart card mode of YubiKey to work.
    pcscd.enable = true;

    printing.enable = true;

    # Fallback to Cloudflare DNS instead of Google.
    resolved.fallbackDns = [
      "1.1.1.1"
      "1.0.0.1"
      "2606:4700:4700::1111"
      "2606:4700:4700::1001"
    ];

    # Required for YubiKey devices to work.
    udev.packages = with pkgs; [ yubikey-personalization libu2f-host ];

    xserver = lib.mkIf (!config.veritas.david.dotfiles.headless) {
      enable = true;
      exportConfiguration = true;
      # i3 is the primary desktop but without GNOME being enabled, gdm doesn't have any session
      # files and crashes as a result.
      desktopManager.gnome3.enable = true;
      displayManager.gdm = {
        enable = true;
        # Need to upgrade to Sway to use Wayland.
        wayland = false;
        nvidiaWayland = true;
      };
      layout = "gb";
    };
  };

  sound.mediaKeys = lib.mkIf (!config.veritas.david.dotfiles.headless) {
    enable = true;
    volumeStep = "5%";
  };

  systemd.network = {
    enable = true;
    networks = {
      # Don't manage the interfaces created by OpenVPN.
      "10-openvpn-tunnels".extraConfig = ''
        [Match]
        Name=tun*

        [Link]
        Unmanaged=yes
      '';
    };
  };

  time.timeZone = "Europe/London";

  # Do not allow users to be added or modified except through Nix configuration.
  users.mutableUsers = false;
}

# vim:foldmethod=marker:foldlevel=0:ts=2:sts=2:sw=2:nowrap
