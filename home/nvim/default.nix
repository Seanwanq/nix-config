{
  pkgs,
  config,
  ...
}: {
  home.file.".config/nvim/config".source = ./nvim-config;


}