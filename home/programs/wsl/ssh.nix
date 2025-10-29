{ config, pkgs, lib, ... }:

{
  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
    
  };

  # SSH Agent service
  services.ssh-agent = {
    enable = true;
  };

}