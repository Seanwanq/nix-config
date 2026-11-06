# WSL（非 NixOS，独立 Home Manager）专用设置
{ config, pkgs, ... }:
{
  # 使用 Windows 侧的 ssh（1Password SSH agent）
  programs.zsh.shellAliases = {
    ssh = "ssh.exe";
    ssh-add = "ssh-add.exe";
  };

  # 非 NixOS 系统无法通过 users.users 设置登录 shell，这里改为由 bash 启动 zsh
  home.activation.launchZshFromBash = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    MARKER="# Auto-launch zsh from nix-config"
    if ! grep -q "$MARKER" "$HOME/.bashrc" 2>/dev/null; then
      {
        echo ""
        echo "$MARKER"
        echo 'if [ -x "$HOME/.nix-profile/bin/zsh" ]; then exec "$HOME/.nix-profile/bin/zsh"; fi'
      } >> "$HOME/.bashrc"
    fi
  '';
}
