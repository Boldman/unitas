#vim: filetype=nix
# File created by Jacob Boldman
{config, pkgs, ...}:

{
  xsession.windowManager.i3 = { 
    enable = true;
    package = pkgs.i3-gaps;
    extraPackages = with pkgs; [
      rofi
      i3blocks-gaps
      i3lock
      ];
    config = {
      modifier = "Mod4";
      gaps = {
        inner = 15;
        outer = 15;
        smartBorders = "on";
        smartGaps = true;
      };
      bars = {
        [
          top = {
            position = "top";
            command = "\${pkgs.i3-gaps}/bin/i3bar -t";
            statusCommand = "\${pkgs.i3blocks-gap}/bin/i3blocks";
            mode = "dock";
            fonts = [ "FontAwesome 10" "Terminus" ];
          };
        ];
      };
      keybinding = {
        let
          modifier = xsession.windowManager.i3.config.modifier;
        in

        lib.mkOptionDefault{
          "${modifier}+Return" = "exec i3-sensible-terminal";
          "${modifier}+Shift+q" = "kill";
          "${modifier}+p" = "exec ${pkgs.rofi}/bin/rofi -show drun";
          "${modifier}+

      };
    };
  };


}
