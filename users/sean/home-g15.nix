{pkgs, ...}: {
  ##################################################################################################################
  #
  # Sean's Home Manager Configuration for Hyper-V (Sway + niri)
  #
  ##################################################################################################################

  imports = [
    ../../home/core.nix

    # ../../home/fcitx5
    # ../../home/i3        # 在 Hyper-V 中不使用 i3
    ../../home/niri        # 启用 niri
    ../../home/nvim
    # ../../home/sway        # Hyper-V 中使用 sway
    ../../home/programs
    ../../home/rofi
    ../../home/shell
  ];

  programs.git = {
    userName = "Seanwanq";
    userEmail = "seanwang313@outlook.com";
  };
}