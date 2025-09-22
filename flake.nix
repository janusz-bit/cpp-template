{
  description = "templates-learning";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      ...
    }@inputs:
    let
      linux = "x86_64-linux";
      pkgs = import nixpkgs {
        system = linux;
        config.allowUnfree = true;
        overlays = [ inputs.nix-vscode-extensions.overlays.default ];
      };

    in
    {
      devShells.${linux} = {
        default = pkgs.mkShell {

          name = "sdl-dev-shell";
          shellHook = ''
            echo "Welcome to the development environment!"
            echo "For IDE type: codium ."
          '';
          buildInputs = with pkgs; [
            cmake
            pkg-config
            gcc
            clang-tools
            clang
            # clang-analyzer
            python3
            # gnumake
            ninja
            # sdl3
            gdb
            (vscode-with-extensions.override {
              vscode = vscodium;
              vscodeExtensions = with pkgs.vscode-marketplace; [
                ms-vscode.cpptools
                llvm-vs-code-extensions.vscode-clangd
                ms-vscode.cmake-tools
                jnoortheen.nix-ide
              ];
            })
          ];
        };
      };

      templates.default = {
        path = ./.;
        description = "C++ template";
      };

    };
}
