{pkgs, username, ...}: {
  # 启用 greetd 显示管理器
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        # 选项 1: 显示登录界面(需要输入密码)
        # --time: 显示时间
        # --remember: 记住上次登录的用户名
        # --remember-user-session: 记住用户选择的会话
        # --user-menu: 显示用户菜单(可以按 F2 切换用户)
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --remember-user-session --user-menu --cmd sway";
        
        # 选项 2: 自动登录(无需密码,直接进入 Sway)
        # command = "${pkgs.sway}/bin/sway";
        # user = username;
      };
    };
  };
  
  # 确保 greetd 使用正确的环境变量
  environment.etc."greetd/environments".text = ''
    sway
  '';

  programs = {
    sway = {
        enable = true;
        xwayland.enable = true;
        extraPackages = with pkgs; [
            # 基础工具
            brightnessctl foot grim slurp pulseaudio swayidle swaylock 
            # 应用启动器和菜单
            rofi-wayland
            # 状态栏
            waybar
            # 文件管理器
            thunar
            # GTK 支持
            gtk3 glib gsettings-desktop-schemas
            # 系统工具
            wl-clipboard
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
            
            # GTK/GDK 支持 Wayland,但允许回退到 X11
            # 不强制 GDK_BACKEND,让应用自己选择
            # export GDK_BACKEND=wayland
            export CLUTTER_BACKEND=wayland
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