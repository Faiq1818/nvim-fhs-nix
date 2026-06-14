# Neovim FHS wrapper for Nix Environment
Use your default `.config/nvim/` normally without worrying about complicated Neovim Nix distributions.

## How it works

If you've tried running Neovim on NixOS, you've probably faced this issue: package managers like Mason or treesitter compilers download pre-compiled binaries (like LSPs, formatters, and linters) that crash immediately. This happens because NixOS doesn't use the standard Linux directory layout, so those binaries can't find core libraries (like `glibc`) or standard commands.

This project solves this by tricking Neovim and its spawned plugins/LSPs into thinking they are running on a standard Linux distribution (like Ubuntu or Arch) using a Filesystem Hierarchy Standard (FHS) sandbox.

## Installing

### Using nix profile

```sh
nix profile add github:faiq1818/nvim-fhs-nix
```
