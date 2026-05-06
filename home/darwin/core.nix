{ ... }:
{
  home = {
    username = "siyuan";
    homeDirectory = "/Users/siyuan";
    stateVersion = "25.11";

    sessionVariables = {
      EDITOR = "nvim";
      PATH = "$HOME/.local/bin:$PATH";
      DELTA_PAGER = "less -R";
    };
  };

  programs.home-manager.enable = true;
}
