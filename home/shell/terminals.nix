{ pkgs, ... }:

# terminals

let
  font = "JetBrainsMono Nerd Font";
in
{
  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "${font}:size=24";
        dpi-aware = "yes";
      };
      
      colors = {
        # Catppuccin Mocha 主题
        background = "1e1e2e";
        foreground = "cdd6f4";
        
        regular0 = "45475a";  # black
        regular1 = "f38ba8";  # red
        regular2 = "a6e3a1";  # green
        regular3 = "f9e2af";  # yellow
        regular4 = "89b4fa";  # blue
        regular5 = "f5c2e7";  # magenta
        regular6 = "94e2d5";  # cyan
        regular7 = "bac2de";  # white
        
        bright0 = "585b70";   # bright black
        bright1 = "f38ba8";   # bright red
        bright2 = "a6e3a1";   # bright green
        bright3 = "f9e2af";   # bright yellow
        bright4 = "89b4fa";   # bright blue
        bright5 = "f5c2e7";   # bright magenta
        bright6 = "94e2d5";   # bright cyan
        bright7 = "a6adc8";   # bright white
      };
    };
  };

  programs.ghostty = {
      enable = true;
      settings = {
        # 强制使用 X11 后端而不是 Wayland
        # 因为 Ghostty 的 Wayland 后端在 VirtualBox 下有问题
        gtk-adwaita = false;
        
        # 主题
        theme = "catppuccin-mocha";
        
        # 字体
        font-family = font;
        font-size = 11;
        
        # 其他基本设置
        window-decoration = true;
        confirm-close-surface = false;
      };
      
      themes = {
        catppuccin-mocha = {
    background = "1e1e2e";
    cursor-color = "f5e0dc";
    foreground = "cdd6f4";
    palette = [
      "0=#45475a"
      "1=#f38ba8"
      "2=#a6e3a1"
      "3=#f9e2af"
      "4=#89b4fa"
      "5=#f5c2e7"
      "6=#94e2d5"
      "7=#bac2de"
      "8=#585b70"
      "9=#f38ba8"
      "10=#a6e3a1"
      "11=#f9e2af"
      "12=#89b4fa"
      "13=#f5c2e7"
      "14=#94e2d5"
      "15=#a6adc8"
    ];
    selection-background = "353749";
    selection-foreground = "cdd6f4";
  };
      };
      enableZshIntegration = true;
    };
}