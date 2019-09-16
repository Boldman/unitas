{ config, pkgs, ... }:

# This file contains the configuration for i3.

let
  cfg = config.xsession.windowManager.i3.config;
  colours = config.veritas.david.colourScheme;
  fonts = [ "Iosevka 10" ];
  modifier = config.xsession.windowManager.i3.config.modifier;
  workspaces = {
    one = "0x1";
    two = "0x2";
    three = "0x3";
    four = "0x4";
    five = "0x5";
    six = "0x6";
    seven = "0x7";
    eight = "0x8";
    nine = "0x9";
  };
in {
  xsession.windowManager.i3 = {
    enable = !config.veritas.david.dotfiles.headless;
    config = {
      inherit fonts;
      assigns = {
        "${workspaces.one}" = [ { class = "^Alacritty$"; } ];
        "${workspaces.two}" = [ { class = "^Firefox$"; } { class = "^Franz$"; } ];
      };
      bars = [];
      colors = let asHex = c: "#${c}"; in {
        background = asHex colours.basic.background;
        # Customize our i3 colours:
        #
        # - `background` is the colour of the titlebar (only visible in tabbed or stacked mode).
        # - `border` is the colour of the border around the titlebar.
        # - `childBorder`: is the colour of the border around the whole window.
        # - `indicator` is the colour of the side that indicates where new windows will appear.
        # - `text` is the colour of the titlebar text.
        focused = {
          background = asHex colours.basic.background;
          border = asHex colours.basic.background;
          childBorder = asHex colours.basic.red;
          indicator = asHex colours.basic.brightRed;
          text = asHex colours.basic.foreground;
        };
        focusedInactive = cfg.colors.unfocused;
        placeholder = cfg.colors.unfocused;
        unfocused = {
          background = asHex colours.basic.background;
          border = asHex colours.basic.background;
          childBorder = asHex colours.basic.background;
          indicator = "#6B6B6B";
          text = asHex colours.basic.foreground;
        };
        urgent = {
          background = asHex colours.basic.background;
          border = asHex colours.basic.brightRed;
          childBorder = asHex colours.basic.brightRed;
          indicator = "#6B6B6B";
          text = asHex colours.basic.foreground;
        };
      };
      gaps = {
        inner = 2;
        outer = 1;
        smartBorders = "off";
        smartGaps = true;
      };
      keybindings = {
        # Open application selection with Win+p.
        "${modifier}+p" = "exec ${pkgs.rofi}/bin/rofi -show drun";
        # Open terminal with Win+Return.
        "${modifier}+Return" = "exec ${pkgs.alacritty}/bin/alacritty";
        # Switch workspaces with Win+{1,2,3,4,5,6,7,8,9}.
        "${modifier}+1" = "workspace ${workspaces.one}";
        "${modifier}+2" = "workspace ${workspaces.two}";
        "${modifier}+3" = "workspace ${workspaces.three}";
        "${modifier}+4" = "workspace ${workspaces.four}";
        "${modifier}+5" = "workspace ${workspaces.five}";
        "${modifier}+6" = "workspace ${workspaces.six}";
        "${modifier}+7" = "workspace ${workspaces.seven}";
        "${modifier}+8" = "workspace ${workspaces.eight}";
        "${modifier}+9" = "workspace ${workspaces.nine}";
        # Move containers between workspaces with Win+Shift+{1,2,3,4,5,6,7,8,9}.
        "${modifier}+Shift+1" = "move container to workspace ${workspaces.one}";
        "${modifier}+Shift+2" = "move container to workspace ${workspaces.two}";
        "${modifier}+Shift+3" = "move container to workspace ${workspaces.three}";
        "${modifier}+Shift+4" = "move container to workspace ${workspaces.four}";
        "${modifier}+Shift+5" = "move container to workspace ${workspaces.five}";
        "${modifier}+Shift+6" = "move container to workspace ${workspaces.six}";
        "${modifier}+Shift+7" = "move container to workspace ${workspaces.seven}";
        "${modifier}+Shift+8" = "move container to workspace ${workspaces.eight}";
        "${modifier}+Shift+9" = "move container to workspace ${workspaces.nine}";
        # Navigate using Vim bindings.
        "${modifier}+h" = "focus left";
        "${modifier}+j" = "focus down";
        "${modifier}+k" = "focus up";
        "${modifier}+l" = "focus right";
        # Switch to resize mode.
        "${modifier}+r" = "mode resize";
        # Switch between layouts.
        "${modifier}+o" = "layout toggle split";
        "${modifier}+i" = "layout tabbed";
        "${modifier}+u" = "layout stacking";
        "${modifier}+f" = "fullscreen toggle";
        "${modifier}+Shift+space" = "floating toggle";
        "${modifier}+n" = "split v";
        "${modifier}+m" = "split h";
        # Exit, quit, reload and kill.
        "${modifier}+Shift+c" = "reload";
        "${modifier}+Shift+e" =
          "exec i3-nagbar -t warning -m 'Do you want to exit i3?' -b 'Yes' 'i3-msg exit'";
        "${modifier}+Shift+q" = "kill";
        "${modifier}+Shift+r" = "restart";
        # Lock the screen.
        "${modifier}+q" = "exec ${pkgs.i3lock}/bin/i3lock -c 000000";
      };
      modes = {
        resize = {
          # Leave resize mode.
          "${modifier}+r" = "mode default";
          "${modifier}+Enter" = "mode default";
          "${modifier}+Escape" = "mode default";
          # Resize bindings.
          "${modifier}+h" = "resize shrink width 10x px or 10 ppt";
          "${modifier}+j" = "resize grow height 10 px or 10 ppt";
          "${modifier}+k" = "resize shrink height 10 px or 10 ppt";
          "${modifier}+l" = "resize grow width 10 px or 10 ppt";
        };
      };
      # Use Windows key instead of ALT.
      modifier = "Mod4";
      startup = [
        { command = "${pkgs.alacritty}/bin/alacritty"; }
        { command = "${pkgs.firefox}/bin/firefox"; }
        { command = "${pkgs.unstable.franz}/bin/franz"; }
      ];
      window = {
        titlebar = false;
        hideEdgeBorders = "none";
      };
    };
    extraConfig = ''
      # Let GNOME handle complicated stuff like monitors, bluetooth, etc.
      exec ${pkgs.gnome3.gnome_settings_daemon}/libexec/gnome-settings-daemon

      # Always put the first workspace on the primary monitor.
      workspace ${workspaces.one} output primary
    '';
  };
}

# vim:foldmethod=marker:foldlevel=0:ts=2:sts=2:sw=2:nowrap
