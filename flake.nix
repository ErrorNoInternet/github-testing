{
  description = "ErrorNoInternet's NixOS flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-on-droid = {
      url = "github:nix-community/nix-on-droid/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    agenix.url = "github:ryantm/agenix";
    nix-index-database.url = "github:nix-community/nix-index-database";
    attic.url = "github:zhaofengli/attic";
    hsize.url = "github:ErrorNoInternet/hsize";
    hyprland.url = "github:hyprwm/Hyprland";
    hyprwm-contrib.url = "github:hyprwm/contrib";
    nix-colors.url = "github:misterio77/nix-colors";
    nix-gaming.url = "github:fufexan/nix-gaming";
    spicetify-nix.url = "github:the-argus/spicetify-nix";
    yazi.url = "github:sxyazi/yazi";
  };

  outputs = {
    self,
    flake-parts,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        ./packages
        ./workstation
        ./server
        ./home-manager
        ./nix-on-droid
      ];
      systems = ["x86_64-linux" "aarch64-linux"];
      perSystem = {pkgs, ...}: {
        _module.args = {inherit self;};
        formatter = pkgs.alejandra;

        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            alejandra
            git
          ];
          name = "configuration.nix-shell";
        };
      };
    };
}
