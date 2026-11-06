{
  description = "NixOS configuration of Sean";

  # the nixConfig here only affects the flake itself, not the system configuration!
  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvim-config = {
      url = "github:Seanwanq/nvim-config";
      flake = false;
    };
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, home-manager, nix-darwin, ... }: let
    # NixOS 主机 + Home Manager（用户 sean）
    mkNixos = { host, home }: let
      username = "sean";
      specialArgs = { inherit inputs username nixpkgs-unstable; };
    in
      nixpkgs.lib.nixosSystem {
        inherit specialArgs;

        modules = [
          ./hosts/${host}
          ./users/${username}/nixos.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";

            home-manager.extraSpecialArgs = specialArgs;
            home-manager.users.${username} = {
              imports = [ ./users/${username}/${home} ];
            };
          }
        ];
      };
  in {
    nixosConfigurations = {
      # Hyper-V 虚拟机，无图形界面
      nixos-hv = mkNixos { host = "nixos-hv"; home = "home-hv.nix"; };

      # WSL2（NixOS-WSL），图形程序走 WSLg
      nixos-wsl = mkNixos { host = "nixos-wsl"; home = "home-wsl.nix"; };
    };

    # ========================================================================
    # nix-darwin 配置（MacBook Pro）
    # ========================================================================
    darwinConfigurations."Siyuans-MacBook-Pro" = let
      username = "siyuan";
      specialArgs = { inherit inputs username; };
    in
      nix-darwin.lib.darwinSystem {
        inherit specialArgs;

        modules = [
          ./hosts/macbook

          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";

            home-manager.extraSpecialArgs = specialArgs // {
              nixpkgs-unstable = inputs.nixpkgs-unstable;
              nvim-config = inputs.nvim-config;
            };
            home-manager.users.${username} = {
              imports = [ ./users/siyuan/home-mbp.nix ];
            };
          }
        ];
      };
  };
}
