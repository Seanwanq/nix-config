# niri 用户配置 + ghostty 终端（目前只在 WSL 中使用，见 users/sean/home-wsl.nix）
{ pkgs, lib, ... }:
let
  # 以 niri 自带的默认配置为基础，把终端从 alacritty 换成 ghostty（Mod+T）
  niriConfig = builtins.replaceStrings [ "alacritty" ] [ "ghostty" ]
    (builtins.readFile "${pkgs.niri.src}/resources/default-config.kdl");
in
{
  xdg.configFile."niri/config.kdl".text = niriConfig;

  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      theme = "Horizon";
      font-family = "JetBrainsMono Nerd Font";
      font-size = 13;
      window-decoration = false; # 由 niri 管理窗口
      confirm-close-surface = false;
      window-padding-x = 4;
      window-padding-y = 4;
      mouse-hide-while-typing = true;
    };
  };
}
