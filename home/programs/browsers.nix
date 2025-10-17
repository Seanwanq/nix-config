{
  pkgs,
  config,
  username,
  ...
}: let
  # Create a Chrome wrapper with optimized flags
  google-chrome-optimized = pkgs.writeShellScriptBin "google-chrome" ''
    exec ${pkgs.google-chrome}/bin/google-chrome-stable \
      --disable-features=GCMDriver \
      --disable-background-networking \
      --enable-features=VaapiVideoDecoder,VaapiVideoEncoder \
      "$@"
  '';
in {
  # Install browsers with optimized Chrome wrapper
  home.packages = [
    google-chrome-optimized
    pkgs.google-chrome  # Keep original available as google-chrome-stable
  ];

  programs = {
    firefox = {
      enable = true;
      profiles.${username} = {};
    };
  };
}