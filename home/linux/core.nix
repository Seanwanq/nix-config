{ username, ... }:
{
  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    stateVersion = "26.05";

    sessionVariables = {
      EDITOR = "nvim";
      DELTA_PAGER = "less -R";
    };
  };

  programs.home-manager.enable = true;
}
