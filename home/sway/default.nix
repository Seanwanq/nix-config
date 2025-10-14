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
        "${modifier}+Shift+r" = "exec ${pkgs.writeShellScript "force-resolution.sh" ''
          ${pkgs.sway}/bin/swaymsg output '*' mode 2560x1440@60Hz || \
          ${pkgs.sway}/bin/swaymsg output '*' mode 2560x1440 || \
          ${pkgs.libnotify}/bin/notify-send "分辨率设置" "无法设置 2560x1440，请检查支持的模式"
        ''}";
        "${modifier}+Shift+o" = "exec ghostty -e sh -c '${pkgs.sway}/bin/swaymsg -t get_outputs; read -p \"按回车关闭...\"'";
      };
      
      # 输出设置 (显示器配置) - 针对 Hyper-V 优化
      # 注意：先不在这里设置 mode，让 Sway 自动检测
      output = {
        "*" = {
          scale = "1";
          # mode 将在 extraConfig 中动态设置
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
      
      # 针对 Hyper-V 的优化
      output * adaptive_sync off
      
      # 动态设置分辨率 - 使用脚本查找并设置最高分辨率
      exec_always ${pkgs.writeShellScript "sway-resolution.sh" ''
        #!/usr/bin/env bash
        # 等待显示输出稳定
        sleep 2
        
        # 获取所有输出设备
        OUTPUTS=$(${pkgs.sway}/bin/swaymsg -t get_outputs -r | ${pkgs.jq}/bin/jq -r '.[].name')
        
        for OUTPUT in $OUTPUTS; do
          echo "正在为 $OUTPUT 设置分辨率..."
          
          # 尝试设置 2560x1440
          if ${pkgs.sway}/bin/swaymsg output "$OUTPUT" mode 2560x1440@60Hz 2>/dev/null; then
            echo "成功设置 $OUTPUT 为 2560x1440@60Hz"
          # 尝试不带刷新率
          elif ${pkgs.sway}/bin/swaymsg output "$OUTPUT" mode 2560x1440 2>/dev/null; then
            echo "成功设置 $OUTPUT 为 2560x1440"
          # 尝试 1920x1080 作为备选
          elif ${pkgs.sway}/bin/swaymsg output "$OUTPUT" mode 1920x1080 2>/dev/null; then
            echo "成功设置 $OUTPUT 为 1920x1080"
          else
            # 获取该输出支持的最高分辨率并设置
            BEST_MODE=$(${pkgs.sway}/bin/swaymsg -t get_outputs -r | \
              ${pkgs.jq}/bin/jq -r ".[] | select(.name == \"$OUTPUT\") | .modes | max_by(.width * .height) | \"\(.width)x\(.height)@\(.refresh / 1000)Hz\"")
            
            if [ -n "$BEST_MODE" ]; then
              ${pkgs.sway}/bin/swaymsg output "$OUTPUT" mode "$BEST_MODE"
              echo "设置 $OUTPUT 为最佳模式: $BEST_MODE"
            fi
          fi
          
          # 确保缩放为 1
          ${pkgs.sway}/bin/swaymsg output "$OUTPUT" scale 1
        done
        
        # 输出当前设置以便调试
        ${pkgs.sway}/bin/swaymsg -t get_outputs
      ''}
    '';
  };

  # 设置光标和 DPI - 针对高分辨率优化
  xresources.properties = {
    "Xcursor.size" = 24;  # 增大光标
    "Xft.dpi" = 96;       # 标准 DPI，不缩放
  };
}