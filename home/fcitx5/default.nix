{ config, pkgs, ... }:
{
  # Fcitx5 configuration for Chinese Pinyin input
  # This provides home-manager level configuration
  # Note: The main i18n.inputMethod configuration should be in your system configuration
  
  # You can customize fcitx5 settings by creating files in ~/.config/fcitx5
  # For example:
  # ~/.config/fcitx5/conf/classicui.conf - for UI theme and font settings
  # ~/.config/fcitx5/profile - for input method settings
  
  home.packages = with pkgs; [
    # fcitx5 GUI configuration tool
    libsForQt5.fcitx5-qt
    fcitx5-configtool
  ];
  
  # Optional: Create custom configuration files
  # Uncomment and customize as needed
  home.file.".config/fcitx5/conf/classicui.conf".text = ''
    # Fcitx Theme
    Theme=Nord-Dark
    # Font
    Font="Sans 10"
  '';
}
