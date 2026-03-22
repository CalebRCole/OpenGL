{
  description = "OpenGL Renderer for Wayland";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells.default = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            zig
            zls
            pkg-config
            gdb
            valgrind
          ];

          buildInputs = with pkgs; [
            libGL
            libxkbcommon
            libX11
            libXcursor
            libXrandr
            libXinerama
            libXi
            wayland
            wayland-protocols
            pkg-config
          ];

          shellHook = ''
            echo "--- Zig C Development Environment ---"
            zig version
            echo "Targeting: x86_64-linux"
          '';

          LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath (with pkgs; [
            libGL
            libxkbcommon
            wayland
          ]);
        };
      }
    );
}
