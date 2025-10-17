{ config, pkgs, lib, ... }:

{
  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
    
    matchBlocks = {
      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = "\"~/.ssh/GitHub 2025\"";
        identitiesOnly = true;
      };
    };
  };

  # SSH Agent service
  services.ssh-agent = {
    enable = true;
  };

  # Shell initialization to add keys
  programs.zsh.initExtra = lib.mkAfter ''
    # Add SSH keys to agent if not already added
    if [ -n "$SSH_AUTH_SOCK" ] && [ -f ~/.ssh/"GitHub 2025" ]; then
      ssh-add -l | grep -q "GitHub 2025" || ssh-add ~/.ssh/"GitHub 2025" 2>/dev/null
    fi
  '';
}