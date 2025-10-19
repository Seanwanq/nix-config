{
  pkgs,
  config,
  inputs,
  ...
}: let
  # Safe brightness control script
  brightness-control = pkgs.writeShellScriptBin "brightness-control" ''
    #!/usr/bin/env bash
    # Safe brightness control script
    # Prevents brightness from going below a minimum threshold
    
    MIN_BRIGHTNESS=5  # Minimum brightness percentage (5%)
    
    case "$1" in
      up)
        ${pkgs.brightnessctl}/bin/brightnessctl set +5%
        ;;
      down)
        # Get current brightness percentage
        current=$(${pkgs.brightnessctl}/bin/brightnessctl get)
        max=$(${pkgs.brightnessctl}/bin/brightnessctl max)
        current_percent=$((current * 100 / max))
        
        # Only decrease if we're above the minimum
        if [ "$current_percent" -gt "$MIN_BRIGHTNESS" ]; then
          ${pkgs.brightnessctl}/bin/brightnessctl set 5%-
          
          # Double check we didn't go below minimum
          new_current=$(${pkgs.brightnessctl}/bin/brightnessctl get)
          new_percent=$((new_current * 100 / max))
          
          if [ "$new_percent" -lt "$MIN_BRIGHTNESS" ]; then
            ${pkgs.brightnessctl}/bin/brightnessctl set "''${MIN_BRIGHTNESS}%"
          fi
        else
          # Already at or below minimum, set to minimum
          ${pkgs.brightnessctl}/bin/brightnessctl set "''${MIN_BRIGHTNESS}%"
        fi
        ;;
      *)
        echo "Usage: $0 {up|down}"
        exit 1
        ;;
    esac
  '';
in {

  home.packages = [ brightness-control ];

  home.file.".config/niri/config.kdl".source = ./config.kdl;

  # Environment variables for niri session
  home.sessionVariables = {
    # Wayland specific
    NIXOS_OZONE_WL = "1";  # Enable Wayland support for Electron apps (VSCode, etc.)
    MOZ_ENABLE_WAYLAND = "1";  # Firefox Wayland support

    # VSCode specific
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
  };

  # Services needed for niri
  services.gnome-keyring = {
    enable = true;
    components = [ "pkcs11" "secrets" "ssh" ];
  };

  # PolKit authentication agent for 1Password system authentication
  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    Unit = {
      Description = "polkit-gnome-authentication-agent-1";
      Wants = [ "graphical-session.target" ];
      WantedBy = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  # set cursor size and dpi for 4k monitor
  # 注释掉以避免与 sway 配置冲突
  # xresources.properties = {
  #   "Xcursor.size" = 16;
  #   "Xft.dpi" = 192;
  # };

  # 直接以 text 的方式，在 nix 配置文件中硬编码文件内容
  # home.file.".xxx".text = ''
  #     xxx
  # '';
}
