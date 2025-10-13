{pkgs, ...}: {
  programs = {
    sway = {
        enable = true;
        xwayland.enable = true;
        extraPackages = with pkgs; [
            brightnessctl foot grim pulseaudio swayidle swaylock wmenu
        ];
        extraSessionCommands = ''
            # SDL:
            export SDL_VIDEODRIVER=wayland
            # QT (needs qt5.qtwayland in systemPackages):
            export QT_QPA_PLATFORM=wayland-egl
            export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
            # Fix for some Java AWT applications (e.g. Android Studio),
            # use this if they aren't displayed properly:
            export _JAVA_AWT_WM_NONREPARENTING=1
        '';
    };
    waybar.enable = true;

  };

  # thunar file manager(part of xfce) related options
  programs.thunar.plugins = with pkgs.xfce; [
    thunar-archive-plugin
    thunar-volman
  ];
  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.tumbler.enable = true; # Thumbnail support for images
}