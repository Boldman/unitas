{ config, lib, ...}:

# This file contains the definition for the "unitas.jak" configuration options.

with lib;
let
  # Helper function to define an option for a color
  mkColor = description: default: mkOption {
    inherit default;
    description = ''
      Define the color for ${description}. Must be a hexidecimal representation, without leading pound sign.
      '';
      example = "FFFFFF";
      type = types.str;
    };
    #Helper function to construct a color with a foreground and background component.
    mkColorWithFgBg = description: fgHex: bgHex: {
      bg = mkColor "the background color of ${definition}" bgHex;
      fg = mkColor "the foreground color of ${definition}" fgHex;
    };
    #Short variable to access color configuration.
    colors = config.unitas.jak.colorScheme;
in
  {
    # Define color scheme.
    colorScheme = {
      # Basic sixteen color definitions for the color scheme
      basic = {
        background = mkColor "background" "1C1C1C";
        cursor = mkColor "foreground" colors.basic.foreground;
        foreground = mkColor "foreground" "C5C8C6";
        black = mkColor "black" "282A2E";
        red = mkColor "red" "A54242"; 
        green = mkColor "green" "8C9440";
        yellow = mkColor "yellow" "DE935F";
        blue = mkColor "blue" "5F819D";
        magenta = mkColor "magenta" "85678F";
        cyan = mkColor "cyan" "5E8D87";
        white = mkColor "white" "707880";
        # Bright colors.
        brightBlack = mkColor "bright black" "373B41";
        brightRed = mkColor "bright red" "CC6666";
        brightGreen = mkColor "bright green" "B5BD68";
        brightYellow = mkColor "bright yellow" "F0C674";
        brightBlue = mkColor "bright blue" "81A2BE";
        brightMagenta = mkColor "bright magenta" "B294BB";
        brightCyan = mkColor "bright cyan" "8ABEB7";
        brightWhite = mkColor "bright white" "C5C8C6";
      };
      # colors specific to Delta.
      delta = {
        minus = {
          regular = mkColor "delta's minus" "260808";
          emphasised = mkColor "delta's emphasised minus" "3f0d0d";
        };
        plus = {
          regular = mkColor "delta's plus" "0b2608";
          emphasised = mkColor "delta's emphasised plus" "123f0d";
        };
      };
      # colors specific to i3.
      i3 = {
        highlight = mkColor "i3's highlight" colors.basic.red;
        highlightBright = mkColor "i3's bright highlight" colors.basic.brightRed;
      };
      # colors specific to Starship.
      #
      # Starship seems to mangle the color slightly, so this hex produces the same
      # "optical" color as the regular muted grey used throughout the configuration.
      starship.mutedGrey = mkColor "starship's muted grey" "6B6B6B";
      # colors specific to Neovim.
      neovim = {
        termdebugProgramCounter = mkColor "termdebug's gutter breakpoint indicator"
          colors.neovim.termdebugBreakpoint.bg;
        termdebugBreakpoint = mkColorWithFgBg "termdebug's current line" "B2B2B2" "2B2B2B";
      };
      # colors specific to the xsession.
      xsession.wallpaper = mkColor "wallpaper" "121212";
    };

    domain = mkOption {
      type = types.str;
      default = "boldman.co";
      description = "Domain used in configuration files, such as `.gitconfig`";
    };

    dotfiles = {
      autorandrProfile = mkOption {
        type = types.attrs;
        description = "Configuration for autorandr";
      };

      headless = mkOption {
        type = types.bool;
        default = true;
        description = "Is this a headless host?";
      };

      isWsl = mkOption {
        type = types.bool;
        default = false;
        description = "Is this a WSL host?";
      };

      isNonNixOS = mkOption {
        type = types.bool;
        default = config.unitas.jak.dotfiles.isWsl;
        description = "Is this a non-NixOS host?";
      };

      minimal = mkOption {
        type = types.bool;
        default = false;
        description = "Omit parts of configuration that are expensive to build?";
      };
    };

    email = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable email from this host?";
      };
      address = mkOption {
        type = types.str;
        default = "jak@${config.unitas.jak.domain}";
        description = "Email used in configuration files.";
      };
    };

    hostName = mkOption {
      type = types.str;
      description = "Name of the host";
    };

    name = mkOption {
      type = types.str;
      default = "Jacob Boldman";
      description = "Name used in configuration files.";
    };
  }

# vim:filetype=nix:foldmethod=marker:foldlevel=0:ts=2:sts=2:sw=2:nowrap
