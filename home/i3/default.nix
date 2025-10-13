{
  pkgs,
  config,
  lib,
  ...
}: {
  # i3 窗口管理器配置
  xsession.windowManager.i3 = {
    enable = true;
    config = {
      modifier = "Mod4";  # Super/Windows key
      terminal = "ghostty";
      
      # 基本快捷键
      keybindings = let
        modifier = config.xsession.windowManager.i3.config.modifier;
      in lib.mkOptionDefault {
        # 启动终端
        "${modifier}+Return" = "exec ghostty";
        
        # 应用启动器
        "${modifier}+d" = "exec rofi -show run";
        
        # 窗口大小调整 (直接快捷键)
        "${modifier}+Ctrl+h" = "resize shrink width 10 px or 10 ppt";
        "${modifier}+Ctrl+j" = "resize grow height 10 px or 10 ppt";
        "${modifier}+Ctrl+k" = "resize shrink height 10 px or 10 ppt";
        "${modifier}+Ctrl+l" = "resize grow width 10 px or 10 ppt";
        
        # 窗口大小调整 (方向键)
        "${modifier}+Ctrl+Left" = "resize shrink width 10 px or 10 ppt";
        "${modifier}+Ctrl+Down" = "resize grow height 10 px or 10 ppt";
        "${modifier}+Ctrl+Up" = "resize shrink height 10 px or 10 ppt";
        "${modifier}+Ctrl+Right" = "resize grow width 10 px or 10 ppt";
      };
      
      # 启动栏
      # bars = [{
      #   status_command = "${pkgs.i3status}/bin/i3status";
      # }];
      
      # 启动项
      startup = [
        # 显示器缩放设置
        { command = "xrandr --output Virtual-1 --scale 1x1"; always = false; notification = false; }
        # 启动 GNOME Keyring (VSCode 需要)
        { command = "gnome-keyring-daemon --start --components=secrets"; always = false; notification = false; }
      ];
    };
  };

  # set cursor size and dpi for 4k monitor
  xresources.properties = {
    "Xcursor.size" = 32;  # 适应 2560x1440 分辨率
    "Xft.dpi" = 192;
  };
}
