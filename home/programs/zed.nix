{ pkgs, nixpkgs-unstable, ... }:
let
  pkgs-unstable = import nixpkgs-unstable {
    system = pkgs.system;
    config.allowUnfree = true;
  };
in
{
  programs.zed-editor = {
    enable = true;
    package = pkgs-unstable.zed-editor;
  };

}
