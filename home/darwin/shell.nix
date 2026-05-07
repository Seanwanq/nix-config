{ ... }:
{
  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      shellAliases = {
        vpn-work = "sudo openconnect --user=siyuan.wang --authgroup=NDS-AnyConnect vpn.nds.global";
        z = "eza";
        f = "fastfetch";
      };
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" "sudo" ];
        theme = "robbyrussell";
      };
      sessionVariables = {
        PATH = "$HOME/.local/bin:$PATH";
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
