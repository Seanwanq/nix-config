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
      startup = [
        # PolKit authentication agent for 1Password system authentication
        { command = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"; always = false; }
        # 启动后台服务
        # { command = "waybar"; always = true; }
      ];
      
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
        
        # 音量控制 (使用 wpctl for PipeWire)
        "XF86AudioRaiseVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
        "XF86AudioLowerVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
        "XF86AudioMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        "XF86AudioMicMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
        
        # 媒体播放控制
        "XF86AudioPlay" = "exec playerctl play-pause";
        "XF86AudioPause" = "exec playerctl play-pause";
        "XF86AudioNext" = "exec playerctl next";
        "XF86AudioPrev" = "exec playerctl previous";
        
        # 亮度控制
        "XF86MonBrightnessUp" = "exec brightnessctl set +5%";
        "XF86MonBrightnessDown" = "exec brightnessctl set 5%-";
        
        # 调试和分辨率设置
        "${modifier}+Shift+r" = "exec swaymsg output '*' mode 2560x1440";
        "${modifier}+Shift+o" = "exec ghostty -e sh -c 'swaymsg -t get_outputs; read'";
      };
      
      # 输出设置 (显示器配置) - 保持简单，让 Sway 自动检测
      output = {
        "*" = {
          mode = "2560x1440@60Hz";
          scale = "1.5";
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
    '';
  };

  # 设置光标和 DPI - 针对高分辨率优化
  xresources.properties = {
    "Xcursor.size" = 32;  # 增大光标
    "Xft.dpi" = 192;       # 标准 DPI，不缩放
  };
}