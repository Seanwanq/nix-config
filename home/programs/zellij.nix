{ pkgs, nixpkgs-unstable, ... }:
let
  pkgs-unstable = import nixpkgs-unstable {
    system = pkgs.system;
    config.allowUnfree = true;
  };
in
{
  programs.zellij = {
    enable = false;
    package = pkgs-unstable.zellij;
    enableZshIntegration = true;
  };

}

