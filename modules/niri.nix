{pkgs, ...}: {
  programs.niri.enable = true;

  # niri wayland packages
  environment.systemPackages = with pkgs; [
    swaylock     # screen locker
    swayidle     # idle management daemon
    grim         # screenshot tool
    slurp        # region selector for screenshots
    wl-clipboard # clipboard utilities
  ];

  # XDG Desktop Portal - 必须用于 Chrome 等应用的文件选择器和屏幕共享
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk   # GTK 文件选择器
      xdg-desktop-portal-gnome # GNOME portal，提供屏幕录制/截图支持
    ];
    # 明确配置各个接口使用的 portal 实现
    config.common = {
      default = "gtk";  # 默认使用 GTK portal
      "org.freedesktop.impl.portal.ScreenCast" = "gnome";  # 屏幕录制使用 GNOME
      "org.freedesktop.impl.portal.Screenshot" = "gnome";  # 截图使用 GNOME
    };
  };

  # thunar file manager(part of xfce) related options
  programs.thunar.plugins = with pkgs.xfce; [
    thunar-archive-plugin
    thunar-volman
  ];
  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.tumbler.enable = true; # Thumbnail support for images
}