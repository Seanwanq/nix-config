{pkgs, ... }: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    profiles = {
      base = {

      };
      nix = {

      };
    };
  };
}
