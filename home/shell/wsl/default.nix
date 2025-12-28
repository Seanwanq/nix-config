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
    ssh = "ssh.exe";
    ssh-add = "ssh-add.exe";
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
    # dotDir = "`\${config.xdg.configHome}/zsh`";
    initContent = ''
      # 额外的 zsh 配置
      export PATH="$HOME/.local/bin:$PATH"
    '';
  };

  # ============================================================================
  # 设置 zsh 为默认 shell (WSL 特定)
  # ============================================================================

  programs.zsh.sessionVariables = {};

  home.activation.setZshAsDefaultShell = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    # 获取 zsh 的完整路径
    ZSH_PATH="$HOME/.nix-profile/bin/zsh"
    
    # 检查 zsh 路径是否存在
    if [ ! -x "$ZSH_PATH" ]; then
      echo "⚠️  zsh 未找到在 $ZSH_PATH"
      exit 1
    fi
    
    # 获取当前用户和当前 shell
    CURRENT_USER=$(whoami)
    CURRENT_SHELL="$SHELL"
    
    echo "ℹ️  zsh 位置: $ZSH_PATH"
    echo "   当前 shell: $CURRENT_SHELL"
    
    # 第一步：在 ~/.bashrc 中配置启动时执行 zsh
    # 这是最可靠的方式，确保 WSL 启动时自动使用 zsh
    BASHRC_MARKER="# Auto-launch zsh from nix-config"
    if ! grep -q "$BASHRC_MARKER" "$HOME/.bashrc" 2>/dev/null; then
      echo "" >> "$HOME/.bashrc"
      echo "$BASHRC_MARKER" >> "$HOME/.bashrc"
      echo "if [ -x \"\$HOME/.nix-profile/bin/zsh\" ]; then" >> "$HOME/.bashrc"
      echo "  exec \"\$HOME/.nix-profile/bin/zsh\"" >> "$HOME/.bashrc"
      echo "fi" >> "$HOME/.bashrc"
      echo "✅ 已在 ~/.bashrc 中配置自动启动 zsh"
    fi
    
    # 第二步：尝试通过 usermod 改变系统默认 shell（如果有 sudo 权限）
    if [ "$CURRENT_SHELL" != "$ZSH_PATH" ]; then
      if sudo -n true 2>/dev/null; then
        sudo ${pkgs.shadow}/bin/usermod -s "$ZSH_PATH" "$CURRENT_USER" 2>&1 && \
          echo "✅ 已通过 usermod 设置系统默认 shell 为 zsh" || \
          echo "⚠️  usermod 设置失败，请手动运行: sudo usermod -s $ZSH_PATH $CURRENT_USER"
      else
        echo "ℹ️  如需设置系统默认 shell，请运行:"
        echo "   sudo usermod -s $ZSH_PATH $CURRENT_USER"
      fi
    else
      echo "✅ zsh 已是系统默认 shell"
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

