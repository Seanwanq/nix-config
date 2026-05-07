{ ... }:
let
  font = "JetBrainsMono Nerd Font";
in
{
  programs.ghostty = {
    enable = true;
    package = null; # macOS 通过 brew cask 安装，不从 nixpkgs 安装（nixpkgs 的包只支持 Linux）
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
        PATH = "$HOME/.local/bin:$PATH";
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
