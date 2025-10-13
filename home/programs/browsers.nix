{
  pkgs,
  config,
  username,
  ...
}: {
  programs = {
    chromium = {
      enable = false;
      commandLineArgs = ["--enable-features=TouchpadOverscrollHistoryNavigation"];
      extensions = [
        # {id = "";}  // extension id, query from chrome web store
      ];
    };

    firefox = {
      enable = true;
      profiles.${username} = {};
    };
  };
}