{ pkgs, ... }:

# terminals

let
  font = "JetBrainsMono Nerd Font";
in
{
  programs.alacritty = {
    enable = true;
    settings = {
      window.opacity = 0.95;
      window.dynamic_padding = true;
      window.padding = {
        x = 5;
        y = 5;
      };
      scrolling.history = 10000;

      font = {
        normal.family = font;
        bold.family = font;
        italic.family = font;
        size = 11;
      };

    };
  };

  programs.ghostty = {
      enable = true;
      settings = {
        # Wayland 相关设置
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