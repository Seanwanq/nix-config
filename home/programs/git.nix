{
  pkgs,
  lib,
  ...
}: {
  home.packages = [pkgs.gh];

  programs.git = {
    enable = true;

    # 1Password SSH signing support (optional)
    # To enable, uncomment the following and set your signing key
    extraConfig = {
      gpg = {
        format = "ssh";
      };
      "gpg \"ssh\"" = {
        program = "${lib.getExe' pkgs._1password-gui "op-ssh-sign"}";
      };
      commit = {
        gpgsign = true;
      };
      user = {
        signingKey = "ssh-ed25519 AAAAC3... your-key-here";
      };
    };

    # ... Other options ...
  };
}