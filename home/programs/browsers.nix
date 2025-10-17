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
  # Both Chrome and Firefox will automatically support 1Password browser extension
  # native messaging when installed via NixOS (requires system-level 1Password config)
  home.packages = [
    google-chrome-optimized
    pkgs.google-chrome  # Keep original available as google-chrome-stable
  ];

  programs = {
    firefox = {
      enable = true;
      profiles.${username} = {
        # 1Password browser extension will automatically work with NativeMessaging
        # when Firefox is installed via NixOS and 1Password is configured system-wide
        settings = {
          # Enable native messaging for 1Password
          "security.webauth.webauthn" = true;
          "security.webauth.webauthn_enable_softtoken" = true;
          "security.webauth.webauthn_enable_usbtoken" = true;
        };
      };
    };
  };
}