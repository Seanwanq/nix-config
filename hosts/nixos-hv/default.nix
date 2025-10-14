# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running 'nixos-help').

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ../../modules/system.nix
      ../../modules/i3.nix      # 使用 i3 窗口管理器
      # ../../modules/niri.nix
      # ../../modules/sway.nix  # 注释掉 sway

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

  # 内核参数
  boot.kernelParams = [
    # Hyper-V 显示相关参数 - 设置为 2560x1440
    "video=hyperv_fb:2560x1440"
    # 或者让系统自动检测最佳分辨率
    # "video=2560x1440"
  ];

  networking.hostName = "nixos-hv"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Hyper-V 显示优化配置
  services.xserver = {
    # 启用自动分辨率检测 - 2560x1440 优先
    resolutions = [
      { x = 2560; y = 1440; }  # 默认首选分辨率
      { x = 1920; y = 1080; }
      { x = 1680; y = 1050; }
      { x = 1600; y = 1200; }
      { x = 1440; y = 900; }
      { x = 1366; y = 768; }
      { x = 1280; y = 1024; }
      { x = 1024; y = 768; }
    ];
  };

  # Hyper-V 特定的内核模块和服务
  boot.kernelModules = [ "hyperv_fb" "hv_balloon" "hv_utils" "hv_storvsc" "hv_netvsc" ];
  
  # 启用 Hyper-V 集成服务
  virtualisation.hypervGuest = {
    enable = true;
    videoMode = "2560x1440x32";  # 设置为 2560x1440
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