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
      xdg-desktop-portal-gtk  # GTK 文件选择器
    ];
    config.common.default = "*";
  };

  # thunar file manager(part of xfce) related options
  programs.thunar.plugins = with pkgs.xfce; [
    thunar-archive-plugin
    thunar-volman
  ];
  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.tumbler.enable = true; # Thumbnail support for images
}