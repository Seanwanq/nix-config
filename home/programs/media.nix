{
  pkgs,
  config,
  ...
}:
# media - control and enjoy audio/video
{
  # imports = [
  # ];

  home.packages = with pkgs; [
    # audio control
    pavucontrol       # PulseAudio/PipeWire volume control GUI
    playerctl         # Media player control
    pulsemixer        # Terminal-based mixer
    pwvucontrol       # PipeWire volume control (modern alternative to pavucontrol)
    helvum            # PipeWire patchbay
    easyeffects       # Audio effects for PipeWire
    # images
    imv
  ];

  programs = {
    mpv = {
      enable = true;
      defaultProfiles = ["gpu-hq"];
      scripts = [pkgs.mpvScripts.mpris];
    };

    obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs  # Wayland/wlroots screen capture for OBS
        obs-pipewire-audio-capture  # PipeWire audio capture
        obs-vaapi  # Intel VAAPI hardware encoding support
      ];
    };
  };


  services = {
    playerctld.enable = true;
    
    # Enable EasyEffects for advanced audio control
    easyeffects.enable = true;
  };
}