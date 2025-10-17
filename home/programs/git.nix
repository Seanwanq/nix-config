{
  pkgs,
  lib,
  ...
}: {
  home.packages = [pkgs.gh];

  programs.git = {
    enable = true;

    # 1Password SSH signing support
    extraConfig = {
      # gpg = {
      #   format = "ssh";
      # };
      # "gpg \"ssh\"" = {
      #   program = "${lib.getExe' pkgs._1password-gui "op-ssh-sign"}";
      # };
      # commit = {
      #   gpgsign = true;
      # };
      # user = {
      #   signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN8ur45YJC74iBp83upb4HuoFDfGXzgP88uF9LXmtHTB";
      # };
    };

    # ... Other options ...
  };
}