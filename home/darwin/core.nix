{ _, ... }:
{
  home = {
    username = "siyuan";
    homeDirectory = "/Users/siyuan";
    stateVersion = "26.05";

    sessionVariables = {
      EDITOR = "nvim";
      DELTA_PAGER = "less -R";
    };
  };

  targets.darwin = {
    copyApps.enable = false;
    linkApps.enable = true;
  };

  programs.home-manager.enable = true;
}
