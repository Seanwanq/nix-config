{ config, pkgs, lib, ... }:

{
  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
    
    matchBlocks = {
      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/GitHub 2025";
        identitiesOnly = true;
      };
      
      # Default configuration for all other hosts
      "*" = {
        forwardAgent = false;
        compression = false;
        serverAliveInterval = 0;
        serverAliveCountMax = 3;
        hashKnownHosts = false;
        controlMaster = "no";
        controlPath = "~/.ssh/master-%r@%n:%p";
        controlPersist = "no";
      };
    };
  };

  # SSH Agent service
  services.ssh-agent = {
    enable = true;
  };

  # Auto-add SSH keys on login
  home.sessionVariables = {
    SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/ssh-agent";
  };

  # Shell initialization to add keys
  programs.zsh.initExtra = lib.mkAfter ''
    # Add SSH keys to agent if not already added
    if [ -n "$SSH_AUTH_SOCK" ] && [ -f ~/.ssh/"GitHub 2025" ]; then
      ssh-add -l | grep -q "GitHub 2025" || ssh-add ~/.ssh/"GitHub 2025" 2>/dev/null
    fi
  '';
}