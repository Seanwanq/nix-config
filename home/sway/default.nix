{
  pkgs,
  config,
  lib,
  ...
}: {
  wayland.windowManager.sway = {
    enable = true;
    config = {
      terminal = "foot";  # 使用 foot 终端
      modifier = "Mod4"; # Mod4 = Super/Windows key
      
      # Sway 启动时执行的命令
      startup = [
        # 启动后台服务
        { command = "waybar"; always = true; }
      ];
      
      # 基本快捷键
      keybindings = let
        modifier = config.wayland.windowManager.sway.config.modifier;
      in lib.mkOptionDefault {
        # 启动终端
        "${modifier}+Return" = "exec foot";
        
        # 应用启动器 (使用 rofi)
        "${modifier}+d" = "exec rofi -show drun";
        
        # 电源管理菜单
        "${modifier}+Shift+e" = "exec rofi-power-menu";
        
        # 窗口切换
        "${modifier}+Tab" = "exec rofi -show window";
        
        # 截图
        "Print" = "exec grim ~/截图-$(date +%Y%m%d-%H%M%S).png";
        "${modifier}+Print" = "exec grim -g \"$(slurp)\" ~/截图-$(date +%Y%m%d-%H%M%S).png";
      };
      
      # 输出设置 (显示器配置) - 针对 Hyper-V 优化
      output = {
        "*" = {
          # 设置分辨率为 2560x1440，不使用缩放
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
      
      # 空闲管理
      exec swayidle -w \
        timeout 300 'swaylock -f' \
        timeout 600 'swaymsg "output * dpms off"' \
        resume 'swaymsg "output * dpms on"' \
        before-sleep 'swaylock -f'
      
      # 设置壁纸 (如果你有的话)
      # output * bg /path/to/wallpaper.jpg fill
      
      # 针对 Hyper-V 的优化
      output * adaptive_sync off
    '';
  };

  # 设置光标和 DPI - 针对高分辨率优化
  xresources.properties = {
    "Xcursor.size" = 24;  # 增大光标
    "Xft.dpi" = 96;       # 标准 DPI，不缩放
  };
}