{
  description = "Drei's Generic Desktop System";

  inputs = {
    # System packages
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    # Zen Browser
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      # IMPORTANT: we're using "libgbm" and is only available in unstable so ensure
      # to have it up-to-date or simply don't specify the nixpkgs input
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # CTF Tools - curreently broken on my end
    # ctf-tools = {
    #   url = "github:NixenBiksen/ctf-nix";
    #   # inputs.nixpkgs.follows = "nixpkgs";
    # };
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
