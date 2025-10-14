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

  # 内核参数
  boot.kernelParams = [
    # Hyper-V 显示相关参数 - 使用通用视频参数
    "video=2560x1440"
    # 或者完全让系统自动检测
    # "quiet"
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
    enable = true;
    # 启用自动分辨率检测 - 2560x1440 优先
    screenSection = ''
      Option "metamodes" "2560x1440"
    '';
    # 添加显示驱动配置
    videoDrivers = [ "modesetting" "fbdev" ];
  };

  # 添加启动后自动设置分辨率的服务
  systemd.services.set-resolution = {
    description = "Set display resolution to 2560x1440";
    after = [ "graphical-session.target" ];
    wantedBy = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "oneshot";
      User = "sean";
      Environment = "DISPLAY=:0";
      ExecStart = "${pkgs.xorg.xrandr}/bin/xrandr --output Virtual-1 --mode 2560x1440 || ${pkgs.xorg.xrandr}/bin/xrandr --output default --mode 2560x1440 || true";
    };
  };
  
  # 启用 Hyper-V 集成服务
  virtualisation.hypervGuest = {
    enable = true;
    # videoMode 选项已被弃用，移除它
    # 视频模式现在通过标准工具或 Hyper-V VM 设置配置
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