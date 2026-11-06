# Hyper-V 虚拟机（第 2 代 / UEFI，Secure Boot 关闭），无图形界面
{ ... }:
{
  imports = [
    ../../modules/nixos.nix
    ./hardware-configuration.nix
  ];

  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 10;
    };
    efi.canTouchEfiVariables = true;
  };

  networking.hostName = "nixos-hv";

  # Hyper-V 集成服务（心跳、KVP 上报 IP、时间同步、关机等）
  virtualisation.hypervGuest.enable = true;

  system.stateVersion = "26.05";
}
