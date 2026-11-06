{ ... }:
{
  # ============================================================================
  # Sean's Home Manager Configuration for NixOS-WSL
  # ============================================================================

  imports = [
    ../../home/linux
    ../../home/linux/wsl.nix
    ../../home/linux/niri.nix
  ];
}
