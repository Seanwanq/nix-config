{
  pkgs,
  config,
  lib,
  ...
}: {
  # 安装 wayvnc 用于远程桌面
  home.packages = with pkgs; [
    wayvnc
  ];

  wayland.windowManager.sway = {
    enable = true;
    config = {
      terminal = "ghostty";  # 使用 ghostty 终端
      modifier = "Mod4"; # Mod4 = Super/Windows key
      
      # Sway 启动时执行的命令
      # startup = [
      #   # 启动后台服务
      #   { command = "waybar"; always = true; }
      # ];
      
      # 基本快捷键
      keybindings = let
        modifier = config.wayland.windowManager.sway.config.modifier;
      in lib.mkOptionDefault {
        # 启动终端
        "${modifier}+Return" = "exec ghostty";
        
        # 应用启动器 (使用 rofi)
        "${modifier}+d" = "exec rofi -show drun";
        
        # 电源管理菜单
        "${modifier}+Shift+e" = "exec rofi-power-menu";
        
        # 窗口切换
        "${modifier}+Tab" = "exec rofi -show window";
        
        # 截图
        "Print" = "exec grim ~/截图-$(date +%Y%m%d-%H%M%S).png";
        "${modifier}+Print" = "exec grim -g \"$(slurp)\" ~/截图-$(date +%Y%m%d-%H%M%S).png";
        
        # 调试和分辨率设置
        "${modifier}+Shift+r" = "exec swaymsg output '*' mode 2560x1440";
        "${modifier}+Shift+o" = "exec ghostty -e sh -c 'swaymsg -t get_outputs; read'";
      };
      
      # 输出设置 (显示器配置) - 保持简单，让 Sway 自动检测
      output = {
        "*" = {
          mode = "1920x1080@60Hz";
          scale = "1";
        };
      };
    };
      
    extraConfig = ''
      # 窗口装饰
      default_border pixel 2
      default_floating_border pixel 2
      hide_edge_borders smart
      
      # 空闲管理
      exec swayidle -w \
        timeout 300 'swaylock -f' \
        timeout 600 'swaymsg "output * dpms off"' \
        resume 'swaymsg "output * dpms on"' \
        before-sleep 'swaylock -f'
      
      # 启动 wayvnc 用于远程访问（端口 5900）
      # 这样可以通过 VNC 连接并设置任意分辨率
      exec wayvnc -o HEADLESS-1 -r 0.0.0.0 5900
      
      # 创建虚拟高分辨率输出
      output HEADLESS-1 {
        mode 2560x1440@60Hz
        position 1920,0
      }
    '';
  };

  # 设置光标和 DPI - 针对高分辨率优化
  xresources.properties = {
    "Xcursor.size" = 24;  # 增大光标
    "Xft.dpi" = 96;       # 标准 DPI，不缩放
  };
}