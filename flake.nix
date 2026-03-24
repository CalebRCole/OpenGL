{
  description = "OpenGL Renderer";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    zig.url = "github:mitchellh/zig-overlay";
    nixgl.url = "github:nix-community/nixGL";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      zig,
      nixgl,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        zig-pkg = zig.packages.${system}.master;
        nixGL_wrap = nixgl.packages.${system}.nixGLDefault;
      in
      {
        devShells.default = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            bear
            clang-tools
            zig-pkg
            zls
            pkg-config
            gdb
            valgrind
            nixGL_wrap
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
            alias zig="${nixGL_wrap}/bin/nixGL zig"
          '';
        };
      }
    );
}
