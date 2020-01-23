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
      type = type.str;
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
        green = mkColour "green" "8C9440";
        yellow = mkColour "yellow" "DE935F";
        blue = mkColour "blue" "5F819D";
        magenta = mkColour "magenta" "85678F";
        cyan = mkColour "cyan" "5E8D87";
        white = mkColour "white" "707880";
        # Bright colours.
        brightBlack = mkColour "bright black" "373B41";
        brightRed = mkColour "bright red" "CC6666";
        brightGreen = mkColour "bright green" "B5BD68";
        brightYellow = mkColour "bright yellow" "F0C674";
        brightBlue = mkColour "bright blue" "81A2BE";
        brightMagenta = mkColour "bright magenta" "B294BB";
        brightCyan = mkColour "bright cyan" "8ABEB7";
        brightWhite = mkColour "bright white" "C5C8C6";
      };
      # Colours specific to Delta.
      delta = {
        minus = {
          regular = mkColour "delta's minus" "260808";
          emphasised = mkColour "delta's emphasised minus" "3f0d0d";
        };
        plus = {
          regular = mkColour "delta's plus" "0b2608";
          emphasised = mkColour "delta's emphasised plus" "123f0d";
        };
      };
      # Colours specific to i3.
      i3 = {
        highlight = mkColour "i3's highlight" colours.basic.red;
        highlightBright = mkColour "i3's bright highlight" colours.basic.brightRed;
      };
      # Colours specific to Starship.
      #
      # Starship seems to mangle the colour slightly, so this hex produces the same
      # "optical" colour as the regular muted grey used throughout the configuration.
      starship.mutedGrey = mkColour "starship's muted grey" "6B6B6B";
      # Colours specific to Neovim.
      neovim = {
        termdebugProgramCounter = mkColour "termdebug's gutter breakpoint indicator"
          colours.neovim.termdebugBreakpoint.bg;
        termdebugBreakpoint = mkColourWithFgBg "termdebug's current line" "B2B2B2" "2B2B2B";
      };
      # Colours specific to the xsession.
      xsession.wallpaper = mkColour "wallpaper" "121212";
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

      isNonNixos = mkOption {
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
