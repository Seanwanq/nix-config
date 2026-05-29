{ pkgs, lib, nixpkgs-unstable, ... }:
let
  font = "JetBrainsMono Nerd Font";
  pkgs-unstable = import nixpkgs-unstable {
    system = pkgs.system;
    config.allowUnfree = true;
  };
in
{
  programs.ghostty = {
    enable = true;
    package = pkgs-unstable.ghostty-bin; # macOS 通过 brew cask 安装，不从 nixpkgs 安装（nixpkgs 的包只支持 Linux）
    enableZshIntegration = true;
    settings = {
      # ── 外观 ──────────────────────────────────────────────────────────
      theme = "catppuccin-mocha";
      font-family = font;
      font-size = 13;
      font-thicken = true; # macOS 专属：让字体笔画更粗，屏幕上更清晰

      # ── macOS 专属功能 ────────────────────────────────────────────────
      # 检测到密码提示时自动启用 Secure Keyboard Input
      # 防止其他应用通过 Accessibility API 读取键盘输入（配合 Touch ID sudo 使用）
      macos-auto-secure-input = true;
      # 启用 Secure Input 时显示图标提示
      macos-secure-input-indication = true;
      # 将 Option 键作为 Alt 键，使 shell 快捷键（如 Alt+F/B 等）正常工作
      macos-option-as-alt = true;
      # 标题栏透明，背景色延伸到标题栏，视觉上更统一
      macos-titlebar-style = "transparent";

      # ── 通用设置 ──────────────────────────────────────────────────────
      window-decoration = true;
      confirm-close-surface = false;
      window-padding-x = 4;
      window-padding-y = 4;
      mouse-hide-while-typing = true;
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
  };

  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      shellAliases = {
        vpn-work = "sudo openconnect --user=siyuan.wang --authgroup=NDS-AnyConnect vpn.nds.global";
        z = "eza";
        f = "fastfetch";
      };
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" "sudo" ];
        theme = "robbyrussell";
      };
      sessionVariables = {
        PATH = "$HOME/.cargo/bin:$HOME/.local/bin:$PATH";
      };
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableZshIntegration = true;
    };

    skim = {
      enable = true;
      enableZshIntegration = true;
      defaultCommand = "rg --files --hidden";
    };
  };
}
