{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, nixos-generators, nixos-hardware, ... }: {
    packages.x86_64-linux = {
      default = nixos-generators.nixosGenerate {
        system = "aarch64-linux";
        modules = [
          ./configuration.nix
        ];
        format = "sd-aarch64";
        
        # optional arguments:
        # explicit nixpkgs and lib:
        # pkgs = nixpkgs.legacyPackages.x86_64-linux;
        # lib = nixpkgs.legacyPackages.x86_64-linux.lib;
        # additional arguements to pass to modules:
        # specialArgs = { myExtraArg = "foobar"; };
      };
    };
  };
}
