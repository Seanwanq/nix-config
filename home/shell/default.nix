{ config, ... }:
let
  d = config.xdg.dataHome;
  c = config.xdg.configHome;
  cache = config.xdg.cacheHome;
in
{
  imports = [
    ./common.nix
    ./terminals.nix
  ];

  # add environment variables
  home.sessionVariables = {
    # clean up ~
    LESSHISTFILE = cache + "/less/history";
    LESSKEY = c + "/less/lesskey";
    WINEPREFIX = d + "/wine";

    # set default applications
    EDITOR = "nvim";
    BROWSER = "zen";
    TERMINAL = "ghostty"; # 现在可以使用 ghostty了,因为在 X11 下工作良好

    # enable scrolling in git diff
    DELTA_PAGER = "less -R";

    MANPAGER = "sh -c 'col -bx | bat -l man -p'";

    # X11 环境变量(移除 Wayland 特定的)
    # MOZ_ENABLE_WAYLAND = "1";  # 注释掉,让 Firefox 使用 X11
    # NIXOS_OZONE_WL = "1";      # 注释掉,让 Electron 应用使用 X11
  };

  home.shellAliases = {
    k = "kubectl";
    f = "fastfetch";
    z = "eza";
  };
}
