{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      neovim-fhs = pkgs.buildFHSEnv {
        name = "nvim-fhs";

        targetPkgs =
          pkgs: with pkgs; [
            neovim

            # Mason dependencies
            git
            curl
            unzip
            gnutar
            gzip

            # Mason sometimes use this package managers, you can remove it if you don't want it
            gcc
            cargo

            ripgrep
            gnumake
            fd

            glibc
            stdenv.cc.cc.lib
          ];

        multiPkgs =
          pkgs: with pkgs; [
            zlib
          ];

        runScript = pkgs.writeShellScript "nvim-wrapper" ''
          unset VIMINIT
          unset VIM
          unset MYVIMRC

          export PATH="$PATH:/run/current-system/sw/bin:/etc/profiles/per-user/$USER/bin"

          exec nvim "$@"
        '';
      };
    in
    {
      packages.${system}.default = neovim-fhs;

      apps.${system}.default = {
        type = "app";
        program = "${neovim-fhs}/bin/nvim";
      };

      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [ neovim-fhs ];
      };
    };
}
