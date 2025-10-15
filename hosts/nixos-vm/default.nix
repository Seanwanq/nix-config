# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ../../modules/system.nix
      ../../modules/i3.nix      # 使用 i3 窗口管理器
      # ../../modules/niri.nix
      # ../../modules/sway.nix    # 启用 sway

      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader = {
    grub = {
        enable = true;
        device = "/dev/sda";
        useOSProber = true;
        # do not need to keep too much generations
        configurationLimit = 10;
        
        # GRUB 分辨率设置
        # 常见的 VESA 模式分辨率（BIOS 模式支持）:
        # 1024x768, 1280x720, 1280x1024, 1920x1080
        gfxmodeEfi = "auto";
        gfxmodeBios = "auto";
        
        # 额外的 GRUB 配置
        extraConfig = ''
          # 设置图形模式，auto 让 GRUB 自动选择最佳分辨率
          # 或者手动指定: set gfxmode=1920x1080,1280x1024,1024x768,auto
          set gfxmode=auto
          set gfxpayload=keep
          
          # 启用 VESA BIOS 扩展支持
          insmod vbe
          insmod vga
          
          # 加载视频驱动
          insmod all_video
        '';
    };
  };

  # 内核参数 - 设置启动时的视频模式
  boot.kernelParams = [
    "video=2560x1440"  # 启动时的分辨率
  ];

  networking.hostName = "nixos-vm"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;



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
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
