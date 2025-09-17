{
  description = "templates-learning";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
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
      };
      pkgsCross = import nixpkgs {
        system = linux;
        config.allowUnfree = true;
        crossSystem = {
          config = "x86_64-w64-mingw32";
          libc = "msvcrt"; # This distinguishes the mingw (non posix) toolchain
        };
      };

    in
    {
      devShells.${linux} = {
        default = pkgs.mkShell {

          name = "sdl-dev-shell";
          shellHook = ''
            echo "Welcome to the development environment!"
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
            libGL
            libayatana-appindicator
            libdecor
            libdrm
            libjack2
            libpulseaudio
            libusb1
            libxkbcommon
            libgbm
            ninja
            pipewire
            sndio
            systemdLibs
            vulkan-headers
            vulkan-loader
            wayland
            wayland-scanner
            zenity
            doxygen
            doxygen_gui
          ];
        };
        windows = pkgsCross.mkShell {

          name = "sdl-dev-shell";
          shellHook = ''
            echo "Welcome to the development environment!"
            HOME=$PWD/replacement-home
            echo "${pkgsCross.stdenv.hostPlatform.emulator pkgsCross.buildPackages}"
          '';
          nativeBuildInputs = with pkgs; [
            cmake
            pkg-config
            gcc
            clang-tools
            # gnumake
            ninja
            wine
            wine64
            winetricks
            gdb
          ];

          buildInputs = with pkgsCross; [
            sdl3
          ];
        };
      };

    };
}
