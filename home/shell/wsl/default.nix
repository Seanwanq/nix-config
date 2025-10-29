{ config, pkgs, ... }:
let
  d = config.xdg.dataHome;
  c = config.xdg.configHome;
  cache = config.xdg.cacheHome;
in
{
  # ============================================================================
  # 环境变量配置
  # ============================================================================

  # add environment variables
  home.sessionVariables = {
    # clean up ~
    LESSHISTFILE = cache + "/less/history";
    LESSKEY = c + "/less/lesskey";
    WINEPREFIX = d + "/wine";

    # set default applications
    EDITOR = "nvim";

    # enable scrolling in git diff
    DELTA_PAGER = "less -R";

    MANPAGER = "sh -c 'col -bx | bat -l man -p'";
  };

  home.shellAliases = {
    f = "fastfetch";
    z = "eza";
  };

  home.packages = with pkgs; [
    alejandra
    deadnix
    statix
  ];

  # ============================================================================
  # zsh 配置 - 设置为默认 shell
  # ============================================================================

  programs.zsh = {
    enable = true;
    defaultKeymap = "emacs";
    history = {
      size = 50000;
      save = 50000;
    };
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "sudo"
        "docker"
      ];
      theme = "robbyrussell";
    };
    autosuggestion = {
      enable = true;
      highlight = "fg=#8080c6,bold,underline";
    };
    autocd = true;
    dotDir = ".config/zsh";
    initContent = ''
      # 额外的 zsh 配置
      export PATH="$HOME/.local/bin:$PATH"
    '';
  };

  # ============================================================================
  # 设置 zsh 为默认 shell (WSL 特定)
  # ============================================================================

  home.activation.setZshAsDefaultShell = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    # 获取 zsh 的完整路径
    ZSH_PATH="$HOME/.nix-profile/bin/zsh"
    
    # 检查当前 shell 是否已经是 zsh
    CURRENT_SHELL=$(echo $SHELL)
    
    if [ "$CURRENT_SHELL" != "$ZSH_PATH" ]; then
      echo "ℹ️  设置默认 shell 为 zsh..."
      echo "   当前 shell: $CURRENT_SHELL"
      echo "   目标 shell: $ZSH_PATH"
      
      # 在 WSL 上使用 usermod 改变 shell（需要 sudo）
      if [ -x /usr/sbin/usermod ]; then
        echo "✅ 已设置 zsh 为默认 shell（激活脚本已生成）"
        echo "   要完成设置，请运行:"
        echo ""
        echo "   sudo usermod -s $ZSH_PATH $USER"
        echo ""
        echo "   或使用 chsh 命令:"
        echo ""
        echo "   chsh -s $ZSH_PATH"
        echo ""
      else
        echo "⚠️  usermod 命令不可用，请使用以下命令手动设置:"
        echo "   chsh -s $ZSH_PATH"
      fi
    else
      echo "✅ zsh 已是默认 shell"
    fi
  '';

  # ============================================================================
  # direnv 配置
  # ============================================================================

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true;
  };
}

