{ pkgs, username, ... }:
{
  nixpkgs.hostPlatform = "aarch64-darwin";

  system.stateVersion = 6;
  system.primaryUser = "siyuan";

  # ============================================================================
  # 用户
  # ============================================================================
  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
  };

  # ============================================================================
  # Nix 设置
  # 将当前用户加入 trusted-users，解决 substituter 权限警告
  # ============================================================================
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "root" username ];
  };

  # ============================================================================
  # Homebrew — 管理 GUI 应用（Cask）
  # ============================================================================
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      # "uninstall" 会移除不在列表中的 cask，但不删除用户数据
      cleanup = "uninstall";
    };
    casks = [
      "fork"
    ];
  };

  # ============================================================================
  # macOS 系统设置
  # ============================================================================
  system.defaults = {
    dock.autohide = true;
    finder = {
      AppleShowAllExtensions = true;
      FXPreferredViewStyle = "clmv"; # Column view
    };
    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      KeyRepeat = 2;
      InitialKeyRepeat = 15;
    };
  };
}
