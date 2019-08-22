{ config, pkgs, options, ... }:

let
  # Update these periodically (or when PRs land).
  homeManager = builtins.fetchGit {
    url = "https://github.com/rycee/home-manager.git";
    ref = "release-19.03";
    rev = "45a73067ac6b5d45e4b928c53ad203b80581b27d";
  };
  unstableChannel = builtins.fetchGit {
    url = "https://github.com/NixOS/nixpkgs-channels.git";
    ref = "nixos-unstable";
    rev = "3d84cffe95527abf139bd157befab677ba04a421";
  };
  mozillaOverlay = builtins.fetchGit {
    url = "https://github.com/mozilla/nixpkgs-mozilla.git";
    ref = "master";
    rev = "200cf0640fd8fdff0e1a342db98c9e31e6f13cd7";
  };
in {
  # Automatically optimise the Nix store.
  nix.autoOptimiseStore = true;
  # `nixpkgs.overlays` is the canonical list of overlays used in the system. It will be used by
  # Nix tools due to the compatability overlay included in the $NIX_PATH below.
  nixpkgs.overlays = let
    unstable = import unstableChannel { config = config.nixpkgs.config; };
  in [
    # Define a simple overlay that roots the unstable channel at `pkgs.unstable`.
    (self: super: { inherit unstable; })
    # Define custom packages and overrides in `./overlay.nix`.
    (import ./overlay.nix)
    # Use Mozilla's overlay for `rustChannelOf` function.
    (import mozillaOverlay)
  ];
  # Add compatibility overlay to the $NIX_PATH, this overlay enables Nix tools (such as
  # `nix-shell`) to use the overlays defined in `nixpkgs.overlays`.
  nix.nixPath = options.nix.nixPath.default ++ [ "nixpkgs-overlays=/etc/nixos/compat.nix" ];
  # Allow unfree packages.
  nixpkgs.config.allowUnfree = true;

  imports = [
    # Enable home-manager.
    "${homeManager}/nixos"
    # Disable modules from 19.03 and use the versions from the unstable channel that match
    # versions we are using.
    "${unstableChannel}/nixos/modules/services/torrent/deluge.nix"
    "${unstableChannel}/nixos/modules/services/misc/lidarr.nix"
    "${unstableChannel}/nixos/modules/services/misc/jackett.nix"
    "${unstableChannel}/nixos/modules/services/misc/plex.nix"
  ];
  disabledModules = [
    "services/torrent/deluge.nix"
    "services/misc/jackett.nix"
    "services/misc/lidarr.nix"
    "services/misc/plex.nix"
  ];

  # Enable serving packages over SSH when authenticated by the same keys as the `david` user.
  nix.sshServe.enable = true;
  nix.sshServe.keys = config.users.extraUsers.david.openssh.authorizedKeys.keys;

  # Boot {{{
  # ====
  boot.cleanTmpDir = true;
  # }}}

  # i18n {{{
  # ====
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "uk";
    defaultLocale = "en_GB.UTF-8";
  };

  time.timeZone = "Europe/London";
  # }}}

  # Packages {{{
  # ========
  environment.pathsToLink = [ "/share" ];

  environment.systemPackages = with pkgs; [
    kbfs solaar ltunify steamcontroller yubikey-personalization yubikey-manager
  ];

  programs = {
    adb.enable = true;
    bcc.enable = true;
    wireshark = {
      enable = true;
      package = pkgs.wireshark;
    };
  };
  # }}}

  # Shell {{{
  # ========
  programs.zsh.enable = true;
  # }}}

  # Services {{{
  # ========
  services = {
    # Enable cron jobs.
    cron.enable = true;

    # Enable user services.
    dbus.socketActivated = true;

    # Enable locate to find files quickly.
    locate.enable = true;

    # Required to let smart card mode of YubiKey to work.
    pcscd.enable = true;

    # Enable CUPS for printing.
    printing.enable = true;

    # Enable Keybase.
    keybase.enable = true;
    kbfs.enable = true;

    udev.packages = with pkgs; [
      # Required for YubiKey devices to work.
      yubikey-personalization libu2f-host
    ];
  };
  # }}}

  # Sudo {{{
  # ====
  security.sudo.extraConfig = ''
    Defaults insults
  '';
  # }}}

  # Hardware {{{
  # ========
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
  # }}}

  # Users {{{
  # ========
  # Do not allow users to be added or modified except through Nix configuration.
  users.mutableUsers = false;
  # }}}
}

# vim:foldmethod=marker:foldlevel=0:ts=2:sts=2:sw=2:nowrap
