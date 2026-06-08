{ ... }:
{
  home = {
    username = "siyuan";
    homeDirectory = "/Users/siyuan";
    stateVersion = "26.05";

    sessionVariables = {
      EDITOR = "nvim";
      PATH = "$HOME/.local/bin:$PATH";
      DELTA_PAGER = "less -R";
    };
  };

  targets.darwin = {
    # Use symlink-based app exposure to avoid App Management permission prompts.
    copyApps.enable = false;
    linkApps.enable = true;
  };

  programs.home-manager.enable = true;
}
