{
  inputs,
  lib,
  ...
}: {
  imports = [
    inputs.devshell.flakeModule
  ];

  config.perSystem = {
    pkgs,
    config,
    system,
    self',
    ...
  }: let
    inherit (pkgs.stdenv) isLinux isDarwin;
  in {
    config.devshells.default = {
      env = [
        {
          name = "GOROOT";
          value = pkgs.go + "/share/go";
        }
        {
          name = "LD_LIBRARY_PATH";
          value = "$DEVSHELL_DIR/lib";
        }
      ];

      packages = with lib;
        mkMerge [
          [
            # golang
            pkgs.go
            pkgs.gotools
            pkgs.pprof
            pkgs.rr
            pkgs.delve
            pkgs.golangci-lint
            pkgs.protobuf
            pkgs.protoc-gen-go

            # add protoc-gen-go-nmfw to the path
            self'.packages.protoc-gen-go-nmfw
          ]
          # platform dependent CGO dependencies
          (mkIf isLinux [
            pkgs.gcc
          ])
          (mkIf isDarwin [
            pkgs.darwin.cctools
          ])
        ];

      commands = [
        {
          category = "nix";
          package = inputs.gomod2nix.packages.${system}.default;
        }
        {
          category = "example";
          name = "calc";
          help = "An example service build with nmfw";
          command = "${self'.packages.example}/bin/calc $@";
        }
      ];
    };
  };
}
