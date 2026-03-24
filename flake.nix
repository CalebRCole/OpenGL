{
  description = "OpenGL Renderer";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    zig.url = "github:mitchellh/zig-overlay";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      zig,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        zig-pkg = zig.packages.${system}.master;
      in
      {
        devShells.default = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            zig-pkg
            zls
            pkg-config
            gdb
            valgrind
          ];

          buildInputs = with pkgs; [
            glfw
            libGL
          ];

          shellHook = ''
            echo "--- Development Environment ---"
            echo "Targeting: ${system}"
            export LD_LIBRARY_PATH="${
              pkgs.lib.makeLibraryPath [
                pkgs.glfw
                pkgs.libGL
              ]
            }:$LD_LIBRARY_PATH"
          '';
        };
      }
    );
}
