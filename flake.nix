{
  description = "Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = inputs@{ self, nixpkgs,  ... }:
    let
      forAllSystems = function:
        nixpkgs.lib.genAttrs [
          "aarch64-linux"
          "aarch64-darwin"
          "i686-linux"
          "x86_64-darwin"
          "x86_64-linux"
        ] (system: function nixpkgs.legacyPackages.${system});

      devDeps = (with nixpkgs.pkgs; [
      ]);
      buildDeps = (with nixpkgs.pkgs; [
      ]);
      runtimeDeps = (with nixpkgs.pkgs; [
      ]);
    in
    {
      nixosModules = {
        wrapper = ./modules/sops;
        default = self.nixosModules.wrapper;
      };
      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell {
          packages = devDeps ++ buildDeps ++ runtimeDeps;
          LD_LIBRARY_PATH = "${pkgs.lib.makeLibraryPath runtimeDeps}";
        };
      });
    };
}
