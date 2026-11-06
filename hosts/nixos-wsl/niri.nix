# 在 WSLg 中以窗口方式嵌套运行 niri（winit 后端）
#
# niri 作为 WSLg 的一个 Wayland 客户端运行，GPU 可用时渲染经 Mesa d3d12 走 Windows 显卡，
# 否则自动退回 llvmpipe（CPU）。
# 嵌套运行时 niri 的 Mod 键是 Alt（Win 键会被 Windows 拦截）。
# 默认快捷键：Alt+T 终端（ghostty）、Alt+D 启动器（fuzzel）、Alt+Shift+E 退出。
# niri 配置与 ghostty 由 Home Manager 管理，见 home/linux/niri.nix。
{ pkgs, ... }:
let
  niri-desktop = pkgs.writeShellScriptBin "niri-desktop" ''
    # 让 Mesa 的 d3d12 驱动找到 libd3d12.so / libdxcore.so（WSL GPU）
    export LD_LIBRARY_PATH="/run/opengl-driver/lib''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
    export XCURSOR_THEME=Adwaita
    # 由 WSLg 提供 WAYLAND_DISPLAY；niri 检测到已有 Wayland 会话时自动使用窗口模式
    exec ${pkgs.niri}/bin/niri "$@"
  '';

  # 出现在 Windows 开始菜单（wsl.startMenuLaunchers）
  niri-desktop-item = pkgs.makeDesktopItem {
    name = "niri-desktop";
    desktopName = "Niri";
    comment = "niri 桌面（WSLg 窗口）";
    exec = "${niri-desktop}/bin/niri-desktop";
    categories = [ "System" ];
  };
in
{
  environment.systemPackages = with pkgs; [
    niri
    niri-desktop
    niri-desktop-item

    # niri 默认配置中用到的程序（终端 ghostty 由 Home Manager 安装）
    fuzzel             # Mod+D 启动器
    waybar             # 启动时运行的状态栏
    xwayland-satellite # X11 程序支持，niri 会自动启动
    adwaita-icon-theme # 光标主题
  ];
}
