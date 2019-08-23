{ config, pkgs, options, ... }:

# This file contains common configuration shared amongst all hosts.

let
  external = import ./shared/external.nix;
in {
  imports = with external; [
    <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    # Import shared configuration of overlays and nixpkgs.
    ./shared
    # Always create my user account and dotfiles.
    ./users/david
    # Import custom modules and profiles.
    ./modules
    ./profiles
    # Enable home-manager.
    "${homeManager}/nixos"
    # Enable dwarffs.
    "${dwarffs}/module.nix"
    # Disable modules from 19.03 and use the versions from the unstable channel that match
    # versions we are using.
    "${nixpkgsUnstable}/nixos/modules/services/torrent/deluge.nix"
    "${nixpkgsUnstable}/nixos/modules/services/misc/lidarr.nix"
    "${nixpkgsUnstable}/nixos/modules/services/misc/jackett.nix"
    "${nixpkgsUnstable}/nixos/modules/services/misc/plex.nix"
  ];
  disabledModules = [
    "services/torrent/deluge.nix"
    "services/misc/jackett.nix"
    "services/misc/lidarr.nix"
    "services/misc/plex.nix"
  ];

  # Clean temporary directory on boot.
  boot.cleanTmpDir = true;

  environment = {
    pathsToLink = [ "/share/zsh" "/share" ];
    systemPackages = with pkgs; [
      # Logitech Devices
      solaar ltunify

      # Steam Controller
      steamcontroller

      # YubiKey
      yubikey-personalization yubikey-manager
    ];
  };

  hardware.opengl = {
    driSupport32Bit = true;
    enable = true;
    extraPackages = with pkgs; [
      # OpenCL
      intel-openclrt
      # VDPAU (hardware acceleration)
      vaapiIntel vaapiVdpau libvdpau-va-gl intel-media-driver
    ];
  };

  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "uk";
    defaultLocale = "en_GB.UTF-8";
  };

  networking = {
    firewall = {
      allowPing = true;
      enable = true;
      pingLimit = "--limit 1/minute --limit-burst 5";
      trustedInterfaces = [ "virbr0" "virbr0-nic" "lxdbr0" "docker0" ];
    };
    networkmanager.enable = false;
    useNetworkd = true;
  };

  nix = {
    # Automatically optimise the Nix store.
    autoOptimiseStore = true;
    # Add compatibility overlay to the $NIX_PATH, this overlay enables Nix tools (such as
    # `nix-shell`) to use the overlays defined in `nixpkgs.overlays`.
    nixPath = options.nix.nixPath.default ++ [ "nixpkgs-overlays=/etc/nixos/shared/compat.nix" ];
    # Enable serving packages over SSH when authenticated by the same keys as the `david` user.
    sshServe = {
      enable = true;
      keys = config.users.users.david.openssh.authorizedKeys.keys;
    };
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

  systemd.network = {
    enable = true;
    networks = {
      # Don't manage the interfaces created by Docker, libvirt or OpenVPN.
      "10-docker".extraConfig = ''
        [Match]
        Name=docker*

        [Link]
        Unmanaged=yes
      '';
      "11-virbr".extraConfig = ''
        [Match]
        Name=virbr*

        [Link]
        Unmanaged=yes
      '';
      "12-openvpn-tunnels".extraConfig = ''
        [Match]
        Name=tun*

        [Link]
        Unmanaged=yes
      '';
      "13-lxdbr".extraConfig = ''
        [Match]
        Name=lxdbr*

        [Link]
        Unmanaged=yes
      '';
      "14-veth".extraConfig = ''
        [Match]
        Name=veth*

        [Link]
        Unmanaged=yes
      '';
    };
  };

  services = {
    # Enable cron jobs.
    cron.enable = true;
    # Enable user services.
    dbus = {
      socketActivated = true;
      packages = with pkgs; [ gnome3.dconf ];
    };
    # Enable locate to find files quickly.
    locate.enable = true;
    # Enable ssh server.
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
    # Enable CUPS for printing.
    printing.enable = true;
    # Enable Keybase.
    keybase.enable = true;

    udev.packages = with pkgs; [
      # Required for YubiKey devices to work.
      yubikey-personalization libu2f-host
    ];
  };

  # Add insults to sudo.
  security.sudo.extraConfig = ''
    Defaults insults
  '';

  time.timeZone = "Europe/London";

  # Do not allow users to be added or modified except through Nix configuration.
  users.mutableUsers = false;
}

# vim:foldmethod=marker:foldlevel=0:ts=2:sts=2:sw=2:nowrap
