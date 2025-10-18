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
  
  # Fcitx5 自定义配置文件
  
  # 主题和界面配置
  home.file.".config/fcitx5/conf/classicui.conf".text = ''
    # Fcitx Theme
    Theme=Nord-Dark
    # Font
    Font="Sans 10"
    # 垂直候选列表（更易于阅读）
    Vertical Candidate List=False
  '';

  # 拼音输入法配置 - 提高智能程度
  home.file.".config/fcitx5/conf/pinyin.conf".text = ''
    # Page size
    PageSize=9
    # Enable Cloud Pinyin
    CloudPinyinEnabled=True
    # Cloud Pinyin Index
    CloudPinyinIndex=2
    # Enable Prediction
    Prediction=True
    # Prediction Size
    PredictionSize=10
    # Enable Spell
    SpellEnabled=True
    # Show complete pinyin in preedit
    PinyinInPreedit=True

    [Fuzzy]
    # ue -> ve
    VE_UE=True
    # Common Typo
    NG_GN=True
    # an <-> ang
    AN_ANG=True
    # en <-> eng
    EN_ENG=True
    # ian <-> iang
    IAN_IANG=True
    # in <-> ing
    IN_ING=True
    # c <-> ch
    C_CH=True
    # s <-> sh
    S_SH=True
    # z <-> zh
    Z_ZH=True
  '';

  # 全局配置
  home.file.".config/fcitx5/config".text = ''
    [Hotkey]
    # Enumerate when press trigger key repeatedly
    EnumerateWithTriggerKeys=True
    # Enumerate Input Method Forward
    EnumerateForwardKeys=
    # Enumerate Input Method Backward
    EnumerateBackwardKeys=
    # Skip first input method while enumerating
    EnumerateSkipFirst=False
    # Time limit in milliseconds for triggering modifier key shortcuts
    ModifierOnlyKeyTimeout=250

    [Hotkey/TriggerKeys]
    0=Control+space

    [Hotkey/AltTriggerKeys]
    # 中英文切换键 - 使用左 Ctrl 而不是默认的 Shift_L
    0=Control_L

    [Hotkey/EnumerateGroupForwardKeys]
    0=Super+space

    [Hotkey/EnumerateGroupBackwardKeys]
    0=Shift+Super+space

    [Behavior]
    # Active By Default
    ActiveByDefault=False
    # Reset state on Focus In
    resetStateWhenFocusIn=No
    # Share Input State
    ShareInputState=No
    # Show preedit in application
    PreeditEnabledByDefault=True
    # Show Input Method Information when switch input method
    ShowInputMethodInformation=True
    # Show Input Method Information when changing focus
    showInputMethodInformationWhenFocusIn=False
    # Show compact input method information
    CompactInputMethodInformation=True
    # Show first input method information
    ShowFirstInputMethodInformation=True
    # Default page size
    DefaultPageSize=5
    # Override Xkb Option
    OverrideXkbOption=False
    # Custom Xkb Option
    CustomXkbOption=
    # Preload input method to be used by default
    PreloadInputMethod=True
    # Allow input method in the password field
    AllowInputMethodForPassword=False
    # Show preedit text when typing password
    ShowPreeditForPassword=False
    # Interval of saving user data in minutes
    AutoSavePeriod=30
  '';
}
