{
  pkgs,
  config,
  lib,
  ...
}: {
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
        "${modifier}+Shift+r" = "exec swaymsg output '*' mode 2560x1440@60Hz";
        "${modifier}+Shift+o" = "exec foot -e sh -c 'swaymsg -t get_outputs | head -20; read'";
      };
      
      # 输出设置 (显示器配置) - 针对 Hyper-V 优化
      output = {
        # 使用通配符匹配所有输出
        "*" = {
          # 先尝试设置具体分辨率
          mode = "2560x1440@60Hz";
          scale = "1";
        };
        # 也可以尝试具体的输出名称
        "Virtual-1" = {
          mode = "2560x1440@60Hz";
          scale = "1";
        };
      };
    };
      
    extraConfig = ''
      # 窗口装饰
      default_border pixel 2
      default_floating_border pixel 2
      hide_edge_borders smart
      
      # 强制设置分辨率 - 多种尝试
      output * mode 2560x1440@60Hz
      output * scale 1
      output Virtual-1 mode 2560x1440@60Hz
      output Virtual-1 scale 1
      
      # 如果 2560x1440 不可用，尝试其他高分辨率
      # output * mode 1920x1080@60Hz
      
      # 空闲管理
      exec swayidle -w \
        timeout 300 'swaylock -f' \
        timeout 600 'swaymsg "output * dpms off"' \
        resume 'swaymsg "output * dpms on"' \
        before-sleep 'swaylock -f'
      
      # 针对 Hyper-V 的优化
      output * adaptive_sync off
      
      # 启动时执行分辨率设置命令
      exec_always {
        # 等待一秒让系统稳定
        sleep 1
        # 尝试设置分辨率
        swaymsg output "*" mode 2560x1440@60Hz
        swaymsg output "*" scale 1
      }
    '';
  };

  # 设置光标和 DPI - 针对高分辨率优化
  xresources.properties = {
    "Xcursor.size" = 24;  # 增大光标
    "Xft.dpi" = 96;       # 标准 DPI，不缩放
  };
}