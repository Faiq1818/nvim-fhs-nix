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
        # Change this name if you want to use a different name or multiple Neovim executable names
        name = "nvim";

        targetPkgs =
          pkgs: with pkgs; [
            neovim

            # Add the plugin dependencies here
            # Mason dependencies
            git
            curl
            unzip
            gnutar
            gzip

            # Mason sometimes uses these package managers, you can remove them if you don't want them
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
