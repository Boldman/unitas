{ config, pkgs, ... }:

{
  # Do not allow users to be added or modified except through Nix configuration.
  users.mutableUsers = false;

  # Define user accounts.
  users.extraUsers.david = {
    description = "David Wood";
    extraGroups = [ "wheel" "docker" "libvirtd" ];
    isNormalUser = true;
    uid = 1000;
    shell = pkgs.zsh;
    hashedPassword = "$6$kvMx6lEzQPhkSj8E$KfP/qM2cMz5VqNszLjeOBGnny3PdIyy0vnHzIgP.gb1XqTI/qq3nbt0Qg871pkmwJwIu3ZGt57yShMjFFMR3x1";
  };
}
