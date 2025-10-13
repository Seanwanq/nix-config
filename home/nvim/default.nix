{
  pkgs,
  config,
  ...
}: {
  home.file.".config/nvim".source = ./nvim-config;


}