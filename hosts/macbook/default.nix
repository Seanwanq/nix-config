{ pkgs, username, ... }:
let
  brewNoApiWrapper = pkgs.writeShellScriptBin "brew" ''
    export HOMEBREW_NO_INSTALL_FROM_API=1
    exec /opt/homebrew/bin/brew "$@"
  '';
in
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
    # nix-darwin runs brew bundle via sudo with a restricted environment.
    # Use a wrapper so this workaround always applies during activation.
    brewPrefix = "${brewNoApiWrapper}/bin";
    onActivation = {
      # Keep activation deterministic and avoid long waits during rebuild.
      autoUpdate = false;
      upgrade = true;
      # "uninstall" 会移除不在列表中的 cask，但不删除用户数据
      cleanup = "uninstall";
    };
    casks = [
      "fork"
      "ghostty"
      "visual-studio-code"
      "microsoft-edge"
      "clash-verge-rev"
      "utm"
      "microsoft-teams"
      "google-drive"
      "steam"
      "mos"
      "dotnet-sdk"
      "cursor"
    ];
  };

  # ============================================================================
  # Touch ID sudo
  # ============================================================================
  security.pam.services.sudo_local.touchIdAuth = true;

  # ============================================================================
  # macOS 系统设置
  # ============================================================================
  system.defaults = {
    dock.autohide = false;
    finder = {
      AppleShowAllExtensions = true;
      FXPreferredViewStyle = "clmv"; # Column view
    };
    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      # 关闭长按弹重音菜单，让 hjkl 等按键可持续重复输入
      ApplePressAndHoldEnabled = false;
      KeyRepeat = 2;
      InitialKeyRepeat = 15;
    };
  };
}
