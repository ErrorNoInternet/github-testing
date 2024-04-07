{
  inputs = {
    errornointernet.url = "github:ErrorNointernet/configuration.nix";
    hsize.url = "github:ErrorNointernet/hsize";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = {
    nixpkgs,
    rust-overlay,
    self,
    hsize,
    ...
  }: let
    system = "armv7l-linux";
    pkgs = import nixpkgs {
      inherit system;
      overlays = [rust-overlay.overlays.default];
    };
    rust = pkgs.rust-bin.nightly.latest.default.override {
      targets = [
        "x86_64-pc-windows-gnu"
        "x86_64-unknown-linux-gnu"
        "x86_64-unknown-linux-musl"
      ];
      extensions = [
        "rust-src"
        "rust-analyzer-preview"
      ];
    };
  in {
    packages.armv7l-linux = {
      hsize = pkgs.callPackage "${hsize}" {inherit rust self;};
    };
  };

  description = "real";
}
