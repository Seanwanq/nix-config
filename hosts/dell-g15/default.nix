# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running 'nixos-help').

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
  ../../modules/system.nix
  ../../modules/power-management.nix  # 笔记本电源管理
  ../../modules/tpm-luks.nix          # TPM 2.0 自动解锁 LUKS
  # ../../modules/i3.nix      # 切换到 niri
  ../../modules/niri.nix      # 使用 niri 窗口管理器
  ../../modules/gnome.nix     # GNOME 桌面环境
  # ../../modules/sway.nix    # 可切换到 sway

      ./hardware-configuration.nix
    ];

  # Bootloader - 使用 systemd-boot (适合现代 UEFI 笔记本)
  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 10;  # 保留最近 10 个系统配置
    };
    efi.canTouchEfiVariables = true;
  };

  networking.hostName = "dell-g15"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # 背光控制
  programs.light.enable = true;

  # 蓝牙支持
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;

  # 显卡配置 - Intel Iris Xe + NVIDIA RTX 3060 Mobile
  # 启用 Intel 硬件加速和 VA-API 支持
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver  # LIBVA_DRIVER_NAME=iHD (现代 Intel GPU，Iris Xe)
      intel-media-sdk     # Intel Media SDK (QuickSync 硬件编码支持)
      vpl-gpu-rt    # OneVPL runtime for Intel GPU (现代 QuickSync API)
      vaapiIntel          # LIBVA_DRIVER_NAME=i965 (旧 Intel GPU)
      vaapiVdpau
      libvdpau-va-gl
    ];
  };

  # 笔记本专用工具包
  environment.systemPackages = with pkgs; [
    networkmanagerapplet  # NetworkManager GUI 小程序
    inputs.noctalia.packages.${pkgs.system}.default  # Noctalia shell
  ];

  # GNOME Keyring - VSCode 和其他应用需要用于密钥管理
  services.gnome.gnome-keyring.enable = true;

  # Wayland 和 Electron 应用环境变量 (VSCode 等)
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";          # 启用 Wayland 支持 (Electron 应用如 VSCode)
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
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
  # services.openssh.enable = true;

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
  system.stateVersion = "25.11"; # Did you read the comment?

}
