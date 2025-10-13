{
  pkgs,
  config,
  lib,
  ...
}: {
  wayland.windowManager.sway = {
    enable = true;
    config = {
      terminal = "ghostty";
      modifier = "Mod4"; # Mod4 = Super/Windows key
      
      # 基本快捷键
      keybindings = let
        modifier = config.wayland.windowManager.sway.config.modifier;
      in lib.mkOptionDefault {
        # 启动终端
        "${modifier}+Return" = "exec ghostty";
        
        # 应用启动器 (使用 wmenu,因为它在你的 extraPackages 中)
        "${modifier}+d" = "exec wmenu-run";
      };
      
      # 启动栏
      bars = [{
        command = "${pkgs.waybar}/bin/waybar";
      }];
    };
    
    extraConfig = ''
      # 额外配置
      default_border pixel 2
      default_floating_border pixel 2
      hide_edge_borders smart
      
      # 设置壁纸 (如果你有的话)
      # output * bg /path/to/wallpaper.jpg fill
    '';
  };

  # set cursor size and dpi for 4k monitor
  xresources.properties = {
    "Xcursor.size" = 16;
    "Xft.dpi" = 192;
  };
}