{
  description = "cl-libical";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; };
  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "x86_64-darwin" ];
      forAllSystems = f:
        nixpkgs.lib.genAttrs supportedSystems (system: f system);
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
      lispLibs = lispPkgs: with lispPkgs; [ cffi cffi-libffi ];
      nativeLibs = pkgs: with pkgs; [ libical libffi ];
    in {
      overlays.default = final: prev: {
        sbcl = prev.sbcl.withOverrides (self: super: {
          cl-libical = prev.sbcl.buildASDFSystem {
            pname = "cl-libical";
            version = "0.0.1";
            src = ./.;
            systems = [ "cl-libical" "cl-libical/tests" ];
            lispLibs = (lispLibs prev.sbclPackages);
            nativeLibs = (nativeLibs prev);
          };
        });
      };
      devShells = forAllSystems (system:
        let pkgs = nixpkgsFor.${system};
        in {
          default = pkgs.mkShell {
            LD_LIBRARY_PATH = with pkgs; lib.makeLibraryPath (nativeLibs pkgs);
            buildInputs = with pkgs; [ (sbcl.withPackages lispLibs) ];
            shellHook = ''
              export CL_SOURCE_REGISTRY="$(pwd)"
            '';
          };
        });
    };
}
