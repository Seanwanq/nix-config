{ pkgs, lib, ... }: {
  services.xserver = {
    enable = true;

    displayManager.gdm = {
      enable = true;
      wayland = lib.mkDefault true;
    };

    desktopManager.gnome = {
      enable = true;
    };
  };

  # Provide additional GNOME tooling out of the box.
  environment.systemPackages = with pkgs; [
    gnome-tweaks
  ];

  # Ensure GNOME portals are available alongside other desktop portals.
  xdg.portal = {
    enable = lib.mkDefault true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gnome
    ];
  };

  services.gnome = {
    evolution-data-server.enable = lib.mkDefault true;
    gnome-keyring.enable = lib.mkDefault true;
  };

  programs.dconf.enable = true;
}
