# NixOS on WSL2（NixOS-WSL），图形程序通过 WSLg 显示，GPU 走 Windows 驱动
{ pkgs, inputs, username, ... }:
{
  imports = [
    inputs.nixos-wsl.nixosModules.default
    ../../modules/nixos.nix
  ];

  wsl = {
    enable = true;
    defaultUser = username;
    # 使用 Windows 宿主机的 GPU 驱动（Mesa d3d12），为 WSLg 中的程序提供硬件加速
    useWindowsDriver = true;
    # 在 Windows 开始菜单中生成 GUI 程序的快捷方式
    startMenuLaunchers = true;
  };

  nixpkgs.hostPlatform = "x86_64-linux";
  networking.hostName = "nixos-wsl";

  # WSLg 中的图形程序需要字体
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    nerd-fonts.jetbrains-mono
  ];

  system.stateVersion = "26.05";
}
