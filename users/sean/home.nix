{pkgs, ...}: {
  ##################################################################################################################
  #
  # All Sean's Home Manager Configuration
  #
  ##################################################################################################################

  imports = [
    ../../home/core.nix

    # ../../home/fcitx5
    ../../home/i3        # VirtualBox 中使用 i3
    # ../../home/niri
    ../../home/nvim
    # ../../home/sway    # VirtualBox 中不使用 sway
    ../../home/programs
    ../../home/rofi
    ../../home/shell
    ../../home/rclone
  ];

  programs.git = {
    userName = "Seanwanq";
    userEmail = "seanwang313@outlook.com";
  };
}