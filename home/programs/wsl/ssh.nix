{ config, pkgs, lib, ... }:

{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    # addKeysToAgent = "yes";
    
  };

  # SSH Agent service
  services.ssh-agent = {
    enable = true;
  };

}