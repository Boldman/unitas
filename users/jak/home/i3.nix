# File created by Jacob Boldman
{config, pkgs, ...}:
let
  cfg = config.xsession.windowManager.i3.config;
  colors = config.unitas.jak.colorScheme;
  modifier = config.xsession.windowManager.i3.config.modifier;
  workspaces = {
    one     = "1";
    two     = "2";
    three   = "3";
    four    = "4";
    five    = "5";
    six     = "6";
    seven   = "7";
    eight   = "8";
    nine    = "9";
  };
in
{
  xsession.windowManager.i3 = { 
    enable = true;
    package = pkgs.i3-gaps;
    config = {
      modifier = "Mod4";
      gaps = {
        inner = 15;
        outer = 15;
        smartBorders = "on";
        smartGaps = true;
      };
      bars =[];
      keybindings = {
        # Open terminal. should remove for ./sxhkd.nix
        "${modifier}+Return"        = "exec i3-sensible-terminal";
        # Open application launcher.
        "${modifier}+p"             = "exec ${pkgs.rofi}/bin/rofi -show drun";
        # Switch workspaces
        "${modifier}+1"             = "workspace ${workspaces.one}";
        "${modifier}+2"             = "workspace ${workspaces.two}";
        "${modifier}+3"             = "workspace ${workspaces.three}";
        "${modifier}+4"             = "workspace ${workspaces.four}";
        "${modifier}+5"             = "workspace ${workspaces.five}";
        "${modifier}+6"             = "workspace ${workspaces.six}";
        "${modifier}+7"             = "workspace ${workspaces.seven}";
        "${modifier}+8"             = "workspace ${workspaces.eight}";
        "${modifier}+9"             = "workspace ${workspaces.nine}";
        # Move containers between workspaces.
        "${modifier}+Shift+1"= "move container to workspace ${workspaces.one}";
        "${modifier}+Shift+2"= "move container to workspace ${workspaces.two}";
        "${modifier}+Shift+3"= "move container to workspace ${workspaces.three}";
        "${modifier}+Shift+4"= "move container to workspace ${workspaces.four}";
        "${modifier}+Shift+5"= "move container to workspace ${workspaces.five}";
        "${modifier}+Shift+6"= "move container to workspace ${workspaces.six}";
        "${modifier}+Shift+7"= "move container to workspace ${workspaces.seven}";
        "${modifier}+Shift+8"= "move container to workspace ${workspaces.eight}";
        "${modifier}+Shift+9"= "move container to workspace ${workspaces.nine}";
        # Switch into resize mode.
        "${modifier}+r"= "mode resize";
        # Switch between layouts.
        "${modifier}+o"             = "layout toggle split";
        "${modifier}+i"             = "layout tabbed";
        "${modifier}+u"             = "layout stacking";
        "${modifier}+f"             = "fullscreen toggle";
        "${modifier}+Shift+space"   = "floating toggle";
        "${modifier}+n"             = "split v";
        "${modifier}+m"             = "split h";

        "${modifier}+Shift+q" = "kill";
      };
    };
    extraConfig = with pkgs; let
      i3msg = "${config.xsession.windowManager.i3.package}/bin/i3-msg";
      defaultWorkspace = "workspace ${workspaces.one}";
    in
      ''
        # Instead of using `assigns` and `startup` to launch applications on startup, use exec with
        # i3-msg. This will avoid having *every* instance of these applications start on the assigned
        # workspace, only the initial instance.
        exec --no-startup-id ${i3msg} 'workspace ${workspaces.one}; exec ${alacritty}/bin/alacritty; ${defaultWorkspace}'
        exec --no-startup-id ${i3msg} 'workspace ${workspaces.two}; exec ${firefox}/bin/firefox; ${defaultWorkspace}'
        
        # Always put the first workspace on the primary monitor.
        ${defaultWorkspace} output primary
      '' + lib.strings.optionalString config.services.polybar.enable ''
        # Reload polybar so that it can connect to i3.
        exec --no-startup-id '${systemd}/bin/systemctl --user restart polybar'
      '';
  };
}
#vim:filetype=nix
