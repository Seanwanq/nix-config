{
  pkgs,
  lib,
  ...
}: {
  home.packages = [pkgs.gh];

  programs.git = {
    enable = true;
    # ... Other options ...
  };
}