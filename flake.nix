{
  description = "Drei's Generic Desktop System";

  inputs = {
    # System packages
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    # Zen Browser
    zen-browser.url = "github:MarceColl/zen-browser-flake";
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
