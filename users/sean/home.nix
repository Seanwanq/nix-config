{pkgs, ...}: {
  ##################################################################################################################
  #
  # All Sean's Home Manager Configuration
  #
  ##################################################################################################################

  imports = [
    ../../home/core.nix

    # ../../home/fcitx5
    ../../home/i3
    ../../home/programs
    ../../home/rofi
    ../../home/shell
  ];

  programs.git = {
    userName = "Seanwanq";
    userEmail = "seanwang313@outlook.com";
  };
}