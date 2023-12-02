{inputs, ...}: let
  defaultModule = {
    imports = [
      inputs.agenix.nixosModules.default
      ../shared
      ./common.nix
    ];
  };
  inherit (inputs.nixpkgs.lib) nixosSystem;
in {
  flake.nixosConfigurations = {
    Crix = nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        defaultModule
        ../shared/caches/ErrorNoBinaries.nix
        ../shared/modules/wireless.nix
        ./hosts/Crix/Crix.nix
        ./hosts/Crix/hardware-configuration.nix
        ./locations/china.nix
        ./modules/bootloader.nix
        ./profiles/minecraft-server.nix
      ];
    };
    Pix = nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        defaultModule
        ../shared/caches/ErrorNoBinaries.nix
        ../shared/modules/raspberry-pi.nix
        ./hosts/Pix/hardware-configuration.nix
        ./hosts/Pix/Pix.nix
        ./locations/china.nix
        ./modules/attic-cache.nix
        ./modules/nfs.nix
        ./modules/printing.nix
        ./modules/samba.nix
        ./programs/fish.nix
      ];
    };
  };
}
