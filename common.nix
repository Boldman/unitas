# File originally made by Jacob Boldman

#This file contains common configuration shared amongst all hosts.

{ config, pkgs, options, lib, ... }:

let
  sources = import ./nix/sources.nix;
in
  {
    boot = {
      tmpOnTmpfs = true;
      # Clean temporary directory on boot.
      cleanTmpDir = true;
      # Make memtest available as a boot option.
      loader = {
        grub.memtest86.enable = true;
        #systemd-boot.memtest86.enable = true;
      };
      # Enable support for nfs, ntfs.
      supportedFilesystems = [ "nfs" "ntfs"];
      # Enable plymouth on graphic based machines
      plymouth.enable = unitas.jak.headless
    };

    hardware = {
      pulseaudio = lib.mkIf (!config.unitas.jak.dotfiles.headless) {
        enable = true;
        #support32bit = true;
        package = pkgs.pulseaudioFull;
      };
    };
    i18n = {
      consoleFont = "Lat2-Terminus16";
      consoleKeyMap = "us";
      defaultLocale = "en_US.UTF-8";
    };

    imports = with sources; [
      <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
      # Always create my user account and dotfiles.
      ./users/jak
      # Import custom modules and profiles.
      # ./modules
      # ./profiles
      # Enable home-manager.
      "${home-manager}/nixos"
      # Enable dwarffs
      # "${dwarffs}/module.nix"
    ];

    networking = {
      firewall = {
        allowPing = true;
        enable = true;
        pingLimit = "--limit 1/minute --limit-burst 5";
        #trustedInterfaces = [];
      };
      networkmanager.enable = true;
    };
    nix = {
      # Automatically optimise the Nix store.
      autoOptimiseStore = true;
      # Enable serving packages over SSH when authenticated by the same keys as 'jak'.
      sshServe = {
        enable = true;
        keys = config.users.users.jak.openssh.authorizedKeys.keys;
      };
      buildMachines = [
        { hostName = "192.168.10.21";
          system = "x86_64-linux";
          maxJobs = 16;
          speedFactor = 3;
          supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" ];
          mandatoryFeatures = [ ];
	      }
        ] ;
	    distributedBuilds = true;
	    # optional, useful when the builder has a faster internet connection than yours
	    extraOptions = ''
		    builders-use-substitutes = true
	      '';
    };

    # This configuration only applies to the NixOS configuration! Not home-manager or nix-shell.
    nixpkgs ={
      config = import ./nix/config.nix;
      overlays = let
        unstable = import sources.nixpkgs { config = config.nixpkgs.config; };
      in
      [
        (_: _: { inherit unstable; })
      ];
    };

    programs = {
      mosh = {
        enable = true;
        withUtempter = true;
      };
    };

    # Add insults to sudo
    security.sudo.extraConfig = ''
      Defaults insults
    '';

    services = {
      # Enable cron jobs.
      cron.enable = true;
      locate.enable = true;
      openssh = {
        enable = true;
        forwardX11 = true;
        openFirewall = true;
        passwordAuthentication = false;
        permitRootLogin = "no";
      };
      xserver = lib.mkIf (!config.unitas.jak.dotfiles.headless) {
        enable = true;
        exportConfiguration = true;
        layout = "us";
      };
    };


    sound.mediaKeys = lib.mkIf (!config.unitas.jak.dotfiles.headless) {
      enable = true;
      volumeStep = "5%";
    };

    time.timeZone = "America/Los_Angeles";

    users.mutableUsers = false;
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
