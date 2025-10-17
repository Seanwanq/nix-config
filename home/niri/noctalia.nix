{
  pkgs,
  config,
  ...
}: {
  # Noctalia shell configuration
  programs.noctalia-shell = {
    enable = true;
    
    # Basic settings for Noctalia
    settings = {
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
              id = "ScreenRecorder";
            }
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
    };
  };
}
