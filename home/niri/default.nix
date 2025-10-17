{
  pkgs,
  config,
  ...
}: {
  home.file.".config/niri/config.kdl".source = ./config.kdl;

  # Environment variables for niri session
  home.sessionVariables = {
    # Wayland specific
    NIXOS_OZONE_WL = "1";  # Enable Wayland support for Electron apps (VSCode, etc.)
    MOZ_ENABLE_WAYLAND = "1";  # Firefox Wayland support
    
    # VSCode specific
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    
    # XDG settings
    XDG_CURRENT_DESKTOP = "niri";
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "niri";
  };

  # Services needed for niri
  services.gnome-keyring = {
    enable = true;
    components = [ "pkcs11" "secrets" "ssh" ];
  };

  # set cursor size and dpi for 4k monitor
  # 注释掉以避免与 sway 配置冲突
  # xresources.properties = {
  #   "Xcursor.size" = 16;
  #   "Xft.dpi" = 192;
  # };

  # 直接以 text 的方式，在 nix 配置文件中硬编码文件内容
  # home.file.".xxx".text = ''
  #     xxx
  # '';

}