{
  description = "Drei's Generic Desktop System";

  inputs = {
    # System packages
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    # KDE Kalendar
    kalendar.url = "github:KDE/kalendar?ref=master";
  };

  outputs = { self, nixpkgs, ... } @inputs: {
    nixosConfigurations.ddrhckrzz-nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix
        ];
    };
  };
}
