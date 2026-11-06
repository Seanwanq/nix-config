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

    nvim-config = {
      url = "github:Seanwanq/nvim-config";
      flake = false;
    };
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, home-manager, nix-darwin, ... }: {
    # ========================================================================
    # NixOS（Hyper-V 虚拟机，无图形界面）
    # ========================================================================
    nixosConfigurations.nixos-hv = let
      username = "sean";
      specialArgs = { inherit inputs username nixpkgs-unstable; };
    in
      nixpkgs.lib.nixosSystem {
        inherit specialArgs;

        modules = [
          ./hosts/nixos-hv
          ./users/${username}/nixos.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";

            home-manager.extraSpecialArgs = specialArgs;
            home-manager.users.${username} = {
              imports = [ ./users/${username}/home-hv.nix ];
            };
          }
        ];
      };

    # ========================================================================
    # Home Manager 独立配置（WSL）
    # ========================================================================
    homeConfigurations."sean@wsl" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      extraSpecialArgs = {
        inherit inputs nixpkgs-unstable;
        username = "sean";
      };

      modules = [ ./users/sean/home-wsl.nix ];
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
