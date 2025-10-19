{
  pkgs,
  config,
  inputs,
  ...
}: {
  # Install quickshell package
  home.packages = [
    inputs.quickshell.packages.${pkgs.system}.default
  ];

  # Noctalia shell configuration
  programs.noctalia-shell = {
    enable = true;
    
    # Basic settings for Noctalia
    settings = {
      setupCompleted = true;  # Disable tutor on startup
      bar = {
        position = "top";
        density = "default";
        showCapsule = true;
        widgets = {
          left = [
            {
              id = "SidePanelToggle";
              useDistroLogo = true;
            }
            {
              id = "ActiveWindow";
            }
            {
              id = "MediaMini";
            }
          ];
          center = [
            {
              id = "Workspace";
              hideUnoccupied = false;
              labelMode = "none";
            }
          ];
          right = [
            {
              id = "Tray";
            }
            {
              id = "NotificationHistory";
            }
            {
              id = "Battery";
              alwaysShowPercentage = true;
              warningThreshold = 20;
            }
            {
              id = "Volume";
            }
            {
              id = "Brightness";
            }
            {
              id = "WiFi";
            }
            {
              id = "Clock";
              formatHorizontal = "HH:mm";
              formatVertical = "HH mm";
              useMonospacedFont = false;
            }
            {
              id = "SessionMenu";
            }
          ];
        };
      };
      general = {};
      appLauncher = {
        enableClipboardHistory = true;
      };
      location = {
        name = "Utrecht, The Netherlands";
        monthBeforeDay = true;
      };
      notifications = {
        alwaysOnTop = true;
      };
      colorSchemes = {
        predefinedScheme = "Dracula";
        darkMode = true;
      };
      templates = {
        gtk = true;
        qt = true;
        kcolorscheme = true;
        # ghostty = true;
        enableUserTemplates = true;
      };
      nightLight = {
        enabled = true;
      };
      battery = {
        # 充电模式: 0 = Disabled, 1 = Full (100%), 2 = Balanced (80%), 3 = Lifespan (60%)
        # 设置为 2 (Balanced) 保护电池，充到 80% 停止
        chargingMode = 2;
      };
    };
  };
}
