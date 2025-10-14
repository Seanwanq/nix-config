{
  pkgs,
  config,
  ...
}: {
  home.file.".config/niri/config.kdl".source = ./config.kdl;


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