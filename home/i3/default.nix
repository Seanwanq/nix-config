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
        
        # 电源管理菜单
        "${modifier}+Shift+e" = "exec ${pkgs.writeShellScript "power-menu" ''
          #!/bin/bash
          
          # 电源管理选项
          options="⏻ 关机\n🔄 重启\n😴 休眠\n🔒 锁屏\n📴 注销\n❌ 取消"
          
          # 使用 rofi 显示菜单
          selected=$(echo -e "$options" | rofi -dmenu -i -p "电源管理:" -theme-str 'window {width: 300px;}')
          
          case "$selected" in
            "⏻ 关机")
              systemctl poweroff
              ;;
            "🔄 重启")
              systemctl reboot
              ;;
            "😴 休眠")
              systemctl suspend
              ;;
            "🔒 锁屏")
              i3lock -c 1e1e2e --show-failed-attempts
              ;;
            "📴 注销")
              i3-msg exit
              ;;
            *)
              # 取消或其他选择,不执行任何操作
              ;;
          esac
        ''}";
        
        # 直接电源操作快捷键
        # "${modifier}+Shift+q" = "exec i3-msg exit";  # 注销
        "${modifier}+Shift+l" = "exec i3lock -c 1e1e2e --show-failed-attempts";  # 锁屏
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
