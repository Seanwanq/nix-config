{pkgs, ...}: {
  ##################################################################################################################
  #
  # All Sean's Home Manager Configuration
  #
  ##################################################################################################################

  imports = [
    ../../home/core.nix

    # ../../home/fcitx5
    ../../home/i3        # 启用 i3 配置
    # ../../home/niri
    ../../home/nvim
    # ../../home/sway    # 注释掉 sway 配置
    ../../home/programs
    ../../home/rofi
    ../../home/shell
  ];

  programs.git = {
    userName = "Seanwanq";
    userEmail = "seanwang313@outlook.com";
  };
}