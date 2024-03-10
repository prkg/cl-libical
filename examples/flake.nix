{
  description = "cl-libical example flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    cl-libical.url = "github:prkg/cl-libical";
  };
  outputs = { self, nixpkgs, cl-libical }:
    let
      supportedSystems = [ "x86_64-linux" "x86_64-darwin" ];
      forAllSystems = f:
        nixpkgs.lib.genAttrs supportedSystems (system: f system);
      nixpkgsFor = forAllSystems (system:
        import nixpkgs {
          inherit system;
          overlays = [ cl-libical.overlays.default ];
        });
    in {
      devShells = forAllSystems (system:
        let pkgs = nixpkgsFor.${system};
        in {
          default = pkgs.mkShell {
            buildInputs = with pkgs;
              [ (sbcl.withPackages (ps: [ ps.cl-libical ])) ];
            shellHook = ''
              export CL_SOURCE_REGISTRY="$(pwd)"
            '';
          };
        });
    };
}
