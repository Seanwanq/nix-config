# WSL 专用的 Home Manager 设置
{ ... }:
{
  # 使用 Windows 侧的 ssh（1Password SSH agent），WSL 内无需另配密钥
  programs.zsh.shellAliases = {
    ssh = "ssh.exe";
    ssh-add = "ssh-add.exe";
  };

  programs.git.settings.core.sshCommand = "ssh.exe";
}
