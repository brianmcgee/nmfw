{inputs, ...}: {
  imports = [
    inputs.flake-parts.flakeModules.easyOverlay
  ];

  perSystem = {
    lib,
    pkgs,
    self',
    inputs',
    ...
  }: let
    inherit (inputs'.gomod2nix.legacyPackages) buildGoApplication;
  in {
    packages = rec {
      protoc-gen-go-nmfw = buildGoApplication rec {
        pname = "protoc-gen-go-nmfw";
        version = "0.0.5+dev";

        # ensure we are using the same version of go to build with
        inherit (pkgs) go;

        src = ../.;
        modules = ../gomod2nix.toml;

        subPackages = [
          "protoc-gen-go-nmfw"
        ];

        doCheck = false;

        ldflags = [
          "-X 'build.Name=${pname}'"
          "-X 'build.Version=${version}'"
        ];

        meta = with lib; {
          description = "A protobuf based microservice framework powered by NATS Micro";
          homepage = "https://github.com/ripienaar/nmfw";
          license = licenses.mit;
          mainProgram = "protoc-gen-go-nmfw";
        };
      };

      default = protoc-gen-go-nmfw;

      example = buildGoApplication rec {
        pname = "nmfw-example";
        version = "0.0.5+dev";

        # ensure we are using the same version of go to build with
        inherit (pkgs) go;

        src = ../example;
        modules = ../example/gomod2nix.toml;

        doCheck = false;

        ldflags = [
          "-X 'build.Name=${pname}'"
          "-X 'build.Version=${version}'"
        ];

        meta = with lib; {
          description = "An example using https://github.com/ripienaar/nmfw";
          homepage = "https://github.com/ripienaar/nmfw/example";
          license = licenses.mit;
          mainProgram = "calc";
        };
      };
    };

    overlayAttrs = self'.packages;
  };
}
