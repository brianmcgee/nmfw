{inputs, ...}: {
  imports = [
    inputs.flake-root.flakeModule
    ./checks.nix
    ./dev
    ./devshell.nix
    ./formatter.nix
    ./packages.nix
  ];
}
