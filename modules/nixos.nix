{ pkgs, lib, username, ... }:
{
  # ============================================================================
  # 用户
  # ============================================================================
  users.users.${username} = {
    isNormalUser = true;
    description = username;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;

  # ============================================================================
  # Nix 设置
  # ============================================================================
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "root" username ];
    auto-optimise-store = true;
  };

  nix.gc = {
    automatic = lib.mkDefault true;
    dates = lib.mkDefault "weekly";
    options = lib.mkDefault "--delete-older-than 30d";
  };

  nixpkgs.config.allowUnfree = true;

  # 让 rustup / uv / VS Code Remote 等下载的动态链接程序可以运行
  programs.nix-ld.enable = true;

  # ============================================================================
  # 地区
  # ============================================================================
  time.timeZone = "Europe/Amsterdam";
  i18n.defaultLocale = "en_US.UTF-8";

  # ============================================================================
  # SSH（仅密钥登录）
  # ============================================================================
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  environment.systemPackages = with pkgs; [
    git
    neovim
    curl
    wget
  ];
}
