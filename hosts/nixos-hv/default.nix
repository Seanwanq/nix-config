# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running 'nixos-help').

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ../../modules/system.nix
      # ../../modules/i3.nix      # 切换到 sway
      # ../../modules/niri.nix
      ../../modules/sway.nix  # 使用 sway 窗口管理器

      ./hardware-configuration.nix
    ];

  # Bootloader - 使用 GRUB UEFI 模式适配 Hyper-V
  boot.loader = {
    grub = {
      enable = true;
      device = "nodev";  # UEFI 模式不需要指定设备
      efiSupport = true;  # 启用 EFI 支持
      useOSProber = true;
    };
    efi.canTouchEfiVariables = true;
  };

  # 内核参数 - 针对 Hyper-V 的显示优化
  boot.kernelParams = [
    # 强制启用 hyperv_fb 帧缓冲驱动
    "video=hyperv_fb:2560x1440"
    # 或者使用 simpledrm
    # "video=simpledrm:2560x1440"
  ];

  # 确保加载 Hyper-V 显示相关内核模块
  boot.kernelModules = [ "hyperv_fb" "hyperv_drm" ];
  # 可选：blacklist 可能冲突的驱动
  # boot.blacklistedKernelModules = [ "bochs_drm" ];

  networking.hostName = "nixos-hv"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  
  # 启用 Hyper-V 集成服务
  virtualisation.hypervGuest = {
    enable = true;
  };

  # 为 Wayland/Sway 设置环境变量
  environment.sessionVariables = {
    # 强制 Wayland 使用特定的后端
    WLR_BACKENDS = "drm";
    # 启用 DRM 日志以便调试
    WLR_DRM_NO_ATOMIC = "1";
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
#   services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}