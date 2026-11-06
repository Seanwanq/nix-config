# Hyper-V 虚拟机（第 2 代 / UEFI，Secure Boot 关闭）

{ pkgs, inputs, ... }:

{
  imports =
    [
      ../../modules/system.nix
      ../../modules/niri.nix      # 使用 niri 窗口管理器（Hyper-V 下为软件渲染）
      ../../modules/gnome.nix     # GNOME 作为备用会话，GDM 登录时可选择
      # ../../modules/sway.nix    # 可切换到 sway

      ./hardware-configuration.nix
    ];

  # Bootloader - systemd-boot（第 2 代虚拟机为 UEFI）
  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 10;
    };
    efi.canTouchEfiVariables = true;
  };

  # hyperv_drm 的默认分辨率较小，这里固定为 1080p
  boot.kernelParams = [ "video=Virtual-1:1920x1080" ];

  networking.hostName = "nixos-hv";
  networking.networkmanager.enable = true;

  # Hyper-V 集成服务（心跳、KVP 上报 IP、时间同步、关机等）
  virtualisation.hypervGuest.enable = true;

  environment.systemPackages = [
    inputs.noctalia.packages.${pkgs.system}.default  # Noctalia shell
  ];

  # GNOME Keyring - VSCode 和其他应用需要用于密钥管理
  services.gnome.gnome-keyring.enable = true;

  # Wayland 和 Electron 应用环境变量 (VSCode 等)
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  system.stateVersion = "26.05"; # Did you read the comment?
}
