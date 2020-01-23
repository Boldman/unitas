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
    users.users.jak = {
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
      hashedPassword = "$6$qs0Z2zH.zpwMRu$.tloNjneyofJOJ0ple./d8sb7.CLve1NYjIt1LeSQJsYyzBxcD5l3/Xdnr5.JmEe/44BdOC31Kvl9v1PYYPpT/";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        (builtins.readFile ./public_keys/id_ed25519.pub)
      ];
    };
  };
}
      
# vim:filetype=nix:foldmethod=marker:foldlevel=0:ts=2:sts=2:sw=2:nowrap
