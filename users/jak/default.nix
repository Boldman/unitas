{ config, pkgs, lib, ...}:

# This file contains a NixOS module for creating my user account and dotfiles.

let
  cfg = config.unitas.jak;
in
{
  options.unitas.jak = import ./options.nix { inherit config; inherit lib; };

  config = {
    # This option can be set automatically here for all NixOS hosts, it must be set manually for non-NixOS hosts.
    unitas.jak.hostName = config.networking.hostName;

    home-manager.users.jak = { config, pkgs, libs, ...}: {
      imports = [ ./home ];

      # Add the `unitas.jak` configuration options that are set in NixOS.
      options.unitas.jak = import ./options.nix {inherit config; inherit lib; };
      config.unitas.jak = cfg;
    };

    # Require to use zsh
    programs.fish.enable = true;

    #Create user account.
    users = {
      motd = with config; ''
        Welcome to ${networking.hostName}
        - This machine is managed by NixOS
        - All changes are futile
        OS:      NixOS ${system.nixos.release} (${system.nixos.codeName})
        Version: ${system.nixos.version}
        Kernel:  ${boot.kernelPackages.kernel.version}
      '';
      users.jak = {
        description = cfg.name;
        extraGroups = [
          "audio"
          "disk"
          "docker"
          "input"
          "libvirtd"
          "lxd"
          "plugdev"
          "systemd-journal"
          "vboxusers"
          "video"
          "wheel"
        ];
        uid = 1000;
        shell = pkgs.unstable.fish;
        hashedPassword = "$6$.Ak8UwJF1v13lZ$Ji0WeEg1ssLxLbZRZOM6g5Ltggp5hpq32.crWz0tRlfTauQERv5CdBaGGClRBskU0BnpncJJIxe5SS8/6O9Ko1";
        isNormalUser = true;
        openssh.authorizedKeys.keys = [
          (builtins.readFile ./public_keys/id_ed25519.pub)
        ];
      };
    };
  };
}

# vim:filetype=nix:foldmethod=marker:foldlevel=0:ts=2:sts=2:sw=2:nowrap
