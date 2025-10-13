{
  pkgs,
  config,
  lib,
  ...
}: {
  wayland.windowManager.sway = {
    enable = true;
    config = {
      terminal = "foot";  # 暂时使用 foot,因为 ghostty 在 VirtualBox 下有问题
      modifier = "Mod4"; # Mod4 = Super/Windows key
      
      # Sway 启动时执行的命令
      startup = [
        # 启动 VBoxClient 服务以支持剪贴板共享
        { command = "VBoxClient --clipboard"; }
      ];
      
      # 基本快捷键
      keybindings = let
        modifier = config.wayland.windowManager.sway.config.modifier;
      in lib.mkOptionDefault {
        # 启动终端
        "${modifier}+Return" = "exec foot";
        
        # 应用启动器 (使用 wmenu,因为它在你的 extraPackages 中)
        "${modifier}+d" = "exec wmenu-run";
      };
      
      # 输出设置 (显示器配置)
      output = {
        "*" = {
          scale = "2";  # 2倍缩放
        };
      };
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