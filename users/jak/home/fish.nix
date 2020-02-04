{ pkgs, config, lib, ... }:

# This file contains the configuration for fish.

with lib;
{
  programs.fish = {
    enable = true;
    interactiveShellInit = with config.unitas.jak.colorScheme.basic; ''
      # Disable the greeting message.
      set fish_greeting
      # Set environment variables.
      set -x COLORTERM truecolor
      set -x TERM xterm-256color
      # Use vi keybinds.
      fish_vi_key_bindings
      # Use hybrid color scheme.
      set fish_color_autosuggestion ${white}
      set fish_color_command ${brightYellow}
      set fish_color_comment ${brightGreen}
      set fish_color_cwd ${green}
      set fish_color_cwd_root ${red}
      set fish_color_end ${brightMagenta}
      set fish_color_error ${brightRed}
      set fish_color_escape ${brightCyan}
      set fish_color_operator ${brightCyan}
      set fish_color_param ${green}
      set fish_color_quote ${brightGreen}
      set fish_color_redirection ${cyan}
      set fish_color_status ${red}
      set fish_color_user ${brightGreen}
      set fish_color_description ${magenta}
    '' + (
      optionalString config.unitas.jak.dotfiles.isNonNixOS ''
        # Needed for `home-manager switch` to work.
        set -x NIX_PATH ${config.home.homeDirectory}/.nix-defexpr/channels\''${NIX_PATH:+:}$NIX_PATH
      ''
    );
    package = pkgs.unstable.fish;
    shellAliases = with pkgs; {
      # Make `rm` prompt before removing more than three files or removing recursively.
      "rm" = "${coreutils}/bin/rm -i";
      # Aliases that make commands colorful.
      "grep" = "${gnugrep}/bin/grep --color=auto";
      "fgrep" = "${gnugrep}/bin/fgrep --color=auto";
      "egrep" = "${gnugrep}/bin/egrep --color=auto";
      # Aliases for `cat` to `bat`.
      "cat" = "${bat}/bin/bat --paging=never -p";
      # Aliases for `ls` to `exa`.
      "ls" = "${exa}/bin/exa";
      "dir" = "${exa}/bin/exa";
      "ll" = "${exa}/bin/exa -alF";
      "vdir" = "${exa}/bin/exa -l";
      "la" = "${exa}/bin/exa -a";
      "l" = "${exa}/bin/exa -F";
      # Extra Git subcommands for GitHub.
      "git" = "${gitAndTools.hub}/bin/hub";
      # Common mistake when looking up ip address info
      "ipa" = "ip address";
    };
  };
}

# vim:filetype=nix:foldmethod=marker:foldlevel=0:ts=2:sts=2:sw=2:nowrap
