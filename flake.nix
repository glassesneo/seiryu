{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = {
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
        nimbleFile = builtins.readFile ./seiryu.nimble;
        versionMatch = builtins.match ".*version *= *\"([0-9]+\\.[0-9]+\\.[0-9]+)\".*" nimbleFile;
        version = builtins.elemAt versionMatch 0;
      in {
        packages = {
          seiryu = pkgs.stdenvNoCC.mkDerivation {
            pname = "seiryu";
            inherit version;
            src = ./src;
            buildInputs = [pkgs.nim];
            installPhase = ''
              mkdir -p $out/nim
              cp -r $src $out/nim/seiryu
            '';
          };
        };
        devShells = {
          default = pkgs.mkShell {
            packages = with pkgs; [
              nim
              nimble
              nimlangserver
              nph
            ];
          };
        };
      }
    );
}
