{ pkgs, nixpkgs-unstable, ... }:
let
  pkgs-unstable = import nixpkgs-unstable {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };
in
{
  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      initContent = ''
        eval "$(fnm env --use-on-cd --shell zsh)"
      '';
      shellAliases = {
        z = "eza";
        f = "fastfetch";
      };
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" "sudo" ];
        theme = "robbyrussell";
      };
      sessionVariables = {
        PATH = "$HOME/.cargo/bin:$HOME/.local/bin:$PATH";
        EDITOR = "nvim";
        VISUAL = "nvim";
        DOTNET_ROOT = "${pkgs-unstable.dotnet-sdk_10}/share/dotnet";
      };
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableZshIntegration = true;
    };

    skim = {
      enable = true;
      enableZshIntegration = true;
      defaultCommand = "rg --files --hidden";
    };
  };
}
