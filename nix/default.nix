{inputs, ...}: {
  imports = [
    inputs.flake-root.flakeModule
    ./checks.nix
    ./devshell.nix
    ./formatter.nix
  ];
}
